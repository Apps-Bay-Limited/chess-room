import 'dart:async';
import 'dart:math';

import 'package:chess_room/logic/chess_game.dart';
import 'package:chess_room/logic/chess_notation.dart';
import 'package:chess_room/logic/move_calculation/move_classes/move_meta.dart';
import 'package:chess_room/logic/shared_functions.dart';
import 'package:chess_room/model/game_review.dart';
import 'package:chess_room/model/in_progress_game.dart';
import 'package:chess_room/features/game_history/saved_game.dart';
import 'package:chess_room/util/remove_ads_purchase_service.dart';
import 'package:chess_room/util/in_app_reviewer_helper.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_themes.dart';

const TIMER_ACCURACY_MS = 100;
const PIECE_THEMES = [
  'Classic',
  'Angular',
  '8-Bit',
  'Letters',
  'Video Chess',
  'Lewis Chessmen',
  'Mexico City'
];

class AppModel extends ChangeNotifier {
  final RemoveAdsPurchaseService purchaseService;
  final GameHistoryStore gameHistoryStore;
  final InProgressGameStore inProgressGameStore;
  final DateTime Function() _now;
  late final Future<void> purchaseInitialization;
  late final Future<void> initialization;
  InProgressGame? _pendingGame;
  Future<void> _persistenceQueue = Future<void>.value();
  bool _disposed = false;
  bool _notificationsSuppressed = false;
  bool _gamePaused = true;
  bool _gameSessionActive = false;
  int _gameRevision = 0;
  int _activePlayerCount = 1;
  int _activeAIDifficulty = 3;
  Player _activeSelectedSide = Player.player1;
  Player _activePlayerSide = Player.player1;
  int _activeTimeLimit = 0;

  int playerCount = 1;
  int aiDifficulty = 3;
  Player selectedSide = Player.player1;
  Player playerSide = Player.player1;
  int timeLimit = 0;
  String pieceTheme = 'Classic';
  String themeName = 'Green';
  bool showMoveHistory = true;
  bool allowUndoRedo = true;
  bool soundEnabled = true;
  bool showHints = true;
  bool showTipButton = true;
  bool tipInProgress = false;
  bool flip = true;
  bool _currentGameSaved = false;
  String _currentGameId = '';

  ChessGame? game;
  Timer? timer;
  DateTime? _lastTick;
  bool gameOver = false;
  bool stalemate = false;
  bool promotionRequested = false;
  bool moveListUpdated = false;
  Player turn = Player.player1;
  List<MoveMeta> moveMetaList = [];
  List<MoveReviewRecord> moveReviewRecords = [];
  Duration player1TimeLeft = Duration.zero;
  Duration player2TimeLeft = Duration.zero;

  List<String> get pieceThemes {
    var pieceThemes = List<String>.from(PIECE_THEMES);
    pieceThemes.sort();
    return pieceThemes;
  }

  AppTheme get theme {
    return themeList[themeIndex];
  }

  int get themeIndex {
    var themeIndex = 0;
    themeList.asMap().forEach((index, theme) {
      if (theme.name == themeName) {
        themeIndex = index;
      }
    });
    return themeIndex;
  }

  int get pieceThemeIndex {
    var pieceThemeIndex = 0;
    pieceThemes.asMap().forEach((index, theme) {
      if (theme == pieceTheme) {
        pieceThemeIndex = index;
      }
    });
    return pieceThemeIndex;
  }

  Player get aiTurn {
    return oppositePlayer(playerSide);
  }

  bool get isAIsTurn {
    return playingWithAI && (turn == aiTurn);
  }

  /// Whether a match is currently active (used to avoid showing interruptive
  /// ads, like the app-open ad, over an in-progress game).
  bool get gameInProgress {
    return _gameSessionActive && game != null && !gameOver;
  }

  bool get hasResumableGame => _pendingGame != null;

  bool get isGamePaused => _gamePaused;

