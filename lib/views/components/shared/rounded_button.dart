import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final Function onPressed;

  const RoundedButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CupertinoButton(
        onPressed: () {
          onPressed();
        },
        child: Text(label),
      ),
    );
  }
}
