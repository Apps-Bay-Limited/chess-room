import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/views/more_apps_page.dart';
import 'package:chess_room/views/settings_view.dart';
import 'package:chess_room/views/single_player_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:user_messaging_platform/user_messaging_platform.dart' as UMP;

import '../generated/l10n.dart';
import '../util/ads_manager.dart';
import 'btn.dart';

class MainMenuView extends StatefulWidget {
  @override
  _MainMenuViewState createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
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

    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    WidgetsBinding.instance?.addObserver(AppLifecycleReactor(appOpenAdManager: appOpenAdManager));
    updateConsent();
  }

  void updateConsent() async {
    // Make sure to continue with the latest consent info.
    var info = await UMP.UserMessagingPlatform.instance.requestConsentInfoUpdate();

    // Show the consent form if consent is required.
    if (info.consentStatus == UMP.ConsentStatus.required) {
      // `showConsentForm` returns the latest consent info, after the consent from has been closed.
      info = await UMP.UserMessagingPlatform.instance.showConsentForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.height < 800 ? 110 : 140;

    return Consumer<AppModel>(
      builder: (context, appModel, child) {
        return Container(
          decoration: BoxDecoration(gradient: appModel.theme.background),
          child: Stack(
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      padding:
                          EdgeInsets.fromLTRB(10, MediaQuery.of(context).padding.top + 30, 10, 0),
                      child: Image.asset(
                        'assets/images/chess-piece.png',
                        width: width,
                      ),
                    ),
                    SizedBox(height: 40),
                    Btn(
                      onTap: () {
                        appModel.setPlayerCount(1);
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => SinglePlayerView(),
                          ),
                        );
                      },
                      height: 60,
                      width: 260,
                      borderRadius: 250,
                      color: Color(0xffCC996F),
                      child: Text(
                        S.of(context).Vs_AI_Player,
                        style: TextStyle(
                            color: Color(0xff473D3D), fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(height: 30),
                    Btn(
                      onTap: () {
                        appModel.setPlayerCount(2);
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => SinglePlayerView(),
                          ),
                        );
                      },
                      height: 60,
                      width: 260,
                      borderRadius: 250,
                      color: Color(0xffCC996F),
                      child: Text(
                        S.of(context).Two_Players,
                        style: TextStyle(
                            color: Color(0xff473D3D), fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(height: 30),
                    Btn(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => SettingsView(),
                          ),
                        );
                      },
                      height: 60,
                      width: 260,
                      borderRadius: 250,
                      color: Color(0xffCC996F),
                      child: Text(
                        S.of(context).Settings,
                        style: TextStyle(
                            color: Color(0xff473D3D), fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(height: 30),
                    Btn(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => MoreAppsPage(),
                          ),
                        );
                      },
                      height: 60,
                      width: 260,
                      borderRadius: 250,
                      color: Color(0xffCC996F),
                      child: Text(
                        S.of(context).More_Apps,
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
