import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:flutter/cupertino.dart';

import '../../../generated/l10n.dart';
import 'toggle.dart';

class Toggles extends StatelessWidget {
  final AppModel appModel;

  const Toggles(this.appModel, {super.key});

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return Column(
      children: [
        Toggle(
          key: const ValueKey('settings-hints-toggle'),
          label: strings.Hints,
          description: strings.Hints_Description,
          toggle: appModel.showHints,
          setFunc: appModel.setShowHints,
        ),
        _divider(),
        Toggle(
          key: const ValueKey('settings-tip-toggle'),
          label: strings.Tip_Button,
          description: strings.Tip_Button_Description,
          toggle: appModel.showTipButton,
          setFunc: appModel.setShowTipButton,
        ),
        _divider(),
        Toggle(
          key: const ValueKey('settings-undo-toggle'),
          label: strings.Undo,
          description: strings.Undo_Description,
          toggle: appModel.allowUndoRedo,
          setFunc: appModel.setAllowUndoRedo,
        ),
        _divider(),
        Toggle(
          key: const ValueKey('settings-sound-toggle'),
          label: strings.Sound,
          description: strings.Sound_Description,
          toggle: appModel.soundEnabled,
          setFunc: appModel.setSoundEnabled,
        ),
      ],
    );
  }

  Widget _divider() => Container(
        height: 1,
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        color: AppColors.divider,
      );
}
