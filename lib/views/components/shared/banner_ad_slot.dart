import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../util/ads_manager.dart';

/// Manages a bottom banner ad's lifecycle and reserves its layout space up
/// front, so content never jumps or gets covered when the ad loads (or
/// fails to load). Place at the bottom of a screen's Column, not in a Stack.
class BannerAdSlot extends StatefulWidget {
  const BannerAdSlot({super.key});

  static const double height = 50;

  @override
  State<BannerAdSlot> createState() => _BannerAdSlotState();
}

class _BannerAdSlotState extends State<BannerAdSlot> {
  BannerAd? _ad;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    AdsManager.isInitialized.addListener(_maybeLoadAd);
    _maybeLoadAd();
  }

  @override
  void dispose() {
    AdsManager.isInitialized.removeListener(_maybeLoadAd);
    _ad?.dispose();
    super.dispose();
  }

  void _maybeLoadAd() {
    if (!mounted || !AdsManager.isInitialized.value || _ad != null) {
      return;
    }

    final adUnitId = AdsManager.bannerAdUnitId;
    if (adUnitId.isEmpty) {
      return;
    }

    _ad = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _isAdLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _ad = null;
          debugPrint(
              'Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
        height: BannerAdSlot.height,
        width: double.infinity,
        child: _isAdLoaded && _ad != null
            ? Center(child: AdWidget(ad: _ad!))
            : const SizedBox.shrink(),
      ),
    );
  }
}
