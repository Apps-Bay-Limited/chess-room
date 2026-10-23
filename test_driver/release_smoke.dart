import 'dart:io';
import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() => integrationDriver(
      onScreenshot: (name, bytes, [args]) async {
        final output = Platform.environment['CHESS_SCREENSHOT_DIR'] ??
            'build/release-smoke/screenshots';
        final directory = Directory(output);
        await directory.create(recursive: true);
        await File('${directory.path}/$name.png').writeAsBytes(bytes);
        return true;
      },
    );