  /// Uses the last setup selections rather than the settings of a restored
  /// match. Preparing a new match leaves its unfinished-game save untouched.
  Future<void> prepareQuickPlay() async {
    await initialization;
    final prefs = await SharedPreferences.getInstance();
    if (_disposed) return;
    playerCount = 1;
    _loadSetupOptions(prefs);
    notifyListeners();
  }

  bool get playingWithAI {
    return playerCount == 1;
  }

  bool get isAdsRemoved {
    return purchaseService.isAdsRemoved;
  }

  bool get canPurchaseRemoveAds {
    return purchaseService.isSupported;
  }

  MoveReviewRecord? get biggestMistake {
    final candidates = playingWithAI
        ? moveReviewRecords.where((record) => record.player == playerSide)
        : moveReviewRecords;
    MoveReviewRecord? biggest;
    for (final record in candidates) {
      if (biggest == null || record.evaluationLoss > biggest.evaluationLoss) {
        biggest = record;
      }
    }
    return biggest?.evaluationLoss == 0 ? null : biggest;
  }

  AppModel({
    RemoveAdsPurchaseService? purchaseService,
    GameHistoryStore? gameHistoryStore,
    InProgressGameStore? inProgressGameStore,
    DateTime Function()? now,
  })  : purchaseService = purchaseService ?? RemoveAdsPurchaseService(),
        gameHistoryStore =
            gameHistoryStore ?? SharedPreferencesGameHistoryStore(),
        inProgressGameStore =
            inProgressGameStore ?? SharedPreferencesInProgressGameStore(),
        _now = now ?? DateTime.now {
    this.purchaseService.addListener(notifyListeners);
    initialization = _initialize();
    purchaseInitialization = this.purchaseService.init();
  }

  Future<void> _initialize() async {
    final revision = _gameRevision;
    try {
      await loadSharedPrefs();
    } catch (_) {
      // Invalid preferences must not prevent loading an otherwise valid game.
    }
    try {
      final pending = await inProgressGameStore.load();
      if (!_disposed && revision == _gameRevision) {
        _pendingGame = pending;
      }
    } catch (_) {
      // A storage failure must not prevent a new match from starting.
    }
    if (!_disposed) notifyListeners();
  }

