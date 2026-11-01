import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:open_store/open_store.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens an app's store page. `open_store` throws on anything that is not iOS
/// or Android, so the Mac build launches the App Store link itself.
Future<void> openStoreListing({
  required String appStoreId,
  String androidAppBundleId = '',
}) async {
  if (!kIsWeb && Platform.isMacOS) {
    final uri = Uri.parse('https://apps.apple.com/app/id$appStoreId');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return;
  }

  await OpenStore.instance.open(
    appStoreId: appStoreId,
    androidAppBundleId: androidAppBundleId,
  );
}
