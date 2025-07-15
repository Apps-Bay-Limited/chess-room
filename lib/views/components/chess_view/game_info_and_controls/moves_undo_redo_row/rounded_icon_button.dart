import 'package:flutter/cupertino.dart';

class RoundedIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const RoundedIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}
