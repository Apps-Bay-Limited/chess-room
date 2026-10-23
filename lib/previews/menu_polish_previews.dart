import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/ai_difficulty_picker.dart';
import 'package:chess_room/views/components/settings_view/toggle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

@Preview(
    name: 'Settings row: large text', group: 'Polish', size: Size(320, 460))
Widget settingsRowPolishPreview() =>
    _preview(const _SettingsRowPreview(), textScale: 2);

@Preview(
    name: 'Named difficulty choices', group: 'Polish', size: Size(390, 480))
@Preview(
    name: 'Difficulty: narrow landscape', group: 'Polish', size: Size(700, 390))
Widget difficultyPolishPreview() => _preview(const _DifficultyPreview());

Widget _preview(Widget child, {double textScale = 1}) => CupertinoApp(
      theme: const CupertinoThemeData(
          brightness: Brightness.dark, primaryColor: AppColors.accent),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Builder(
          builder: (context) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(textScale)),
                child: CupertinoPageScaffold(
                  backgroundColor: AppColors.background,
                  child: SafeArea(
                      child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: child,
                  )),
                ),
              )),
    );

class _SettingsRowPreview extends StatefulWidget {
  const _SettingsRowPreview();

  @override
  State<_SettingsRowPreview> createState() => _SettingsRowPreviewState();
}

class _SettingsRowPreviewState extends State<_SettingsRowPreview> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md)),
        child: Toggle(
          label: S.of(context).Hints,
          description: S.of(context).Hints_Description,
          toggle: _enabled,
          setFunc: (value) => setState(() => _enabled = value),
        ),
      );
}

class _DifficultyPreview extends StatefulWidget {
  const _DifficultyPreview();

  @override
  State<_DifficultyPreview> createState() => _DifficultyPreviewState();
}

class _DifficultyPreviewState extends State<_DifficultyPreview> {
  int _level = 3;

  @override
  Widget build(BuildContext context) => AIDifficultyPicker(
      _level, (value) => setState(() => _level = value ?? 3));
}
