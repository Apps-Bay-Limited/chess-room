import 'dart:async';
import 'dart:math';

import 'package:chess_room/logic/chess_game.dart';
import 'package:chess_room/logic/move_calculation/move_classes/move_meta.dart';
import 'package:chess_room/logic/shared_functions.dart';
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
  bool flip = true;

  ChessGame? game;
  Timer? timer;
  DateTime? _lastTick;
  bool gameOver = false;
  bool stalemate = false;
  bool promotionRequested = false;
  bool moveListUpdated = false;
  Player turn = Player.player1;
  List<MoveMeta> moveMetaList = [];
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
    return game != null && !gameOver;
  }

  bool get playingWithAI {
    return playerCount == 1;
  }

  AppModel() {
    loadSharedPrefs();
  }

  void newGame(BuildContext context, {bool notify = true}) {
    game?.cancelAIMove();
    timer?.cancel();
    gameOver = false;
    stalemate = false;
    turn = Player.player1;
    moveMetaList = [];
    player1TimeLeft = Duration(minutes: timeLimit);
    player2TimeLeft = Duration(minutes: timeLimit);
    if (selectedSide == Player.random) {
      playerSide = Random.secure().nextInt(2) == 0 ? Player.player1 : Player.player2;
    }
    // Ensure the turn starts with the human player if appropriate
    turn = playerSide;
    game = ChessGame(this, context);
    _lastTick = DateTime.now();
    timer = Timer.periodic(Duration(milliseconds: TIMER_ACCURACY_MS), (timer) {
      final now = DateTime.now();
      final elapsedMs = now.difference(_lastTick!).inMilliseconds;
      _lastTick = now;
      turn == Player.player1
          ? decrementPlayer1Timer(elapsedMs)
          : decrementPlayer2Timer(elapsedMs);
      if ((player1TimeLeft == Duration.zero || player2TimeLeft == Duration.zero) &&
          timeLimit != 0) {
        endGame();
      }
    });
    if (notify) {
      notifyListeners();
    }
  }

  void exitChessView() {
    game?.cancelAIMove();
    timer?.cancel();
    notifyListeners();
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

  void endGame() {
    if (!gameOver) {
      HapticFeedback.heavyImpact();
    }
    gameOver = true;
    notifyListeners();
  }

  void undoEndGame() {
    gameOver = false;
    notifyListeners();
  }

  void changeTurn() {
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
    notifyListeners();
  }

  void setPlayerSide(Player side) {
    selectedSide = side;
    if (side != Player.random) {
      playerSide = side;
    }
    notifyListeners();
  }

  void setTimeLimit(int duration) {
    timeLimit = duration;
    player1TimeLeft = Duration(minutes: timeLimit);
    player2TimeLeft = Duration(minutes: timeLimit);
    notifyListeners();
  }

  void decrementPlayer1Timer([int elapsedMs = TIMER_ACCURACY_MS]) {
    if (player1TimeLeft.inMilliseconds > 0 && !gameOver) {
      final remainingMs = player1TimeLeft.inMilliseconds - elapsedMs;
      player1TimeLeft = Duration(milliseconds: remainingMs > 0 ? remainingMs : 0);
      notifyListeners();
    }
  }

  void decrementPlayer2Timer([int elapsedMs = TIMER_ACCURACY_MS]) {
    if (player2TimeLeft.inMilliseconds > 0 && !gameOver) {
      final remainingMs = player2TimeLeft.inMilliseconds - elapsedMs;
      player2TimeLeft = Duration(milliseconds: remainingMs > 0 ? remainingMs : 0);
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

  void loadSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    themeName = prefs.getString('themeName') ?? 'AppsBay';
    pieceTheme = prefs.getString('pieceTheme') ?? 'Classic';
    showMoveHistory = prefs.getBool('showMoveHistory') ?? true;
    soundEnabled = prefs.getBool('soundEnabled') ?? true;
    showHints = prefs.getBool('showHints') ?? true;
    flip = prefs.getBool('flip') ?? true;
    allowUndoRedo = prefs.getBool('allowUndoRedo') ?? true;
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }
}
