import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsManager {
  static bool disableAllAdsForScreenshot = false;
  static final ValueNotifier<bool> isInitialized = ValueNotifier<bool>(false);

  // Android Release IDs (Injected via --dart-define)
  static const String _bannerAdUnitIdAndroidRelease = String.fromEnvironment(
      'BANNER_ID_ANDROID',
      defaultValue: 'ca-app-pub-3940256099942544/6300978111');
  static const String _openAdUnitIDAndroidRelease = String.fromEnvironment(
      'OPEN_AD_ID_ANDROID',
      defaultValue: 'ca-app-pub-3940256099942544/3419835294');
  static const String _rewardedAdIDAndroidRelease = String.fromEnvironment(
      'REWARD_AD_ID_ANDROID',
      defaultValue: 'ca-app-pub-3940256099942544/5224354917');
  static const String _rewardedInterstitialAdIDAndroidRelease =
      String.fromEnvironment('REWARD_INTERSTITIAL_AD_ID_ANDROID',
          defaultValue: 'ca-app-pub-3940256099942544/5354046379');

  // iOS Release IDs (Injected via --dart-define)
  static const String _bannerAdUnitIdIOSRelease = String.fromEnvironment(
      'BANNER_ID_IOS',
      defaultValue: 'ca-app-pub-3940256099942544/2934735716');
  static const String _openAdUnitIDIOSRelease = String.fromEnvironment(
      'OPEN_AD_ID_IOS',
      defaultValue: 'ca-app-pub-3940256099942544/5575463023');
  static const String _rewardedAdIDIOSRelease = String.fromEnvironment(
      'REWARD_AD_ID_IOS',
      defaultValue: 'ca-app-pub-3940256099942544/1712485313');
  static const String _rewardedInterstitialAdIDIOSRelease =
      String.fromEnvironment('REWARD_INTERSTITIAL_AD_ID_IOS',
          defaultValue: 'ca-app-pub-3940256099942544/6978759866');

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
    print("bannerAdUnitId: ${AdsManager.bannerAdUnitId}");
  }

  static Future<void> initialize() async {
    if (isInitialized.value || disableAllAdsForScreenshot) {
      return;
    }

    await MobileAds.instance.initialize();
    debugPrintID();
    isInitialized.value = true;
  }
}

class AppOpenAdManager {
  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;

  /// Maximum duration allowed between loading and showing the ad.
  final Duration maxCacheDuration = const Duration(hours: 4);

  /// Keep track of load time so we don't show an expired ad.
  DateTime? _appOpenLoadTime;

  /// Load an AppOpenAd.
  void loadAd() {
    if (!AdsManager.isInitialized.value || AdsManager.openAdUnitID.isEmpty) {
      return;
    }

    AppOpenAd.load(
      adUnitId: AdsManager.openAdUnitID,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          print('$ad loaded');
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed to load: $error');
        },
      ),
    );
  }

  /// Whether an ad is available to be shown.
  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  void showAdIfAvailable() {
    if (!isAdAvailable) {
      print('Tried to show ad before available.');
      loadAd();
      return;
    }
    if (_isShowingAd) {
      print('Tried to show ad while already showing an ad.');
      return;
    }
    if (_appOpenLoadTime != null &&
        DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      print('Maximum cache duration exceeded. Loading another ad.');
      _appOpenAd?.dispose();
      _appOpenAd = null;
      loadAd();
      return;
    }

    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        print('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        print('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
    _appOpenAd?.show();
  }
}

/// Listens for app foreground events and shows app open ads.
class AppLifecycleReactor extends WidgetsBindingObserver {
  final AppOpenAdManager appOpenAdManager;

  /// Called to check whether a game is currently in progress; when true,
  /// the app-open ad is skipped so it can't interrupt an active match.
  final bool Function() isGameInProgress;

  bool hasEnterBackground = false;

  AppLifecycleReactor(
      {required this.appOpenAdManager, required this.isGameInProgress});

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    // Try to show an app open ad if the app is being resumed and
    // we're not already showing an app open ad.
    print("didChangeAppLifecycleState: $state");
    if (state == AppLifecycleState.paused) {
      hasEnterBackground = true;
    }
    if (state == AppLifecycleState.resumed && hasEnterBackground) {
      if (!isGameInProgress()) {
        appOpenAdManager.showAdIfAvailable();
      }
      hasEnterBackground = false;
    }
  }
}
