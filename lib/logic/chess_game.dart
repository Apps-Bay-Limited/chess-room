import 'package:async/async.dart';
import 'package:chess_room/logic/chess_piece_sprite.dart';
import 'package:chess_room/logic/chess_tip.dart';
import 'package:chess_room/logic/move_calculation/ai_move_calculation.dart';
import 'package:chess_room/logic/move_calculation/move_calculation.dart';
import 'package:chess_room/logic/move_calculation/move_classes/move_meta.dart';
import 'package:chess_room/logic/shared_functions.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/model/game_review.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'chess_board.dart';
import 'chess_piece.dart';
import 'move_calculation/move_classes/move.dart';

class ChessGame extends Game with TapDetector {
  late double width;
  late double tileSize;
  AppModel appModel;
  BuildContext context;
  ChessBoard board = ChessBoard();
  Map<ChessPiece, ChessPieceSprite> spriteMap = Map();

  late CancelableOperation aiOperation;
  CancelableOperation<Move?>? tipOperation;
  List<int> validMoves = [];
  ChessPiece? selectedPiece;
  int? checkHintTile;
  Move? latestMove;
  Move? tipMove;

  ChessGame(this.appModel, this.context) {
    width = MediaQuery.of(context).size.width - 68;
    tileSize = width / 8;
    aiOperation = CancelableOperation.fromValue(null);
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece] = ChessPieceSprite(piece, appModel.pieceTheme);
    }
    _initSpritePositions();
    if (appModel.isAIsTurn) {
      _aiMove();
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (appModel.gameOver || !appModel.isAIsTurn) {
      _cancelTip();
      tipMove = null;
      var tile = _vector2ToTile(info.eventPosition.widget);
      if (tile < 0 || tile > 63) return;
      var touchedPiece = board.tiles[tile];
      if (touchedPiece == selectedPiece) {
        validMoves = [];
        selectedPiece = null;
      } else {
        if (selectedPiece != null &&
            touchedPiece != null &&
            touchedPiece.player == selectedPiece?.player) {
          if (validMoves.contains(tile)) {
            _movePiece(tile);
          } else {
            validMoves = [];
            _selectPiece(touchedPiece);
          }
        } else if (selectedPiece == null && touchedPiece != null) {
          _selectPiece(touchedPiece);
        } else {
          _movePiece(tile);
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    _drawBoard(canvas);
    if (appModel.showHints) {
      _drawCheckHint(canvas);
      _drawLatestMove(canvas);
    }
    _drawSelectedPieceHint(canvas);
    _drawTipMove(canvas);
    _drawPieces(canvas);
    if (appModel.showHints) {
      _drawMoveHints(canvas);
    }
  }

  @override
  void update(double t) {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece]?.update(tileSize, appModel, piece);
    }
  }

  void _initSpritePositions() {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece]?.initSpritePosition(tileSize, appModel);
    }
  }

  void _selectPiece(ChessPiece piece) {
    if (piece.player == appModel.turn) {
      HapticFeedback.selectionClick();
      selectedPiece = piece;
      validMoves = movesForPiece(piece, board);
      // print('Selected piece: type=${piece.type}, tile=${piece.tile}, validMoves: $validMoves');
      if (validMoves.isEmpty) {
        selectedPiece = null;
      }
      update(0); // Force redraw
    }
  }

  void _movePiece(int tile) {
    if (validMoves.contains(tile)) {
      validMoves = [];
      final move = Move(selectedPiece!.tile, tile);
      final review = _reviewForMove(move);
      var meta = push(move, board, getMeta: true);
      appModel.pushMoveReview(review);
      HapticFeedback.mediumImpact();
      if (meta.promotion) {
        appModel.requestPromotion();
      }
      _moveCompletion(meta, changeTurn: !meta.promotion);
    }
  }

  void _aiMove() async {
    await Future.delayed(Duration(milliseconds: 500));
    var args = Map();
    args['aiPlayer'] = appModel.aiTurn;
    args['aiDifficulty'] = appModel.aiDifficulty;
    args['board'] = board;
    aiOperation = CancelableOperation.fromFuture(
      compute(calculateAIMove, args),
    );
    aiOperation.value.then((move) {
      if (move == null || appModel.gameOver) {
        appModel.endGame();
      } else {
        validMoves = [];
        final review = _reviewForMove(move);
        var meta = push(move, board, getMeta: true);
        appModel.pushMoveReview(review);
        HapticFeedback.lightImpact();
        _moveCompletion(meta, changeTurn: !meta.promotion);
        if (meta.promotion) {
          promote(move.promotionType);
        }
      }
    }).onError((error, stackTrace) {
      debugPrint('AI move calculation failed: $error');
      appModel.endGame();
    });
  }

  void cancelAIMove() {
    aiOperation.cancel();
    _cancelTip();
  }

  void undoMove() {
    board.redoStack.add(pop(board));
    appModel.popMoveReview();
    if (appModel.moveMetaList.length > 1) {
      var meta = appModel.moveMetaList[appModel.moveMetaList.length - 2];
      _moveCompletion(meta, clearRedo: false, undoing: true);
    } else {
      _undoOpeningMove();
      appModel.changeTurn();
    }
  }

  void undoTwoMoves() {
    board.redoStack.add(pop(board));
    board.redoStack.add(pop(board));
    appModel.popMoveReview();
    appModel.popMoveReview();
    appModel.popMoveMeta();
    if (appModel.moveMetaList.length > 1) {
      _moveCompletion(appModel.moveMetaList[appModel.moveMetaList.length - 2],
          clearRedo: false, undoing: true, changeTurn: false);
    } else {
      _undoOpeningMove();
    }
  }

  void _undoOpeningMove() {
    selectedPiece = null;
    validMoves = [];
    latestMove = null;
    checkHintTile = null;
    appModel.popMoveMeta();
  }

  void redoMove() {
    final moveStackObject = board.redoStack.removeLast();
    appModel.pushMoveReview(_reviewForMove(moveStackObject.move));
    _moveCompletion(pushMSO(moveStackObject, board), clearRedo: false);
  }

  void redoTwoMoves() {
    var moveStackObject = board.redoStack.removeLast();
    appModel.pushMoveReview(_reviewForMove(moveStackObject.move));
    _moveCompletion(pushMSO(moveStackObject, board),
        clearRedo: false, updateMetaList: true);
    moveStackObject = board.redoStack.removeLast();
    appModel.pushMoveReview(_reviewForMove(moveStackObject.move));
    _moveCompletion(pushMSO(moveStackObject, board),
        clearRedo: false, updateMetaList: true);
  }

  MoveReviewRecord _reviewForMove(Move move) {
    final movedPiece = board.tiles[move.from];
    final reachesPromotionRank = move.to ~/ 8 == 0 || move.to ~/ 8 == 7;
    final analyzedMove = movedPiece?.type == ChessPieceType.pawn &&
            reachesPromotionRank &&
            move.promotionType == ChessPieceType.promotion
        ? Move(
            move.from,
            move.to,
            promotionType: ChessPieceType.queen,
          )
        : move;
    return MoveReviewRecord.analyze(
      board: board,
      playedMove: analyzedMove,
      player: appModel.turn,
      moveIndex: appModel.moveMetaList.length,
    );
  }

  void promote(ChessPieceType type) {
    if (appModel.moveReviewRecords.isNotEmpty) {
      final previousReview = appModel.moveReviewRecords.last;
      final position = chessPositionFromFen(previousReview.positionBeforeFen);
      appModel.replaceLastMoveReview(
        MoveReviewRecord.analyze(
          board: position.board,
          playedMove: Move(
            previousReview.playedMove.from,
            previousReview.playedMove.to,
            promotionType: type,
          ),
          player: previousReview.player,
          moveIndex: previousReview.moveIndex,
        ),
      );
    }
    board.moveStack.last.movedPiece.type = type;
    board.moveStack.last.promotionType = type;
    addPromotedPiece(board, board.moveStack.last);
    appModel.moveMetaList.last.promotionType = type;
    _moveCompletion(appModel.moveMetaList.last, updateMetaList: false);
  }

  void _moveCompletion(
    MoveMeta meta, {
    bool clearRedo = true,
    bool undoing = false,
    bool changeTurn = true,
    bool updateMetaList = true,
  }) {
    if (clearRedo) {
      board.redoStack = [];
    }
    validMoves = [];
    tipMove = null;
    latestMove = meta.move;
    checkHintTile = null;
    var oppositeTurn = oppositePlayer(appModel.turn);
    if (kingInCheck(oppositeTurn, board)) {
      meta.isCheck = true;
      var king = kingForPlayer(oppositeTurn, board);
      if (king != null) {
        checkHintTile = king.tile;
      }
    }
    if (hasNoLegalMoves(oppositeTurn, board)) {
      if (!meta.isCheck) {
        appModel.stalemate = true;
        meta.isStalemate = true;
      }
      meta.isCheck = false;
      meta.isCheckmate = true;
      appModel.endGame();
    }
    if (undoing) {
      appModel.popMoveMeta();
      appModel.undoEndGame();
    } else if (updateMetaList) {
      appModel.pushMoveMeta(meta);
    }
    if (changeTurn) {
      appModel.changeTurn();
    }
    selectedPiece = null;
    if (appModel.isAIsTurn && clearRedo && changeTurn) {
      _aiMove();
    }
  }

  int _vector2ToTile(Vector2 vector2) {
    if (appModel.flip &&
        appModel.playingWithAI &&
        appModel.playerSide == Player.player2) {
      return (7 - (vector2.y / tileSize).floor()) * 8 +
          (7 - (vector2.x / tileSize).floor());
    } else {
      return (vector2.y / tileSize).floor() * 8 +
          (vector2.x / tileSize).floor();
    }
  }

  Future<void> showTip() async {
    if (appModel.gameOver || appModel.isAIsTurn || appModel.tipInProgress) {
      return;
    }
    final moveCount = board.moveCount;
    final turn = appModel.turn;
    final operation = CancelableOperation<Move?>.fromFuture(
      compute(calculateTipMove, {
        'board': board,
        'player': turn,
        'searchDepth': tipSearchDepth(appModel.aiDifficulty),
      }),
    );
    tipOperation = operation;
    appModel.setTipInProgress(true);

    final move = await operation.valueOrCancellation();
    if (tipOperation != operation) return;
    tipOperation = null;
    appModel.setTipInProgress(false);
    if (move == null ||
        appModel.gameOver ||
        appModel.turn != turn ||
        board.moveCount != moveCount) {
      return;
    }
    tipMove = move;
    selectedPiece = null;
    validMoves = [];
  }

  void _cancelTip() {
    tipOperation?.cancel();
    tipOperation = null;
    appModel.setTipInProgress(false);
  }

  void _drawBoard(Canvas canvas) {
    for (int tileNo = 0; tileNo < 64; tileNo++) {
      canvas.drawRect(
        Rect.fromLTWH(
          (tileNo % 8) * tileSize,
          (tileNo / 8).floor() * tileSize,
          tileSize,
          tileSize,
        ),
        Paint()
          ..color = (tileNo + (tileNo / 8).floor()) % 2 == 0
              ? appModel.theme.lightTile
              : appModel.theme.darkTile,
      );
    }
  }

  void _drawPieces(Canvas canvas) {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      var sprite = spriteMap[piece];
      if (sprite != null) {
        sprite.sprite.render(
          canvas,
          size: Vector2(tileSize - 10, tileSize - 10),
          position: Vector2(
            sprite.spriteX + 5,
            sprite.spriteY + 5,
          ),
        );
      }
    }
  }

  void _drawMoveHints(Canvas canvas) {
    for (var tile in validMoves) {
      canvas.drawCircle(
        Offset(
          getXFromTile(tile, tileSize, appModel) + (tileSize / 2),
          getYFromTile(tile, tileSize, appModel) + (tileSize / 2),
        ),
        tileSize / 5,
        Paint()..color = appModel.theme.moveHint,
      );
    }
  }

  void _drawTipMove(Canvas canvas) {
    final move = tipMove;
    if (move == null) return;
    final fromPaint = Paint()..color = AppColors.accent.withValues(alpha: 0.48);
    final toPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawRect(
      Rect.fromLTWH(
        getXFromTile(move.from, tileSize, appModel),
        getYFromTile(move.from, tileSize, appModel),
        tileSize,
        tileSize,
      ),
      fromPaint,
    );
    canvas.drawCircle(
      Offset(
        getXFromTile(move.to, tileSize, appModel) + tileSize / 2,
        getYFromTile(move.to, tileSize, appModel) + tileSize / 2,
      ),
      tileSize * 0.32,
      toPaint,
    );
  }

  void _drawLatestMove(Canvas canvas) {
    if (latestMove == null) return;
    canvas.drawRect(
      Rect.fromLTWH(
        getXFromTile(latestMove!.from, tileSize, appModel),
        getYFromTile(latestMove!.from, tileSize, appModel),
        tileSize,
        tileSize,
      ),
      Paint()..color = appModel.theme.latestMove,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        getXFromTile(latestMove!.to, tileSize, appModel),
        getYFromTile(latestMove!.to, tileSize, appModel),
        tileSize,
        tileSize,
      ),
      Paint()..color = appModel.theme.latestMove,
    );
  }

  void _drawCheckHint(Canvas canvas) {
    if (checkHintTile == null) return;
    canvas.drawRect(
      Rect.fromLTWH(
        getXFromTile(checkHintTile!, tileSize, appModel),
        getYFromTile(checkHintTile!, tileSize, appModel),
        tileSize,
        tileSize,
      ),
      Paint()..color = appModel.theme.checkHint,
    );
  }

  void _drawSelectedPieceHint(Canvas canvas) {
    if (selectedPiece == null) return;
    canvas.drawRect(
      Rect.fromLTWH(
        getXFromTile(selectedPiece!.tile, tileSize, appModel),
        getYFromTile(selectedPiece!.tile, tileSize, appModel),
        tileSize,
        tileSize,
      ),
      Paint()..color = appModel.theme.moveHint,
    );
  }
}
