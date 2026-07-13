import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/views/components/shared/position_board.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';

class ResultShareSection extends StatefulWidget {
  final AppModel appModel;
  final Future<void> Function(Uint8List bytes)? shareOverride;

  const ResultShareSection({
    super.key,
    required this.appModel,
    this.shareOverride,
  });

  @override
  State<ResultShareSection> createState() => _ResultShareSectionState();
}

class _ResultShareSectionState extends State<ResultShareSection> {
  final _cardKey = GlobalKey();
  bool _sharing = false;

  Future<void> _shareResult() async {
    if (_sharing) return;
    setState(() => _sharing = true);
    try {
      await WidgetsBinding.instance.endOfFrame;
      final boundary =
          _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      final bytes = byteData.buffer.asUint8List();
      if (!mounted) return;

      if (widget.shareOverride != null) {
        await widget.shareOverride!(bytes);
        return;
      }

      final renderBox = context.findRenderObject() as RenderBox?;
      final shareOrigin = renderBox == null
          ? null
          : renderBox.localToGlobal(Offset.zero) & renderBox.size;
      final strings = S.of(context);
      await SharePlus.instance.share(
        ShareParams(
          title: strings.Chess_Room_Result,
          text: _resultText(widget.appModel, strings),
          files: [XFile.fromData(bytes, mimeType: 'image/png')],
          fileNameOverrides: const ['chess-room-result.png'],
          sharePositionOrigin: shareOrigin,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _sharing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final game = widget.appModel.game;
    if (game == null) return const SizedBox.shrink();
    final result = _resultText(widget.appModel, strings);
    final moveCount = (widget.appModel.moveMetaList.length / 2).ceil();

    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: RepaintBoundary(
            key: _cardKey,
            child: ResultCard(
              board: game.board,
              result: result,
              moveCount: strings.Move_Count(moveCount),
              pieceTheme: widget.appModel.pieceTheme,
              flipped: widget.appModel.playingWithAI &&
                  widget.appModel.playerSide == Player.player2,
            ),
          ),
        ),
        const SizedBox(height: 14),
        CupertinoButton.filled(
          key: const ValueKey('share-result-button'),
          onPressed: _sharing ? null : _shareResult,
          child: _sharing
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CupertinoActivityIndicator(),
                    const SizedBox(width: 10),
                    Text(strings.Sharing_Result),
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(CupertinoIcons.share),
                    const SizedBox(width: 8),
                    Text(strings.Share_Result),
                  ],
                ),
        ),
      ],
    );
  }
}

class ResultCard extends StatelessWidget {
  final ChessBoard board;
  final String result;
  final String moveCount;
  final String pieceTheme;
  final bool flipped;

  const ResultCard({
    super.key,
    required this.board,
    required this.result,
    required this.moveCount,
    required this.pieceTheme,
    this.flipped = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff2d251b), Color(0xff6b5030)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xffd7b56d), width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'CHESS ROOM',
            style: TextStyle(
              color: Color(0xfff1d99b),
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 280,
            child: PositionBoard(
              board: board,
              pieceTheme: pieceTheme,
              flipped: flipped,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            result,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: CupertinoColors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            moveCount,
            style: const TextStyle(color: Color(0xffead9bd), fontSize: 15),
          ),
        ],
      ),
    );
  }
}

String _resultText(AppModel appModel, S strings) {
  if (appModel.stalemate) return strings.Stalemate;
  if (appModel.playerCount == 1) {
    return appModel.isAIsTurn ? '${strings.You_Win}!' : strings.You_Lose;
  }
  return appModel.turn == Player.player1
      ? strings.Black_Wins
      : strings.White_Wins;
}
