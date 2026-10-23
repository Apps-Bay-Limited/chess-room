import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsManager {
  static bool disableAllAdsForScreenshot = false;
  static final ValueNotifier<bool> isInitialized = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> isAdsRemoved = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> isPurchaseFlowActive =
      ValueNotifier<bool>(false);
  static final ValueNotifier<bool> privacyOptionsRequired =
      ValueNotifier<bool>(false);
  static final Set<Object> _practiceSessions = {};
  static final Set<Object> _fullScreenAdSessions = {};
  static final ValueNotifier<int> practiceSessionCount = ValueNotifier<int>(0);

  /// Includes nested practice screens; leaving one screen cannot release the
  /// protection held by a parent or another active practice screen.
  static bool get isPracticeInProgress => _practiceSessions.isNotEmpty;

  /// Includes the native presentation request, before its show callback, so a
  /// review prompt cannot race the fullscreen ad's presentation.
  static bool get isFullScreenAdShowing => _fullScreenAdSessions.isNotEmpty;

  static VoidCallback beginPracticeSession() {
    final session = Object();
    _practiceSessions.add(session);
    practiceSessionCount.value = _practiceSessions.length;
    return () {
      if (_practiceSessions.remove(session)) {
        practiceSessionCount.value = _practiceSessions.length;
      }
    };
  }

  // Android Release IDs (Injected via --dart-define)
  static const String _bannerAdUnitIdAndroidRelease =
      String.fromEnvironment('BANNER_ID_ANDROID', defaultValue: '');
  static const String _openAdUnitIDAndroidRelease =
      String.fromEnvironment('OPEN_AD_ID_ANDROID', defaultValue: '');
  static const String _rewardedAdIDAndroidRelease =
      String.fromEnvironment('REWARD_AD_ID_ANDROID', defaultValue: '');
  static const String _rewardedInterstitialAdIDAndroidRelease =
      String.fromEnvironment('REWARD_INTERSTITIAL_AD_ID_ANDROID',
          defaultValue: '');

  // iOS Release IDs (Injected via --dart-define)
  static const String _bannerAdUnitIdIOSRelease =
      String.fromEnvironment('BANNER_ID_IOS', defaultValue: '');
  static const String _openAdUnitIDIOSRelease =
      String.fromEnvironment('OPEN_AD_ID_IOS', defaultValue: '');
  static const String _rewardedAdIDIOSRelease =
      String.fromEnvironment('REWARD_AD_ID_IOS', defaultValue: '');
  static const String _rewardedInterstitialAdIDIOSRelease =
      String.fromEnvironment('REWARD_INTERSTITIAL_AD_ID_IOS', defaultValue: '');

  static const List<String> _releaseAdUnitIds = [
    _bannerAdUnitIdAndroidRelease,
    _openAdUnitIDAndroidRelease,
    _rewardedAdIDAndroidRelease,
    _rewardedInterstitialAdIDAndroidRelease,
    _bannerAdUnitIdIOSRelease,
    _openAdUnitIDIOSRelease,
    _rewardedAdIDIOSRelease,
    _rewardedInterstitialAdIDIOSRelease,
  ];

  static bool get releaseConfigurationIsValid => _releaseAdUnitIds.every(
        (id) => id.isNotEmpty && !id.contains('ca-app-pub-3940256099942544/'),
      );

  static void logReleaseConfigurationStatus() {
    if (kDebugMode) return;
    if (releaseConfigurationIsValid) {
      debugPrint(
        'Release configuration check passed: all 8 production ad-unit IDs resolved.',
      );
    } else {
      debugPrint(
        'Release configuration check failed: ads are disabled because a production ad-unit ID is missing or invalid.',
      );
    }
  }

  static String get bannerAdUnitId {
    if (disableAllAdsForScreenshot) return "";
    if (Platform.isAndroid) {
      return kDebugMode
          ? "ca-app-pub-3940256099942544/6300978111"
          : _bannerAdUnitIdAndroidRelease;
    } else if (Platform.isIOS) {
      return kDebugMode
          ? "ca-app-pub-3940256099942544/2934735716"
          : _bannerAdUnitIdIOSRelease;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get openAdUnitID {
    if (disableAllAdsForScreenshot) return "";
    if (Platform.isAndroid) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/3419835294'
          : _openAdUnitIDAndroidRelease;
    } else if (Platform.isIOS) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/5575463023'
          : _openAdUnitIDIOSRelease;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardAdUnitID {
    if (disableAllAdsForScreenshot) return "";
    if (Platform.isAndroid) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/5224354917'
          : _rewardedAdIDAndroidRelease;
    } else if (Platform.isIOS) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/1712485313'
          : _rewardedAdIDIOSRelease;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardInterstitialAdUnitID {
    if (disableAllAdsForScreenshot) return "";
    if (Platform.isAndroid) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/5354046379'
          : _rewardedInterstitialAdIDAndroidRelease;
    } else if (Platform.isIOS) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/6978759866'
          : _rewardedInterstitialAdIDIOSRelease;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static void debugPrintID() {
    if (kDebugMode) {
      debugPrint('bannerAdUnitId: ${AdsManager.bannerAdUnitId}');
    }
  }

  static bool get canRequestAds {
    return isInitialized.value &&
        (kDebugMode || releaseConfigurationIsValid) &&
        !isAdsRemoved.value &&
        !isPurchaseFlowActive.value &&
        !disableAllAdsForScreenshot;
  }

  static Future<bool> gatherConsent() async {
    if (!Platform.isAndroid && !Platform.isIOS) return false;

    final result = Completer<bool>();

    Future<void> finish() async {
      await _refreshPrivacyOptionsRequirement();
      final canRequest = await ConsentInformation.instance.canRequestAds();
      if (!result.isCompleted) result.complete(canRequest);
    }

    try {
      ConsentInformation.instance.requestConsentInfoUpdate(
        ConsentRequestParameters(),
        () async {
          await ConsentForm.loadAndShowConsentFormIfRequired((_) {});
          await finish();
        },
        (_) async => finish(),
      );
    } catch (_) {
      await finish();
    }

    return result.future;
  }

  static Future<void> showPrivacyOptionsForm() async {
    await ConsentForm.showPrivacyOptionsForm((_) {});
    await _refreshPrivacyOptionsRequirement();
  }

  static Future<void> _refreshPrivacyOptionsRequirement() async {
    final status =
        await ConsentInformation.instance.getPrivacyOptionsRequirementStatus();
    privacyOptionsRequired.value =
        status == PrivacyOptionsRequirementStatus.required;
  }

  static Future<void> initialize({required bool adsRemoved}) async {
    isAdsRemoved.value = adsRemoved;
    if (adsRemoved ||
        isInitialized.value ||
        disableAllAdsForScreenshot ||
        (!kDebugMode && !releaseConfigurationIsValid)) {
      return;
    }

    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        maxAdContentRating: MaxAdContentRating.g,
        tagForChildDirectedTreatment: TagForChildDirectedTreatment.no,
        tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.unspecified,
      ),
    );
    await MobileAds.instance.initialize();
    debugPrintID();
    isInitialized.value = true;
  }

  static void setAdsRemoved(bool adsRemoved) {
    isAdsRemoved.value = adsRemoved;
  }

  static void setPurchaseFlowActive(bool active) {
    isPurchaseFlowActive.value = active;
  }
}

