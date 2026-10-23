import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

/// Consistent screen chrome, also usable by isolated previews without a model.
class AppPage extends StatelessWidget {
  final Widget child;
  final String? title;
  final Widget? leading;
  final Widget? trailing;

  const AppPage({
    super.key,
    required this.child,
    this.title,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AppModel?>(context);
    final background = readablePageGradient(model?.theme.background ??
        const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.background, AppColors.surface],
        ));
    final inherited = CupertinoTheme.of(context);
    return CupertinoTheme(
      data: inherited.copyWith(
        brightness: Brightness.dark,
        primaryColor: AppColors.accent,
        primaryContrastingColor: AppColors.onAccent,
        textTheme: inherited.textTheme.copyWith(
          textStyle: inherited.textTheme.textStyle.copyWith(
            color: AppColors.textPrimary,
            fontSize: 16,
            height: 1.35,
          ),
          navTitleTextStyle: inherited.textTheme.navTitleTextStyle.copyWith(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
          navActionTextStyle: inherited.textTheme.navActionTextStyle.copyWith(
            color: AppColors.accent,
          ),
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: background),
        child: CupertinoPageScaffold(
          backgroundColor: CupertinoColors.transparent,
          navigationBar: title == null
              ? null
              : CupertinoNavigationBar(
                  backgroundColor: AppColors.surface,
                  border: const Border(
                    bottom: BorderSide(color: AppColors.divider, width: 0.5),
                  ),
                  middle: Text(title!,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  leading: leading,
                  trailing: trailing,
                ),
          child: SafeArea(child: child),
        ),
      ),
    );
  }
}

/// Keeps long text and controls comfortable to scan on larger windows.
class AppContent extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const AppContent({super.key, required this.child, this.maxWidth = 640});

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SizedBox(width: double.infinity, child: child),
        ),
      );
}
