import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:chess_room/features/daily_puzzle/daily_puzzle_page.dart';
import 'package:chess_room/features/game_history/game_history_page.dart';
import 'package:chess_room/features/training/training_hub_page.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/util/in_app_reviewer_helper.dart';
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
  AppModel? _appModel;

  @override
  void dispose() {
    _appModel?.purchaseService.removeListener(_handleRemoveAdsChanged);
    _stopAppOpenAds();
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

      _appModel = Provider.of<AppModel>(context, listen: false);
      _appModel?.purchaseService.addListener(_handleRemoveAdsChanged);
      await _appModel!.purchaseInitialization;
      if (!mounted) {
        return;
      }

      AdsManager.setAdsRemoved(_appModel!.isAdsRemoved);
      if (_appModel!.isAdsRemoved) {
        _stopAppOpenAds();
        InAppReviewHelper.checkAndAskForReview();
        return;
      }

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final status =
            await AppTrackingTransparency.trackingAuthorizationStatus;
        if (status == TrackingStatus.notDetermined) {
          await AppTrackingTransparency.requestTrackingAuthorization();
        }
      }

      await AdsManager.initialize(adsRemoved: _appModel!.isAdsRemoved);
      if (!mounted) {
        return;
      }

      _appOpenAdManager = AppOpenAdManager()..loadAd();
      _appLifecycleReactor = AppLifecycleReactor(
        appOpenAdManager: _appOpenAdManager!,
        isGameInProgress: () => _appModel!.gameInProgress,
        isPurchaseFlowActive: () =>
            _appModel!.purchaseService.isStoreFlowActive,
      );
      WidgetsBinding.instance.addObserver(_appLifecycleReactor!);

      InAppReviewHelper.checkAndAskForReview();
    });
  }

  void _handleRemoveAdsChanged() {
    final appModel = _appModel;
    if (appModel == null) {
      return;
    }

    AdsManager.setAdsRemoved(appModel.isAdsRemoved);
    AdsManager.setPurchaseFlowActive(
        appModel.purchaseService.isStoreFlowActive);
    if (appModel.isAdsRemoved) {
      _stopAppOpenAds();
    }
  }

  void _stopAppOpenAds() {
    final reactor = _appLifecycleReactor;
    if (reactor != null) {
      WidgetsBinding.instance.removeObserver(reactor);
      _appLifecycleReactor = null;
    }
    _appOpenAdManager?.dispose();
    _appOpenAdManager = null;
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
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
                      const SizedBox(height: 30),
                      MenuButton(
                        key: const ValueKey('daily-puzzle-button'),
                        label: S.of(context).Daily_Puzzle,
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => DailyPuzzlePage(
                                pieceTheme: appModel.pieceTheme,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      MenuButton(
                        key: const ValueKey('training-button'),
                        label: S.of(context).Training,
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => TrainingHubPage(
                                pieceTheme: appModel.pieceTheme,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      MenuButton(
                        key: const ValueKey('vs-ai-button'),
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
                      const SizedBox(height: 20),
                      MenuButton(
                        key: const ValueKey('two-players-button'),
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
                      const SizedBox(height: 20),
                      MenuButton(
                        key: const ValueKey('game-history-button'),
                        label: S.of(context).Game_History,
                        onTap: () {
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
                      ),
                      const SizedBox(height: 20),
                      MenuButton(
                        key: const ValueKey('settings-button'),
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
