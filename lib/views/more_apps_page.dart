import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../generated/l10n.dart';
import '../util/app_design.dart';
import '../util/store_links.dart';
import 'components/shared/app_page.dart';

class MoreAppsPage extends StatelessWidget {
  const MoreAppsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<MoreAppItem> _items = [];

    var Image_Guru = MoreAppItem(Image.asset("assets/app_icons/image_guru.png"),
        S.of(context).Image_Guru, () {
      openStoreListing(appStoreId: "1625021625", androidAppBundleId: "");
    });

    var Yes_Habit = MoreAppItem(
        Image.asset("assets/app_icons/yes_habit.png"), S.of(context).Yes_Habit,
        () {
      openStoreListing(appStoreId: "1637643734", androidAppBundleId: "");
    });

    var We_Play_Piano = MoreAppItem(
        Image.asset("assets/app_icons/we_play_piano.png"),
        S.of(context).We_Play_Piano, () {
      openStoreListing(
          appStoreId: "1625018611",
          androidAppBundleId: "com.appsbay.we_play_piano");
    });

    var Falling_Block_Puzzle = MoreAppItem(
        Image.asset("assets/app_icons/falling_block_puzzle.png"),
        S.of(context).Falling_Block_Puzzle, () {
      openStoreListing(appStoreId: "1609440799", androidAppBundleId: "");
    });

    var World_Weather_Live = MoreAppItem(
        Image.asset("assets/app_icons/world_weather_live.png"),
        S.of(context).World_Weather_Live, () {
      openStoreListing(
          appStoreId: "1612773646",
          androidAppBundleId: "com.appsbay.world_weather_live");
    });

    var Shows = MoreAppItem(
        Image.asset("assets/app_icons/shows.png"), S.of(context).Shows, () {
      openStoreListing(
          appStoreId: "1624910011", androidAppBundleId: "com.appsbay.shows");
    });

    var Classical_Music_Box = MoreAppItem(
        Image.asset("assets/app_icons/classical_music_box.png"),
        S.of(context).Classical_Music_Box, () {
      openStoreListing(
          appStoreId: "1613096431",
          androidAppBundleId: "com.appsbay.classical_music_box");
    });

    var Money_Tracker = MoreAppItem(
        Image.asset("assets/app_icons/money_tracker.png"),
        S.of(context).Money_Tracker, () {
      openStoreListing(appStoreId: "1534244892", androidAppBundleId: "");
    });

    var Sudoku_Lover = MoreAppItem(
        Image.asset("assets/app_icons/sudoku_lover.png"),
        S.of(context).Sudoku_Lover, () {
      openStoreListing(
          appStoreId: "1620749798",
          androidAppBundleId: "com.appsbay.sudoku_lovers");
    });

    var Onlynote = MoreAppItem(
        Image.asset("assets/app_icons/onlynote.png"), S.of(context).Onlynote,
        () {
      openStoreListing(
          appStoreId: "1616516732", androidAppBundleId: "com.appsbay.onlynote");
    });

    var Easy_Unit = MoreAppItem(
        Image.asset("assets/app_icons/easy_unit.png"), S.of(context).Easy_Unit,
        () {
      openStoreListing(appStoreId: "1643640909", androidAppBundleId: "");
    });

    var Novels_Hub = MoreAppItem(Image.asset("assets/app_icons/novels_hub.png"),
        S.of(context).Novels_Hub, () {
      openStoreListing(
          appStoreId: "1528820845",
          androidAppBundleId: "com.appsbay.novelshub");
    });

    var Simple_Calculator = MoreAppItem(
        Image.asset("assets/app_icons/simple_calculator.png"),
        S.of(context).Simple_Calculator, () {
      openStoreListing(
          appStoreId: "1610829871",
          androidAppBundleId: "com.appsbay.simple_calculator");
    });

    var minesweeper_go = MoreAppItem(
        Image.asset("assets/app_icons/minesweeper_go.png"),
        S.of(context).Minesweeper_Go, () {
      openStoreListing(
          appStoreId: "1621899572",
          androidAppBundleId: "com.appsbay.classic_minesweeper");
    });

    var Saving_Ambulance = MoreAppItem(
        Image.asset("assets/app_icons/saving_ambulance.png"),
        S.of(context).Saving_Ambulance, () {
      openStoreListing(
          appStoreId: "1639693525",
          androidAppBundleId: "com.appsbay.saving_ambulance");
    });

    var Fling_Knife = MoreAppItem(
        Image.asset("assets/app_icons/fling_knife.png"),
        S.of(context).Fling_Knife, () {
      openStoreListing(
          appStoreId: "1636426217",
          androidAppBundleId: "com.appsbay.fling_knife");
    });

    if (Platform.isIOS || Platform.isMacOS) {
      _items = [
        Yes_Habit,
        We_Play_Piano,
        minesweeper_go,
        Saving_Ambulance,
        Falling_Block_Puzzle,
        Fling_Knife,
        World_Weather_Live,
        Easy_Unit,
        Shows,
        Classical_Music_Box,
        Money_Tracker,
        Sudoku_Lover,
        Image_Guru,
        Onlynote,
        Novels_Hub,
        Simple_Calculator
      ];
    } else {
      _items = [
        We_Play_Piano,
        minesweeper_go,
        Saving_Ambulance,
        Fling_Knife,
        World_Weather_Live,
        Shows,
        Classical_Music_Box,
        Sudoku_Lover,
        Onlynote,
        Novels_Hub,
        Simple_Calculator
      ];
    }

    return AppPage(
      title: S.of(context).More_Apps,
      leading: CupertinoNavigationBarBackButton(
        key: const ValueKey('more-apps-back-button'),
        onPressed: () => Navigator.pop(context),
      ),
      child: AppContent(
        child: ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.xl),
          itemCount: _items.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) => MoreAppsRow.fromItem(_items[index]),
        ),
      ),
    );
  }
}

class MoreAppItem {
  Image appIcon;
  String title;
  void Function() onTap;

  MoreAppItem(this.appIcon, this.title, this.onTap);
}

class MoreAppsRow extends StatelessWidget {
  final Widget appIcon;
  final String title;
  final VoidCallback onTap;
  final IconData trailingIcon;

  const MoreAppsRow({
    super.key,
    required this.appIcon,
    required this.title,
    required this.onTap,
    this.trailingIcon = CupertinoIcons.chevron_forward,
  });

  static MoreAppsRow fromItem(MoreAppItem moreAppItem) {
    return MoreAppsRow(
      appIcon: moreAppItem.appIcon,
      title: moreAppItem.title,
      onTap: moreAppItem.onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(kMinTouchTarget, kMinTouchTarget),
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            ExcludeSemantics(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: SizedBox(width: 48, height: 48, child: appIcon),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Icon(trailingIcon, color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
