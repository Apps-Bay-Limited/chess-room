import 'package:chess_room/util/ads_manager.dart';
import 'package:flutter/widgets.dart';

/// Protects a practice page from foreground ads for its mounted lifetime.
/// Put this inside the page's build method so previews and direct entry routes
/// receive the same protection as navigation from Home.
class PracticeSessionScope extends StatefulWidget {
  final Widget child;

  const PracticeSessionScope({super.key, required this.child});

  @override
  State<PracticeSessionScope> createState() => _PracticeSessionScopeState();
}

class _PracticeSessionScopeState extends State<PracticeSessionScope> {
  late final VoidCallback _release;

  @override
  void initState() {
    super.initState();
    _release = AdsManager.beginPracticeSession();
  }

  @override
  void dispose() {
    _release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