  @override
  void notifyListeners() {
    if (!_disposed && !_notificationsSuppressed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    timer?.cancel();
    game?.cancelAIMove();
    purchaseService.removeListener(notifyListeners);
    purchaseService.dispose();
    super.dispose();
  }

  void newGame(BuildContext context, {bool notify = true}) {
    _gameRevision++;
    game?.cancelAIMove();
    timer?.cancel();
    tipInProgress = false;
    _currentGameSaved = false;
    _currentGameId = 'game-${_now().microsecondsSinceEpoch}-'
        '${Random.secure().nextInt(1 << 32)}';
    gameOver = false;
    stalemate = false;
    turn = Player.player1;
    moveMetaList = [];
    moveReviewRecords = [];
    player1TimeLeft = Duration(minutes: timeLimit);
    player2TimeLeft = Duration(minutes: timeLimit);
    if (selectedSide == Player.random) {
      playerSide =
          Random.secure().nextInt(2) == 0 ? Player.player1 : Player.player2;
    }
    // White always starts, including when the human chooses Black.
    turn = Player.player1;
    _captureActiveSettings();
    _gamePaused = false;
    _gameSessionActive = true;
    promotionRequested = false;
    game = ChessGame(this, context);
    _startTimer();
    unawaited(saveInProgressGame());
    if (notify) {
      notifyListeners();
    }
  }

  void exitChessView({bool notify = true}) {
    _gameSessionActive = false;
    unawaited(pauseGame(notify: notify));
    if (notify) notifyListeners();
  }

  void _captureActiveSettings() {
    _activePlayerCount = playerCount;
    _activeAIDifficulty = aiDifficulty;
    _activeSelectedSide = selectedSide;
    _activePlayerSide = playerSide;
    _activeTimeLimit = timeLimit;
  }

  Future<bool> resumeGame(BuildContext context) async {
    await initialization;
    if (_disposed || !context.mounted) return false;
    final saved = _pendingGame;
    if (saved == null) return false;
    try {
      final restored = saved.restore();
      game?.cancelAIMove();
      timer?.cancel();
      _gameRevision++;
      _currentGameId = saved.sessionId ??
          'game-${_now().microsecondsSinceEpoch}-${Random.secure().nextInt(1 << 32)}';
      playerCount = saved.playerCount;
      aiDifficulty = saved.aiDifficulty;
      selectedSide = saved.selectedSide;
      playerSide = saved.playerSide;
      timeLimit = saved.timeLimit;
      _captureActiveSettings();
      turn = saved.turn;
      player1TimeLeft = Duration(milliseconds: saved.whiteTimeMs);
      player2TimeLeft = Duration(milliseconds: saved.blackTimeMs);
      moveMetaList = restored.metadata;
      moveReviewRecords = List.of(saved.reviews);
      moveListUpdated = true;
      gameOver = false;
      stalemate = false;
      _currentGameSaved = false;
      promotionRequested = restored.promotionPending;
      _gamePaused = true;
      _gameSessionActive = true;
      game = ChessGame(this, context,
          restoredBoard: restored.board, startAI: false);
      resumeGameSession();
      notifyListeners();
      return true;
    } catch (_) {
      await discardInProgressGame();
      return false;
    }
  }

  /// Stops the local match clock while the app or match is out of view.
  Future<void> pauseGame({bool notify = true}) {
    final previouslySuppressed = _notificationsSuppressed;
    _notificationsSuppressed = previouslySuppressed || !notify;
    try {
      if (!_gamePaused) _tickClock();
      _gamePaused = true;
      timer?.cancel();
      timer = null;
      _lastTick = null;
      game?.cancelAIMove();
      return saveInProgressGame();
    } finally {
      _notificationsSuppressed = previouslySuppressed;
    }
  }

  void resumeGameSession() {
    if (_disposed || !_gameSessionActive || game == null || gameOver) return;
    if (!_gamePaused) return;
    _gamePaused = false;
    _startTimer();
    if (!promotionRequested) game?.startAIIfNeeded();
  }

  void _startTimer() {
    timer?.cancel();
    _lastTick = _now();
    if (_activeTimeLimit == 0) return;
    timer = Timer.periodic(
        const Duration(milliseconds: TIMER_ACCURACY_MS), (_) => _tickClock());
  }

  void _tickClock() {
    if (_gamePaused || gameOver || _lastTick == null) return;
    final now = _now();
    final elapsedMs = now.difference(_lastTick!).inMilliseconds;
    _lastTick = now;
    if (elapsedMs <= 0 || _activeTimeLimit == 0) return;
    turn == Player.player1
        ? decrementPlayer1Timer(elapsedMs)
        : decrementPlayer2Timer(elapsedMs);
    if (player1TimeLeft == Duration.zero || player2TimeLeft == Duration.zero) {
      endGame();
    }
  }

  Future<void> _queuePersistence(Future<void> Function() action) {
    final next = _persistenceQueue.then((_) async {
      await initialization;
      await action();
    });
    // Serialize snapshots and deletion, including when an earlier write fails.
    _persistenceQueue = next.catchError((Object _) {});
    return _persistenceQueue;
  }

  Future<void> saveInProgressGame() {
    final current = game;
    if (current == null || gameOver || _disposed) return _persistenceQueue;
    final saved = InProgressGame(
      sessionId: _currentGameId,
      playerCount: _activePlayerCount,
      aiDifficulty: _activeAIDifficulty,
      selectedSide: _activeSelectedSide,
      playerSide: _activePlayerSide,
      timeLimit: _activeTimeLimit,
      turn: turn,
      whiteTimeMs: player1TimeLeft.inMilliseconds,
      blackTimeMs: player2TimeLeft.inMilliseconds,
      moves: current.board.moveStack
          .map(InProgressGame.copyStackMove)
          .toList(growable: false),
      redoMoves: current.board.redoStack.reversed
          .map(InProgressGame.copyStackMove)
          .toList(growable: false),
      reviews: List.of(moveReviewRecords),
    );
    final changed = _pendingGame == null;
    _pendingGame = saved;
    if (changed) {
      scheduleMicrotask(() {
        if (!_disposed) notifyListeners();
      });
    }
    return _queuePersistence(() => inProgressGameStore.save(saved));
  }

  Future<void> discardInProgressGame() {
    _gameRevision++;
    _pendingGame = null;
    if (!_disposed) notifyListeners();
    return _queuePersistence(inProgressGameStore.clear);
  }

  void pushMoveMeta(MoveMeta meta) {
    moveMetaList.add(meta);
    moveListUpdated = true;
    notifyListeners();
  }

  void popMoveMeta() {
    moveMetaList.removeLast();
    moveListUpdated = true;
    notifyListeners();
  }

  void pushMoveReview(MoveReviewRecord record) {
    moveReviewRecords.add(record);
  }

  void popMoveReview() {
    if (moveReviewRecords.isNotEmpty) {
      moveReviewRecords.removeLast();
    }
  }

  void replaceLastMoveReview(MoveReviewRecord record) {
    if (moveReviewRecords.isNotEmpty) {
      moveReviewRecords[moveReviewRecords.length - 1] = record;
    }
  }

  void endGame() {
    if (!gameOver) {
      HapticFeedback.heavyImpact();
    }
    gameOver = true;
    timer?.cancel();
    _lastTick = null;
    game?.cancelAIMove();
    unawaited(discardInProgressGame());
    notifyListeners();
    Future<void>.microtask(_saveCurrentGame);
  }

  Future<void> _saveCurrentGame() async {
    if (_currentGameSaved || moveMetaList.isEmpty) return;
    _currentGameSaved = true;
    final result = stalemate
        ? SavedGameResult.draw
        : turn == Player.player2
            ? SavedGameResult.whiteWin
            : SavedGameResult.blackWin;
    final playedAt = DateTime.now();
    final white = playerCount == 1 && playerSide == Player.player2
        ? 'Chess Room AI'
        : 'Player';
    final black = playerCount == 1 && playerSide == Player.player1
        ? 'Chess Room AI'
        : 'Player';
    final pgn = buildPgn(
      moves: moveMetaList,
      playedAt: playedAt,
      result: savedGameResultToPgn(result),
      white: white,
      black: black,
    );
    final gameRecord = SavedGame(
      id: _currentGameId,
      playedAt: playedAt,
      result: result,
      pgn: pgn,
      initialFen: standardStartingFen,
      moves: moveMetaList
          .map((meta) => moveToUci(meta.move))
          .toList(growable: false),
      reviews: List<MoveReviewRecord>.unmodifiable(moveReviewRecords),
    );
    try {
      await gameHistoryStore.saveGame(gameRecord);
      await InAppReviewHelper.shared.recordCompletedGame(gameRecord.id);
    } catch (_) {
      _currentGameSaved = false;
    }
  }

  void undoEndGame() {
    final wasGameOver = gameOver;
    gameOver = false;
    _currentGameSaved = false;
    if (wasGameOver && _gameSessionActive && !_gamePaused) _startTimer();
    notifyListeners();
  }

  void changeTurn() {
    _tickClock();
    turn = oppositePlayer(turn);
    notifyListeners();
  }

  void requestPromotion() {
    promotionRequested = true;
    notifyListeners();
  }

  void setPlayerCount(int count) {
    playerCount = count;
    notifyListeners();
  }

  void setAIDifficulty(int difficulty) {
    aiDifficulty = difficulty;
    unawaited(_persistGameOption('aiDifficulty', difficulty));
    notifyListeners();
  }

  void setPlayerSide(Player side) {
    selectedSide = side;
    if (side != Player.random) {
      playerSide = side;
    }
    unawaited(_persistGameOption('selectedSide', side.name));
    notifyListeners();
  }

  void setTimeLimit(int duration) {
    timeLimit = duration;
    unawaited(_persistGameOption('timeLimit', duration));
    notifyListeners();
  }

  void decrementPlayer1Timer([int elapsedMs = TIMER_ACCURACY_MS]) {
    if (player1TimeLeft.inMilliseconds > 0 && !gameOver) {
      final remainingMs = player1TimeLeft.inMilliseconds - elapsedMs;
      player1TimeLeft =
          Duration(milliseconds: remainingMs > 0 ? remainingMs : 0);
      notifyListeners();
    }
  }

  void decrementPlayer2Timer([int elapsedMs = TIMER_ACCURACY_MS]) {
    if (player2TimeLeft.inMilliseconds > 0 && !gameOver) {
      final remainingMs = player2TimeLeft.inMilliseconds - elapsedMs;
      player2TimeLeft =
          Duration(milliseconds: remainingMs > 0 ? remainingMs : 0);
      notifyListeners();
    }
  }

  void setTheme(int index) async {
    themeName = themeList[index].name;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('themeName', themeName);
    notifyListeners();
  }

  void setPieceTheme(int index) async {
    pieceTheme = pieceThemes[index];
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('pieceTheme', pieceTheme);
    notifyListeners();
  }

  void setShowMoveHistory(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    showMoveHistory = show;
    prefs.setBool('showMoveHistory', show);
    notifyListeners();
  }

  void setSoundEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    soundEnabled = enabled;
    prefs.setBool('soundEnabled', enabled);
    notifyListeners();
  }

