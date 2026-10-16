import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:chess_room/features/daily_puzzle/daily_puzzle_page.dart';
import 'package:chess_room/features/daily_puzzle/daily_puzzle_progress.dart';
import 'package:chess_room/features/training/training_hub_page.dart';
import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/util/in_app_reviewer_helper.dart';
import 'package:chess_room/views/settings_view.dart';
import 'package:chess_room/views/single_player_page.dart';
import 'package:chess_room/views/chess_view.dart';
import 'package:chess_room/views/components/main_menu_view/confirm_new_game.dart';
import 'package:chess_room/views/components/main_menu_view/home_play_actions.dart';
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

class _MainMenuViewState extends State<MainMenuView>
    with WidgetsBindingObserver {
  AppLifecycleReactor? _appLifecycleReactor;
  AppOpenAdManager? _appOpenAdManager;
  AppModel? _appModel;
  PuzzleProgress _dailyProgress =
      const PuzzleProgress(streak: 0, solvedToday: false);
  bool _openingGame = false;
  bool _ready = false;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _appModel?.purchaseService.removeListener(_handleRemoveAdsChanged);
    _stopAppOpenAds();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshDailyProgress();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final appModel = context.read<AppModel>();
      await appModel.initialization;
      if (mounted) setState(() => _ready = true);
    });

    if (!kIsWeb) {
      _initAppServices();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshDailyProgress();
  }

  Future<void> _refreshDailyProgress() async {
    final progress =
        await SharedPreferencesPuzzleProgressStore().load(DateTime.now());
    if (mounted) setState(() => _dailyProgress = progress);
  }

  Future<void> _openGame(AppModel appModel, {bool resume = false}) async {
    if (_openingGame) return;
    setState(() => _openingGame = true);
    try {
      await appModel.initialization;
      if (!mounted) return;
      if (resume) {
        final restored = await appModel.resumeGame(context);
        if (!mounted) return;
        if (!restored) {
          await showCupertinoDialog<void>(
            context: context,
            builder: (dialogContext) => CupertinoAlertDialog(
              content: Text(S.of(context).Resume_Game_Unavailable),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(S.of(context).Done),
                ),
              ],
            ),
          );
          return;
        }
      } else {
        if (!await confirmNewGame(context, appModel) || !mounted) return;
        await appModel.prepareQuickPlay();
        if (!mounted) return;
        appModel.newGame(context, notify: false);
      }
      if (!mounted) return;
      await Navigator.push<void>(
        context,
        CupertinoPageRoute(builder: (_) => ChessView(appModel: appModel)),
      );
    } finally {
      if (mounted) setState(() => _openingGame = false);
    }
  }

  Future<void> _openDailyPuzzle(AppModel appModel) async {
    await Navigator.push<void>(
      context,
      CupertinoPageRoute(
        builder: (_) => DailyPuzzlePage(pieceTheme: appModel.pieceTheme),
      ),
    );
    if (mounted) await _refreshDailyProgress();
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

      final consentAllowsAds = await AdsManager.gatherConsent();
      if (!mounted) {
        return;
      }
      if (!consentAllowsAds) {
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
    double width = MediaQuery.of(context).size.height < 800 ? 72 : 100;

    return Consumer<AppModel>(
      builder: (context, appModel, child) {
        return Container(
          decoration: BoxDecoration(gradient: appModel.theme.background),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 24,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            10, MediaQuery.of(context).padding.top + 12, 10, 0),
                        child: Image.asset(
                          'assets/images/chess-piece.png',
                          width: width,
                        ),
                      ),
                      const SizedBox(height: 30),
                      HomePlayActions(
                        hasSavedGame: appModel.hasResumableGame,
                        solvedToday: _dailyProgress.solvedToday,
                        streak: _dailyProgress.streak,
                        isLoading: !_ready || _openingGame,
                        onContinue: () => _openGame(appModel, resume: true),
                        onQuickPlay: () => _openGame(appModel),
                        onDailyPuzzle: () => _openDailyPuzzle(appModel),
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
