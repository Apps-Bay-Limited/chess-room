import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/views/components/main_menu_view/game_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import '../util/ads_manager.dart';
import 'btn.dart';
import 'chess_view.dart';

class SinglePlayerView extends StatefulWidget {
  @override
  _SinglePlayerViewState createState() => _SinglePlayerViewState();
}

class _SinglePlayerViewState extends State<SinglePlayerView> {
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
        return Container(
          decoration: BoxDecoration(gradient: appModel.theme.background),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    GameOptions(appModel),
                    SizedBox(height: 50),
                    Btn(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) {
                              appModel.newGame(context, notify: false);
                              return ChessView(appModel);
                            },
                          ),
                        );
                      },
                      height: 60,
                      width: 260,
                      borderRadius: 250,
                      color: Color(0xffCC996F),
                      child: Text(
                        S.of(context).Start,
                        style: TextStyle(
                            color: Color(0xff473D3D), fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(height: 20),
                    Btn(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      height: 60,
                      width: 260,
                      borderRadius: 250,
                      color: Color(0xffCC996F),
                      child: Text(
                        S.of(context).Back,
                        style: TextStyle(
                            color: Color(0xff473D3D), fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                    ),
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
        );
      },
    );
  }
}
