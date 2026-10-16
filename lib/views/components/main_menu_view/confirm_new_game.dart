import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:flutter/cupertino.dart';

/// Starting another match replaces the single unfinished-game save.
Future<bool> confirmNewGame(BuildContext context, AppModel appModel) async {
  await appModel.initialization;
  if (!context.mounted) return false;
  if (!appModel.hasResumableGame) return true;
  final strings = S.of(context);
  return await showCupertinoDialog<bool>(
        context: context,
        builder: (dialogContext) => CupertinoAlertDialog(
          title: Text(strings.Replace_Unfinished_Game),
          content: Text(strings.Replace_Unfinished_Game_Description),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(strings.Cancel),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(strings.Start),
            ),
          ],
        ),
      ) ??
      false;
}
