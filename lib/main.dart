import 'package:chess_room/views/main_menu_view.dart';
import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'generated/l10n.dart';
import 'logic/shared_functions.dart';
import 'model/app_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppModel(),
      child: App(),
    ),
  );
  _loadFlameAssets();
}

void _loadFlameAssets() async {
  List<String> pieceImages = [];
  for (var theme in PIECE_THEMES) {
    for (var color in ['black', 'white']) {
      for (var piece in ['king', 'queen', 'rook', 'bishop', 'knight', 'pawn']) {
        pieceImages
            .add('pieces/${formatPieceTheme(theme)}/${piece}_$color.png');
      }
    }
  }
  await Flame.images.loadAll(pieceImages);
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: CupertinoApp(
        title: 'Chess Room',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        localeResolutionCallback: (locale, supportLocales) {
          if (kDebugMode) {
            debugPrint('$locale');
          }
          // 中文 简繁体处理
          if (locale?.languageCode == 'zh') {
            if (locale?.scriptCode == 'Hant') {
              return const Locale('zh', 'HK'); //繁体
            } else {
              return const Locale('zh', ''); //简体
            }
          }
          for (final supportedLocale in supportLocales) {
            if (supportedLocale.languageCode == locale?.languageCode) {
              return supportedLocale;
            }
          }
          return const Locale('en', '');
        },
        theme: CupertinoThemeData(
          brightness: Brightness.dark,
          textTheme: CupertinoTextThemeData(
            textStyle: TextStyle(fontFamily: 'Jura', fontSize: 16),
            pickerTextStyle: TextStyle(fontFamily: 'Jura'),
          ),
        ),
        home: MainMenuView(),
      ),
    );
  }
}
