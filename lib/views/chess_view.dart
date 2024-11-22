import 'dart:async';

import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/views/components/chess_view/chess_board_widget.dart';
import 'package:chess_room/views/components/chess_view/game_info_and_controls.dart';
import 'package:chess_room/views/components/chess_view/promotion_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../util/ads_manager.dart';
import 'components/chess_view/game_info_and_controls/game_status.dart';

class ChessView extends StatefulWidget {
  final AppModel appModel;

  ChessView(this.appModel);

  @override
  _ChessViewState createState() => _ChessViewState(appModel);
}

class _ChessViewState extends State<ChessView> {
  AppModel appModel;

  _ChessViewState(this.appModel);

  BannerAd _ad;

  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();

    _ad = BannerAd(
      adUnitId: AdsManager.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    _ad.load();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) {
        if (appModel.promotionRequested) {
          appModel.promotionRequested = false;
          WidgetsBinding.instance.addPostFrameCallback((_) => _showPromotionDialog(appModel));
        }
        return WillPopScope(
          onWillPop: _willPopCallback,
          child: Container(
            decoration: BoxDecoration(gradient: appModel.theme.background),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      GameInfoAndControls(appModel),
                      SizedBox(height: 30),
                      ChessBoardWidget(appModel),
                      SizedBox(height: 30),
                      GameStatus(),
                    ],
                  ),
                ),
                if (_isAdLoaded)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
                      child: AdWidget(ad: _ad),
                      height: 50.0,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPromotionDialog(AppModel appModel) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return PromotionDialog(appModel);
      },
    );
  }

  Future<bool> _willPopCallback() async {
    if (appModel != null) {
      appModel.exitChessView();
    }
    return true;
  }
}
