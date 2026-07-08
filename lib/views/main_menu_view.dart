import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/util/in_app_reviewer_helper.dart';
import 'package:chess_room/views/more_apps_page.dart';
import 'package:chess_room/views/settings_view.dart';
import 'package:chess_room/views/single_player_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import '../util/ads_manager.dart';
import 'components/shared/banner_ad_slot.dart';
import 'components/shared/menu_button.dart';

class MainMenuView extends StatefulWidget {
  const MainMenuView({super.key});

  @override
  State<MainMenuView> createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  AppLifecycleReactor? _appLifecycleReactor;
  AppOpenAdManager? _appOpenAdManager;

  @override
  void dispose() {
    if (_appLifecycleReactor != null) {
      WidgetsBinding.instance.removeObserver(_appLifecycleReactor!);
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      _initAppServices();
    }
  }

  Future<void> _initAppServices() async {
    // Show ATT prompt after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final status =
            await AppTrackingTransparency.trackingAuthorizationStatus;
        if (status == TrackingStatus.notDetermined) {
          await AppTrackingTransparency.requestTrackingAuthorization();
        }
      }

      await AdsManager.initialize();
      if (!mounted) {
        return;
      }

      _appOpenAdManager = AppOpenAdManager()..loadAd();
      final appModel = Provider.of<AppModel>(context, listen: false);
      _appLifecycleReactor = AppLifecycleReactor(
        appOpenAdManager: _appOpenAdManager!,
        isGameInProgress: () => appModel.gameInProgress,
      );
      WidgetsBinding.instance.addObserver(_appLifecycleReactor!);
    });

    InAppReviewHelper.checkAndAskForReview();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.height < 800 ? 110 : 140;

    return Consumer<AppModel>(
      builder: (context, appModel, child) {
        return Container(
          decoration: BoxDecoration(gradient: appModel.theme.background),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            10, MediaQuery.of(context).padding.top + 30, 10, 0),
                        child: Image.asset(
                          'assets/images/chess-piece.png',
                          width: width,
                        ),
                      ),
                      const SizedBox(height: 40),
                      MenuButton(
                        label: S.of(context).Vs_AI_Player,
                        onTap: () {
                          appModel.setPlayerCount(1);
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const SinglePlayerView(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      MenuButton(
                        label: S.of(context).Two_Players,
                        onTap: () {
                          appModel.setPlayerCount(2);
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const SinglePlayerView(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      MenuButton(
                        label: S.of(context).Settings,
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  SettingsView(appModel: appModel),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      MenuButton(
                        label: S.of(context).More_Apps,
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const MoreAppsPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const BannerAdSlot(),
            ],
          ),
        );
      },
    );
  }
}
