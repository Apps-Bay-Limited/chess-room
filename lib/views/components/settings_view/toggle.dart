import 'package:flutter/cupertino.dart';

import '../shared/text_variable.dart';

class Toggle extends StatelessWidget {
  final String label;
  final bool toggle;
  final Function setFunc;

  const Toggle({
    super.key,
    required this.label,
    required this.toggle,
    required this.setFunc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextDefault(label),
          CupertinoSwitch(
            value: toggle,
            onChanged: (bool value) {
              setFunc(value);
            },
            activeTrackColor: const Color(0xffCC996F),
          ),
        ],
      ),
    );
  }
}
