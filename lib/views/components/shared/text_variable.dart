import 'package:flutter/cupertino.dart';
import 'package:chess_room/util/app_design.dart';

class TextDefault extends StatelessWidget {
  final String text;
  final Color color;

  TextDefault(this.text, {this.color = AppColors.textPrimary});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        height: 1.45,
        color: color,
      ),
    );
  }
}

class TextSmall extends StatelessWidget {
  final String text;

  TextSmall(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 20));
  }
}

class TextRegular extends StatelessWidget {
  final String text;

  TextRegular(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 24));
  }
}

class TextLarge extends StatelessWidget {
  final String text;

  TextLarge(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 36));
  }
}