class AppOpenAdManager {
  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  Object? _presentation;
  int _lifecycleGeneration = 0;
  final DateTime Function() _now;

  AppOpenAdManager({DateTime Function()? now}) : _now = now ?? DateTime.now;

  @visibleForTesting
  AppOpenAdManager.withCachedAd(AppOpenAd ad, {DateTime Function()? now})
      : _now = now ?? DateTime.now {
    _appOpenAd = ad;
    _appOpenLoadTime = _now();
  }

  /// Maximum duration allowed between loading and showing the ad.
  final Duration maxCacheDuration = const Duration(hours: 4);

  /// Keep track of load time so we don't show an expired ad.
  DateTime? _appOpenLoadTime;

  /// Load an AppOpenAd.
  void loadAd() {
    if (!AdsManager.canRequestAds || AdsManager.openAdUnitID.isEmpty) {
      return;
    }

    final generation = _lifecycleGeneration;
    AppOpenAd.load(
      adUnitId: AdsManager.openAdUnitID,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          if (generation != _lifecycleGeneration || !AdsManager.canRequestAds) {
            ad.dispose();
            return;
          }
          if (kDebugMode) {
            debugPrint('$ad loaded');
          }
          _appOpenLoadTime = _now();
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          if (kDebugMode) {
            debugPrint('AppOpenAd failed to load: $error');
          }
        },
      ),
    );
  }

  /// Whether an ad is available to be shown.
  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  void dispose() {
    _lifecycleGeneration++;
    _appOpenAd?.dispose();
    _appOpenAd = null;
    final presentation = _presentation;
    if (presentation != null) _finishPresentation(presentation);
  }

  bool _finishPresentation(Object presentation) {
    AdsManager._fullScreenAdSessions.remove(presentation);
    if (identical(_presentation, presentation)) {
      _presentation = null;
      _isShowingAd = false;
      return true;
    }
    return false;
  }

  /// Returns true when a loaded ad is handed to the SDK for display. A missing
  /// or blocked ad does not consume the foreground-ad cooldown.
  bool showAdIfAvailable() {
    if (AdsManager.isAdsRemoved.value ||
        AdsManager.isPurchaseFlowActive.value) {
      dispose();
      return false;
    }
    if (!AdsManager.canRequestAds ||
        AdsManager.isPracticeInProgress ||
        AdsManager.isFullScreenAdShowing) {
      return false;
    }

    if (!isAdAvailable) {
      if (kDebugMode) {
        debugPrint('Tried to show ad before available.');
      }
      loadAd();
      return false;
    }
    if (_isShowingAd) {
      if (kDebugMode) {
        debugPrint('Tried to show ad while already showing an ad.');
      }
      return false;
    }
    if (_appOpenLoadTime != null &&
        _now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      if (kDebugMode) {
        debugPrint('Maximum cache duration exceeded. Loading another ad.');
      }
      _appOpenAd?.dispose();
      _appOpenAd = null;
      loadAd();
      return false;
    }

    final adToShow = _appOpenAd!;
    final presentation = Object();
    final generation = _lifecycleGeneration;
    // Set the fullScreenContentCallback and show the ad.
    adToShow.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        if (generation != _lifecycleGeneration) return;
        if (kDebugMode) {
          debugPrint('$ad onAdShowedFullScreenContent');
        }
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        if (kDebugMode) {
          debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        }
        _finishPresentation(presentation);
        ad.dispose();
        if (identical(_appOpenAd, ad)) _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        if (kDebugMode) {
          debugPrint('$ad onAdDismissedFullScreenContent');
        }
        final wasCurrent = _finishPresentation(presentation);
        ad.dispose();
        if (identical(_appOpenAd, ad)) _appOpenAd = null;
        if (wasCurrent && generation == _lifecycleGeneration) loadAd();
      },
    );
    // Mark the request synchronously so duplicate lifecycle notifications
    // cannot hand the same cached ad to the SDK twice.
    _isShowingAd = true;
    _presentation = presentation;
    AdsManager._fullScreenAdSessions.add(presentation);
    unawaited(Future<void>.sync(adToShow.show)
        .catchError((Object error, StackTrace stackTrace) {
      _finishPresentation(presentation);
      adToShow.dispose();
      if (identical(_appOpenAd, adToShow)) _appOpenAd = null;
      if (kDebugMode) debugPrint('AppOpenAd show request failed: $error');
    }));
    return true;
  }
}

