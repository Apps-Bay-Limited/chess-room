import 'dart:async';

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
import '../util/app_design.dart';
import 'components/shared/app_page.dart';
import 'components/shared/banner_ad_slot.dart';

class MainMenuView extends StatefulWidget {
  final bool initializeServices;

  const MainMenuView({super.key, this.initializeServices = true});

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
  late final VoidCallback _practiceListener;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AdsManager.practiceSessionCount.removeListener(_practiceListener);
    _appModel?.purchaseService.removeListener(_handlePremiumChanged);
    _stopAppOpenAds();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _practiceListener = () {
      if (!AdsManager.isPracticeInProgress) _requestRatingAtRest();
    };
    AdsManager.practiceSessionCount.addListener(_practiceListener);
    if (widget.initializeServices) {
      unawaited(InAppReviewHelper.shared.initialize());
    }
    _refreshDailyProgress();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final appModel = context.read<AppModel>();
      await appModel.initialization;
      if (mounted) setState(() => _ready = true);
    });

    if (!kIsWeb && widget.initializeServices) {
      _initAppServices();
    }
  }

  void _requestRatingAtRest() {
    if (!widget.initializeServices || !mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final model = context.read<AppModel>();
      unawaited(InAppReviewHelper.shared.maybeRequestReview(
        isBlocked: () =>
            !mounted ||
            WidgetsBinding.instance.lifecycleState !=
                AppLifecycleState.resumed ||
            !(ModalRoute.of(context)?.isCurrent ?? false) ||
            model.gameInProgress ||
            AdsManager.isPracticeInProgress ||
            AdsManager.isFullScreenAdShowing ||
            model.purchaseService.isStoreFlowActive,
      ));
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshDailyProgress();
  }

  Future<void> _refreshDailyProgress() async {
    try {
      final progress =
          await SharedPreferencesPuzzleProgressStore().load(DateTime.now());
      if (mounted) setState(() => _dailyProgress = progress);
    } catch (_) {
      // Keep Home usable and retain its last known progress if local storage
      // is unavailable or contains values written with an incompatible type.
    }
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
      _requestRatingAtRest();
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
    _requestRatingAtRest();
  }

  Future<void> _openSetup(AppModel model, int players) async {
    model.setPlayerCount(players);
    await Navigator.push<void>(
      context,
      CupertinoPageRoute(builder: (_) => const SinglePlayerView()),
    );
    _requestRatingAtRest();
  }

  Future<void> _initAppServices() async {
    // Show ATT prompt after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }

      _appModel = Provider.of<AppModel>(context, listen: false);
      _appModel?.purchaseService.addListener(_handlePremiumChanged);
      await _appModel!.purchaseInitialization;
      if (!mounted) {
        return;
      }

      AdsManager.setAdsRemoved(_appModel!.isPremium);
      if (_appModel!.isPremium || !AdsManager.isSupportedPlatform) {
        _stopAppOpenAds();
        return;
      }

      final consentAllowsAds = await AdsManager.gatherConsent();
      if (!mounted) {
        return;
      }
      if (!consentAllowsAds) {
        return;
      }

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final status =
            await AppTrackingTransparency.trackingAuthorizationStatus;
        if (status == TrackingStatus.notDetermined) {
          await AppTrackingTransparency.requestTrackingAuthorization();
        }
      }

      await AdsManager.initialize(adsRemoved: _appModel!.isPremium);
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
    });
  }

  void _handlePremiumChanged() {
    final appModel = _appModel;
    if (appModel == null) {
      return;
    }

    AdsManager.setAdsRemoved(appModel.isPremium);
    AdsManager.setPurchaseFlowActive(
        appModel.purchaseService.isStoreFlowActive);
    if (appModel.isPremium) {
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
    return Consumer<AppModel>(
      builder: (context, appModel, child) {
        final strings = S.of(context);
        return AppPage(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: AppContent(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/chess-piece.png',
                              width: 36,
                              height: 36,
                              excludeFromSemantics: true,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text(
                                strings.Chess_Room,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Semantics(
                              label: strings.Settings,
                              button: true,
                              child: CupertinoButton(
                                key: const ValueKey('settings-button'),
                                padding: const EdgeInsets.all(AppSpacing.md),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          SettingsView(appModel: appModel),
                                    ),
                                  );
                                },
                                child: const Icon(
                                  CupertinoIcons.gear_alt,
                                  color: AppColors.textSecondary,
                                  size: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          strings.Home_Subtitle,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        HomePlayActions(
                          hasSavedGame: appModel.hasResumableGame,
                          solvedToday: _dailyProgress.solvedToday,
                          streak: _dailyProgress.streak,
                          isLoading: !_ready || _openingGame,
                          onContinue: () => _openGame(appModel, resume: true),
                          onQuickPlay: () => _openGame(appModel),
                          onDailyPuzzle: () => _openDailyPuzzle(appModel),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        Text(
                          strings.Home_Play_Options,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _HomeDestination(
                          key: const ValueKey('vs-ai-button'),
                          title: strings.Vs_AI_Player,
                          detail: strings.Home_AI_Description,
                          icon: CupertinoIcons.slider_horizontal_3,
                          onTap: () => _openSetup(appModel, 1),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _HomeDestination(
                          key: const ValueKey('two-players-button'),
                          title: strings.Two_Players,
                          detail: strings.Home_Local_Description,
                          icon: CupertinoIcons.person_2,
                          onTap: () => _openSetup(appModel, 2),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _HomeDestination(
                          key: const ValueKey('training-button'),
                          title: strings.Training,
                          detail: strings.Home_Training_Description,
                          icon: CupertinoIcons.book,
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
                      ],
                    ),
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

class _HomeDestination extends StatelessWidget {
  final String title;
  final String detail;
  final IconData icon;
  final VoidCallback onTap;

  const _HomeDestination({
    super.key,
    required this.title,
    required this.detail,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(AppSpacing.lg),
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.md),
      onPressed: onTap,
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent, size: 23),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  detail,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Icon(
            CupertinoIcons.chevron_forward,
            color: AppColors.textSecondary,
            size: 15,
          ),
        ],
      ),
    );
  }
}
