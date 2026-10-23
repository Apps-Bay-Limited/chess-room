import 'package:chess_room/util/app_design.dart';
import 'package:flutter/cupertino.dart';

/// Labels sit outside the board so its tap geometry remains unchanged.
class BoardCoordinates extends StatelessWidget {
  final Widget child;
  final bool flipped;
  final bool visible;

  const BoardCoordinates(
      {super.key,
      required this.child,
      this.flipped = false,
      this.visible = true});

  @override
  Widget build(BuildContext context) {
    final gutter = MediaQuery.textScalerOf(context).scale(11) * 1.5 + 8;
    const style = TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary);
    return Padding(
      padding: EdgeInsets.only(bottom: visible ? gutter : 0),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(clipBehavior: Clip.none, children: [
          child,
          if (visible)
            Positioned(
              left: -24,
              width: 20,
              top: 0,
              bottom: 0,
              child: ExcludeSemantics(
                  child: IgnorePointer(
                      child: Column(children: [
                for (var row = 0; row < 8; row++)
                  Expanded(
                      child: Center(
                          child: Text('${flipped ? row + 1 : 8 - row}',
                              style: style))),
              ]))),
            ),
          if (visible)
            Positioned(
              left: 0,
              right: 0,
              bottom: -gutter,
              height: gutter,
              child: ExcludeSemantics(
                  child: IgnorePointer(
                      child: Row(children: [
                for (var col = 0; col < 8; col++)
                  Expanded(
                      child: Center(
                          child: Text(
                              String.fromCharCode(
                                  97 + (flipped ? 7 - col : col)),
                              style: style))),
              ]))),
            ),
        ]),
      ),
    );
  }
}
