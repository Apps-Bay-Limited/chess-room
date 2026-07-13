import 'package:chess_room/model/app_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

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
  AppModel? _appModel;

  @override
  void initState() {
    super.initState();
    AdsManager.isInitialized.addListener(_maybeLoadAd);
    AdsManager.isAdsRemoved.addListener(_handleAdsRemovedChanged);
    AdsManager.isPurchaseFlowActive.addListener(_handleAdsRemovedChanged);
    _maybeLoadAd();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appModel = Provider.of<AppModel>(context, listen: false);
    if (_appModel == appModel) {
      return;
    }
    _appModel?.removeListener(_handleAdsRemovedChanged);
    _appModel = appModel;
    _appModel?.addListener(_handleAdsRemovedChanged);
    _handleAdsRemovedChanged();
  }

  @override
  void dispose() {
    AdsManager.isInitialized.removeListener(_maybeLoadAd);
    AdsManager.isAdsRemoved.removeListener(_handleAdsRemovedChanged);
    AdsManager.isPurchaseFlowActive.removeListener(_handleAdsRemovedChanged);
    _appModel?.removeListener(_handleAdsRemovedChanged);
    _ad?.dispose();
    super.dispose();
  }

  void _handleAdsRemovedChanged() {
    final adsBlocked = AdsManager.isAdsRemoved.value ||
        AdsManager.isPurchaseFlowActive.value ||
        (_appModel?.isAdsRemoved ?? false) ||
        (_appModel?.purchaseService.isStoreFlowActive ?? false);
    if (adsBlocked) {
      _disposeAd();
      return;
    }
    _maybeLoadAd();
  }

  void _disposeAd() {
    final ad = _ad;
    if (ad == null && !_isAdLoaded) {
      return;
    }
    ad?.dispose();
    _ad = null;
    if (mounted) {
      setState(() => _isAdLoaded = false);
    } else {
      _isAdLoaded = false;
    }
  }

  void _maybeLoadAd() {
    if (!mounted ||
        !AdsManager.canRequestAds ||
        (_appModel?.isAdsRemoved ?? false) ||
        (_appModel?.purchaseService.isStoreFlowActive ?? false) ||
        _ad != null) {
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
    if ((_appModel?.isAdsRemoved ?? false) ||
        (_appModel?.purchaseService.isStoreFlowActive ?? false)) {
      return const SizedBox.shrink();
    }

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
