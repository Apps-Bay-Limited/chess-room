import 'package:flutter/cupertino.dart';

import '../../shared/rounded_button.dart';
import '../../shared/text_variable.dart';

class RoundedAlertButton extends StatelessWidget {
  final String label;
  final VoidCallback onConfirm;

  const RoundedAlertButton({
    super.key,
    required this.label,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      label: label,
      onPressed: () {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: TextDefault(label),
              content: TextDefault(
                'Are you sure you want to ${label.toLowerCase()}?',
              ),
              actions: [
                CupertinoButton(
                  child: TextDefault(
                    label,
                    color: CupertinoColors.destructiveRed,
                  ),
                  onPressed: () {
                    onConfirm();
                    Navigator.pop(context);
                  },
                ),
                CupertinoButton(
                  child: TextDefault('Cancel', color: CupertinoColors.activeBlue),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
