import 'package:chess_room/features/game_history/game_history_page.dart';
import 'package:chess_room/features/how_to_play/how_to_play_page.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/util/ads_manager.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import 'more_apps_page.dart';
import 'components/settings_view/remove_ads_section.dart';
import 'components/settings_view/settings_navigation_buttons.dart';
import 'components/settings_view/toggles.dart';
import 'components/shared/banner_ad_slot.dart';
import 'components/shared/app_page.dart';

class SettingsView extends StatelessWidget {
  final AppModel appModel;

  const SettingsView({
    super.key,
    required this.appModel,
  });

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return Consumer<AppModel>(
      builder: (context, appModel, child) => AppPage(
        title: strings.Settings,
        leading: CupertinoNavigationBarBackButton(
          key: const ValueKey('settings-back-button'),
          onPressed: () => Navigator.pop(context),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                physics: const ClampingScrollPhysics(),
                child: AppContent(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SectionTitle(strings.Gameplay_Settings),
                      const SizedBox(height: AppSpacing.md),
                      _SettingsGroup(child: Toggles(appModel)),
                      if (appModel.canPurchaseRemoveAds) ...[
                        const SizedBox(height: AppSpacing.xxl),
                        RemoveAdsSection(appModel: appModel),
                      ],
                      const SizedBox(height: AppSpacing.xxl),
                      _SectionTitle(strings.Help_And_Privacy),
                      const SizedBox(height: AppSpacing.md),
                      _SettingsGroup(
                        child: ValueListenableBuilder<bool>(
                          valueListenable: AdsManager.privacyOptionsRequired,
                          builder: (context, privacyOptionsRequired, child) {
                            return SettingsNavigationButtons(
                              showBackButton: false,
                              showPrivacyChoices: privacyOptionsRequired,
                              onHowToPlay: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => const HowToPlayPage(),
                                  ),
                                );
                              },
                              onGameHistory: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => GameHistoryPage(
                                      store: appModel.gameHistoryStore,
                                      pieceTheme: appModel.pieceTheme,
                                    ),
                                  ),
                                );
                              },
                              onPrivacyChoices:
                                  AdsManager.showPrivacyOptionsForm,
                              onMoreApps: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => const MoreAppsPage(),
                                  ),
                                );
                              },
                              onBack: () => Navigator.pop(context),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const BannerAdSlot(),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      );
}

class _SettingsGroup extends StatelessWidget {
  final Widget child;

  const _SettingsGroup({required this.child});

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.divider),
        ),
        child: child,
      );
}
