import 'dart:async';

import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/logic/chess_game.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:flutter/cupertino.dart';

import 'rounded_icon_button.dart';

/// Keeps the current match safe while the player decides whether to replace it.
class RestartGameButton extends StatefulWidget {
  final AppModel appModel;

  const RestartGameButton({super.key, required this.appModel});

  @override
  State<RestartGameButton> createState() => _RestartGameButtonState();
}

class _RestartGameButtonState extends State<RestartGameButton>
    with WidgetsBindingObserver {
  bool _confirming = false;
  ChessGame? _confirmingGame;
  ModalRoute<dynamic>? _ownerRoute;
  ModalRoute<dynamic>? _dialogRoute;
  NavigatorState? _dialogNavigator;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Removing the match route must not leave its confirmation above Home.
    // Defer Navigator changes until the disposing widget tree is unlocked.
    final dialog = _dialogRoute;
    final navigator = _dialogNavigator;
    if (dialog != null && navigator != null) {
      scheduleMicrotask(() {
        if (navigator.mounted && dialog.isActive) {
          navigator.removeRoute(dialog);
        }
      });
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_confirming &&
        identical(widget.appModel.game, _confirmingGame) &&
        (_ownerRoute?.isActive ?? mounted)) {
      // ChessView resumes a visible match when the app returns. The pending
      // confirmation still owns the pause until the player answers it.
      unawaited(widget.appModel.pauseGame(notify: false));
    }
  }

  bool get _ownsCurrentMatch =>
      mounted &&
      identical(widget.appModel.game, _confirmingGame) &&
      (_ownerRoute?.isCurrent ?? true);

  Future<void> _confirmRestart() async {
    final appModel = widget.appModel;
    final game = appModel.game;
    if (_confirming || game == null) return;
    final ownerRoute = ModalRoute.of(context);
    if (ownerRoute != null && !ownerRoute.isCurrent) return;
    _confirmingGame = game;
    _ownerRoute = ownerRoute;
    final wasPaused = appModel.isGamePaused;
    final unfinished = !appModel.gameOver;
    setState(() => _confirming = true);

    try {
      await appModel.pauseGame();
      if (!mounted || !_ownsCurrentMatch) return;
      final strings = S.of(context);
      var answered = false;
      final restart = await showCupertinoDialog<bool>(
        context: context,
        builder: (dialogContext) {
          _dialogRoute = ModalRoute.of(dialogContext);
          _dialogNavigator = Navigator.of(dialogContext);
          void answer(bool restart) {
            if (answered ||
                !dialogContext.mounted ||
                !(ModalRoute.of(dialogContext)?.isCurrent ?? false)) return;
            answered = true;
            Navigator.of(dialogContext).pop(restart);
          }

          return PopScope<bool>(
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) answered = true;
            },
            child: CupertinoAlertDialog(
              title: Text(strings.Replace_Unfinished_Game),
              content: unfinished
                  ? Text(strings.Replace_Unfinished_Game_Description)
                  : null,
              actions: [
                CupertinoDialogAction(
                  key: const ValueKey('cancel-restart-button'),
                  isDefaultAction: true,
                  onPressed: () => answer(false),
                  child: Text(strings.Cancel),
                ),
                CupertinoDialogAction(
                  key: const ValueKey('confirm-restart-button'),
                  isDestructiveAction: true,
                  onPressed: () => answer(true),
                  child: Text(strings.Start),
                ),
              ],
            ),
          );
        },
      );
      if (!mounted || !_ownsCurrentMatch) return;
      if (restart == true) {
        appModel.newGame(context);
      } else if (!wasPaused &&
          (WidgetsBinding.instance.lifecycleState == null ||
              WidgetsBinding.instance.lifecycleState ==
                  AppLifecycleState.resumed)) {
        appModel.resumeGameSession();
      }
    } finally {
      _confirmingGame = null;
      _ownerRoute = null;
      _dialogRoute = null;
      _dialogNavigator = null;
      if (mounted) setState(() => _confirming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: S.of(context).Replace_Unfinished_Game,
      child: RoundedIconButton(
        key: const ValueKey('restart-game-button'),
        icon: CupertinoIcons.arrow_2_circlepath,
        onPressed: _confirming || widget.appModel.game == null
            ? null
            : _confirmRestart,
      ),
    );
  }
}