/// Listens for app foreground events and shows app open ads.
class AppLifecycleReactor extends WidgetsBindingObserver {
  final AppOpenAdManager appOpenAdManager;

  /// Called to check whether a game is currently in progress; when true,
  /// the app-open ad is skipped so it can't interrupt an active match.
  final bool Function() isGameInProgress;
  final bool Function() isPurchaseFlowActive;
  final bool Function() isPracticeInProgress;
  final DateTime Function() _now;
  final Duration minimumBackgroundDuration;
  final Duration cooldown;
  DateTime? _backgroundedAt;
  DateTime? _lastAdRequestedAt;

  bool get hasEnterBackground => _backgroundedAt != null;

  AppLifecycleReactor({
    required this.appOpenAdManager,
    required this.isGameInProgress,
    required this.isPurchaseFlowActive,
    bool Function()? isPracticeInProgress,
    DateTime Function()? now,
    this.minimumBackgroundDuration = const Duration(seconds: 30),
    this.cooldown = const Duration(minutes: 5),
  })  : isPracticeInProgress =
            isPracticeInProgress ?? (() => AdsManager.isPracticeInProgress),
        _now = now ?? DateTime.now;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    // Try to show an app open ad if the app is being resumed and
    // we're not already showing an app open ad.
    if (kDebugMode) {
      debugPrint('didChangeAppLifecycleState: $state');
    }
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      // Keep the first background timestamp when platforms emit both states.
      _backgroundedAt ??= _now();
    }
    if (state != AppLifecycleState.resumed) return;
    final backgroundedAt = _backgroundedAt;
    _backgroundedAt = null;
    if (backgroundedAt == null) return;
    final now = _now();
    if (now.difference(backgroundedAt) < minimumBackgroundDuration ||
        (_lastAdRequestedAt != null &&
            now.difference(_lastAdRequestedAt!) < cooldown) ||
        !AdsManager.canRequestAds ||
        AdsManager.isFullScreenAdShowing ||
        isGameInProgress() ||
        isPurchaseFlowActive() ||
        isPracticeInProgress()) {
      return;
    }
    if (appOpenAdManager.showAdIfAvailable()) {
      _lastAdRequestedAt = now;
    }
  }
}
