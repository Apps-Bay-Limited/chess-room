import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:flutter/cupertino.dart';

/// Starting another match replaces the single unfinished-game save.
Future<bool> confirmNewGame(BuildContext context, AppModel appModel) async {
  await appModel.initialization;
  if (!context.mounted) return false;
  if (!appModel.hasResumableGame) return true;
  final strings = S.of(context);
  var answered = false;
  return await showCupertinoDialog<bool>(
        context: context,
        builder: (dialogContext) {
          void answer(bool start) {
            if (answered ||
                !dialogContext.mounted ||
                !(ModalRoute.of(dialogContext)?.isCurrent ?? false)) return;
            answered = true;
            Navigator.pop(dialogContext, start);
          }

          return PopScope<bool>(
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) answered = true;
            },
            child: CupertinoAlertDialog(
              title: Text(strings.Replace_Unfinished_Game),
              content: Text(strings.Replace_Unfinished_Game_Description),
              actions: [
                CupertinoDialogAction(
                  key: const ValueKey('cancel-new-game-button'),
                  isDefaultAction: true,
                  onPressed: () => answer(false),
                  child: Text(strings.Cancel),
                ),
                CupertinoDialogAction(
                  key: const ValueKey('confirm-new-game-button'),
                  isDestructiveAction: true,
                  onPressed: () => answer(true),
                  child: Text(strings.Start),
                ),
              ],
            ),
          );
        },
      ) ??
      false;
}
