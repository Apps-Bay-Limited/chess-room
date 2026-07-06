import 'package:chess_room/model/app_model.dart';
import 'package:chess_room/views/components/shared/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../chess_view.dart';
import '../../settings_view.dart';

class MainMenuButtons extends StatelessWidget {
  final AppModel appModel;

  const MainMenuButtons(this.appModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          RoundedButton(
            label: 'Start',
            onPressed: () {
              appModel.newGame(context, notify: false);
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ChessView(appModel: appModel),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: RoundedButton(
                  label: 'GitHub',
                  onPressed: () {
                    _openGitHub();
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: RoundedButton(
                  label: 'Settings',
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => SettingsView(appModel: appModel),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openGitHub() async {
    const url = 'https://github.com/PScottZero/EnPassant';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
