import 'package:chess_room/util/ads_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  tearDown(() {
    AdsManager.isInitialized.value = false;
    AdsManager.isAdsRemoved.value = false;
    AdsManager.isPurchaseFlowActive.value = false;
    AdsManager.disableAllAdsForScreenshot = false;
  });

  test('canRequestAds is false when Remove Ads entitlement is active', () {
    AdsManager.isInitialized.value = true;

    AdsManager.setAdsRemoved(true);

    expect(AdsManager.canRequestAds, isFalse);
  });

  test('canRequestAds remains true for non-purchased users after ads init', () {
    AdsManager.isInitialized.value = true;

    AdsManager.setAdsRemoved(false);

    expect(AdsManager.canRequestAds, isTrue);
  });

  test('canRequestAds is false while a purchase flow is active', () {
    AdsManager.isInitialized.value = true;
    AdsManager.setAdsRemoved(false);

    AdsManager.setPurchaseFlowActive(true);

    expect(AdsManager.canRequestAds, isFalse);
  });

  group('app-open foreground policy', () {
    late DateTime now;
    late _RecordingAdManager manager;
    late AppLifecycleReactor reactor;
    var gameActive = false;
    var purchaseActive = false;

    setUp(() {
      AdsManager.isInitialized.value = true;
      now = DateTime(2026, 10, 16, 12);
      manager = _RecordingAdManager();
      gameActive = false;
      purchaseActive = false;
      reactor = AppLifecycleReactor(
        appOpenAdManager: manager,
        isGameInProgress: () => gameActive,
        isPurchaseFlowActive: () => purchaseActive,
        now: () => now,
      );
    });

    Future<void> backgroundFor(Duration duration) async {
      await reactor.didChangeAppLifecycleState(AppLifecycleState.paused);
      now = now.add(duration);
      await reactor.didChangeAppLifecycleState(AppLifecycleState.resumed);
    }

    test('ignores cold starts, inactive interruptions and brief backgrounds',
        () async {
      await reactor.didChangeAppLifecycleState(AppLifecycleState.resumed);
      await reactor.didChangeAppLifecycleState(AppLifecycleState.inactive);
      now = now.add(const Duration(minutes: 1));
      await reactor.didChangeAppLifecycleState(AppLifecycleState.resumed);
      await backgroundFor(const Duration(seconds: 29));
      expect(manager.attempts, 0);
      expect(reactor.hasEnterBackground, isFalse);
      await backgroundFor(const Duration(seconds: 30));
      expect(manager.attempts, 1);
    });

    test('honors the cooldown and consumes each foreground event once',
        () async {
      await backgroundFor(const Duration(seconds: 30));
      await reactor.didChangeAppLifecycleState(AppLifecycleState.resumed);
      expect(manager.attempts, 1);
      await backgroundFor(const Duration(minutes: 1));
      expect(manager.attempts, 1);
      await backgroundFor(const Duration(minutes: 4));
      expect(manager.attempts, 2);
    });

    test('an unavailable ad does not consume the cooldown', () async {
      manager.hasAd = false;
      await backgroundFor(const Duration(seconds: 30));
      manager.hasAd = true;
      await backgroundFor(const Duration(seconds: 30));
      expect(manager.attempts, 2);
      expect(manager.presentations, 1);
    });

    test('blocked returns do not defer an ad into the practice session',
        () async {
      final release = AdsManager.beginPracticeSession();
      addTearDown(release);
      await backgroundFor(const Duration(minutes: 1));
      expect(manager.attempts, 0);
      release();
      await reactor.didChangeAppLifecycleState(AppLifecycleState.resumed);
      expect(manager.attempts, 0);
      await backgroundFor(const Duration(seconds: 30));
      expect(manager.presentations, 1);
    });

    test('retains game, purchase, consent, remove-ads and screenshot guards',
        () async {
      gameActive = true;
      await backgroundFor(const Duration(minutes: 1));
      gameActive = false;
      purchaseActive = true;
      await backgroundFor(const Duration(minutes: 1));
      purchaseActive = false;
      AdsManager.isInitialized.value = false;
      await backgroundFor(const Duration(minutes: 1));
      AdsManager.isInitialized.value = true;
      AdsManager.isAdsRemoved.value = true;
      await backgroundFor(const Duration(minutes: 1));
      AdsManager.isAdsRemoved.value = false;
      AdsManager.disableAllAdsForScreenshot = true;
      await backgroundFor(const Duration(minutes: 1));
      expect(manager.attempts, 0);
    });

    test('hidden then paused retains the first background timestamp', () async {
      await reactor.didChangeAppLifecycleState(AppLifecycleState.hidden);
      now = now.add(const Duration(seconds: 20));
      await reactor.didChangeAppLifecycleState(AppLifecycleState.paused);
      now = now.add(const Duration(seconds: 10));
      await reactor.didChangeAppLifecycleState(AppLifecycleState.resumed);
      expect(manager.presentations, 1);
    });
  });

  group('app-open presentation guard', () {
    setUp(() => AdsManager.isInitialized.value = true);

    test('practice protection also applies to direct show requests', () {
      final ad = _FakeAppOpenAd();
      final manager = _CachedAdManager(ad);
      addTearDown(manager.dispose);
      final release = AdsManager.beginPracticeSession();
      addTearDown(release);
      expect(manager.showAdIfAvailable(), isFalse);
      expect(ad.showCalls, 0);
      expect(AdsManager.isFullScreenAdShowing, isFalse);
    });

    test('pending native presentation blocks other ads until dismissal', () {
      final ad = _FakeAppOpenAd();
      final manager = _CachedAdManager(ad);
      addTearDown(manager.dispose);
      expect(manager.showAdIfAvailable(), isTrue);
      expect(AdsManager.isFullScreenAdShowing, isTrue);
      expect(manager.showAdIfAvailable(), isFalse);
      ad.fullScreenContentCallback!.onAdShowedFullScreenContent!(ad);
      expect(AdsManager.isFullScreenAdShowing, isTrue);
      ad.fullScreenContentCallback!.onAdDismissedFullScreenContent!(ad);
      expect(AdsManager.isFullScreenAdShowing, isFalse);
      expect(ad.showCalls, 1);
      expect(manager.loads, 1);
    });

    test('native show failure clears the presentation protection', () {
      final ad = _FakeAppOpenAd();
      final manager = _CachedAdManager(ad);
      addTearDown(manager.dispose);
      manager.showAdIfAvailable();
      ad.fullScreenContentCallback!.onAdFailedToShowFullScreenContent!(
          ad, AdError(1, 'test', 'show failed'));
      expect(AdsManager.isFullScreenAdShowing, isFalse);
      expect(manager.isAdAvailable, isFalse);
    });

    test('an SDK request error clears the presentation protection', () async {
      final ad = _FakeAppOpenAd()..failShowRequest = true;
      final manager = _CachedAdManager(ad);
      addTearDown(manager.dispose);
      manager.showAdIfAvailable();
      await Future<void>.delayed(Duration.zero);
      expect(AdsManager.isFullScreenAdShowing, isFalse);
      expect(manager.isAdAvailable, isFalse);
    });

    test('stale callbacks cannot clear another manager presentation', () {
      final oldAd = _FakeAppOpenAd();
      final oldManager = _CachedAdManager(oldAd);
      addTearDown(oldManager.dispose);
      oldManager.showAdIfAvailable();
      oldManager.dispose();
      final newAd = _FakeAppOpenAd();
      final newManager = _CachedAdManager(newAd);
      addTearDown(newManager.dispose);
      expect(newManager.showAdIfAvailable(), isTrue);
      oldAd.fullScreenContentCallback!.onAdDismissedFullScreenContent!(oldAd);
      oldAd.fullScreenContentCallback!.onAdShowedFullScreenContent!(oldAd);
      expect(AdsManager.isFullScreenAdShowing, isTrue);
      expect(oldManager.loads, 0);
      newManager.dispose();
      expect(AdsManager.isFullScreenAdShowing, isFalse);
    });
  });
}

class _RecordingAdManager extends AppOpenAdManager {
  bool hasAd = true;
  int attempts = 0;
  int presentations = 0;

  @override
  bool showAdIfAvailable() {
    attempts++;
    if (hasAd) presentations++;
    return hasAd;
  }
}

class _CachedAdManager extends AppOpenAdManager {
  int loads = 0;
  _CachedAdManager(AppOpenAd ad) : super.withCachedAd(ad);

  @override
  void loadAd() => loads++;
}

class _FakeAppOpenAd extends Fake implements AppOpenAd {
  @override
  FullScreenContentCallback<AppOpenAd>? fullScreenContentCallback;
  int showCalls = 0;
  bool failShowRequest = false;

  @override
  Future<void> show() async {
    showCalls++;
    if (failShowRequest) throw StateError('native request failed');
  }

  @override
  Future<void> dispose() async {}
}