  void setShowHints(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    showHints = show;
    prefs.setBool('showHints', show);
    notifyListeners();
  }

  void setShowTipButton(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    showTipButton = show;
    await prefs.setBool('showTipButton', show);
    notifyListeners();
  }

  void setTipInProgress(bool inProgress) {
    if (tipInProgress == inProgress) return;
    tipInProgress = inProgress;
    if (!_disposed) notifyListeners();
  }

  void setFlipBoard(bool flip) async {
    final prefs = await SharedPreferences.getInstance();
    this.flip = flip;
    prefs.setBool('flip', flip);
    notifyListeners();
  }

  void setAllowUndoRedo(bool allow) async {
    final prefs = await SharedPreferences.getInstance();
    this.allowUndoRedo = allow;
    prefs.setBool('allowUndoRedo', allow);
    notifyListeners();
  }

  Future<void> _persistGameOption(String key, Object value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is int) await prefs.setInt(key, value);
    if (value is String) await prefs.setString(key, value);
  }

  Future<void> loadSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (_disposed) return;
    themeName = prefs.getString('themeName') ?? 'AppsBay';
    pieceTheme = prefs.getString('pieceTheme') ?? 'Classic';
    showMoveHistory = prefs.getBool('showMoveHistory') ?? true;
    soundEnabled = prefs.getBool('soundEnabled') ?? true;
    showHints = prefs.getBool('showHints') ?? true;
    showTipButton = prefs.getBool('showTipButton') ?? true;
    flip = prefs.getBool('flip') ?? true;
    allowUndoRedo = prefs.getBool('allowUndoRedo') ?? true;
    if (game == null) _loadSetupOptions(prefs);
    notifyListeners();
  }

  void _loadSetupOptions(SharedPreferences prefs) {
    final difficulty = prefs.get('aiDifficulty');
    aiDifficulty = difficulty is int && const [1, 3, 5, 6].contains(difficulty)
        ? difficulty
        : 3;
    final side = prefs.get('selectedSide');
    selectedSide = Player.values.firstWhere((player) => player.name == side,
        orElse: () => Player.player1);
    if (selectedSide != Player.random) playerSide = selectedSide;
    final minutes = prefs.get('timeLimit');
    timeLimit = minutes is int && minutes >= 0 && minutes <= 90 ? minutes : 0;
  }

  void update() {
    notifyListeners();
  }
}
