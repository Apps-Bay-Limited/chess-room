import 'dart:async';
import 'dart:convert';

import 'package:chess_room/util/premium_purchase_service.dart'
    show premiumProductId;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:integration_test/integration_test.dart';

// Product lookup is non-purchasing. Enable VERIFY_RESTORE only after explicitly
// setting up the intended sandbox account; restore may invoke native sign-in.
// Neither path creates a purchase, completes a transaction, validates a receipt,
// initializes the app's entitlement service, or writes entitlement preferences.
const _verifyRestore = bool.fromEnvironment('VERIFY_RESTORE');
const _availabilityTimeout = Duration(seconds: 10);
const _queryTimeout = Duration(seconds: 20);
const _restoreTimeout = Duration(seconds: 25);
const _restoreObservationTimeout = Duration(seconds: 5);

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final supported = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  if (!supported) {
    _report(binding, {
      'schemaVersion': 1,
      'platform': defaultTargetPlatform.name,
      'status': 'skipped',
      'reason': 'remove_ads_is_currently_supported_on_ios_only',
      'restoreRequested': _verifyRestore,
      'purchaseAttempted': false,
    });
  }

  testWidgets('native remove-ads product availability probe', (tester) async {
    final result = <String, Object?>{
      'schemaVersion': 1,
      'platform': defaultTargetPlatform.name,
      'checkedAtUtc': DateTime.now().toUtc().toIso8601String(),
      'requestedProductIDs': [premiumProductId],
      'storeAvailable': false,
      'productFound': false,
      'notFoundProductIDs': <String>[],
      'queryStatus': 'not_run',
      'restoreRequested': _verifyRestore,
      'restoreStatus': 'not_requested',
      'purchaseAttempted': false,
      'entitlementPreferencesWritten': false,
      // Even a restored event is not receipt verification or an entitlement test.
      'restorationVerified': false,
    };
    final failures = <String>[];
    final stopwatch = Stopwatch()..start();
    await tester.pumpWidget(const SizedBox.shrink());
    try {
      final store = InAppPurchase.instance;
      try {
        final available =
            await store.isAvailable().timeout(_availabilityTimeout);
        result['storeAvailable'] = available;
        result['availabilityStatus'] = available ? 'available' : 'unavailable';
        if (!available) failures.add('The native store is unavailable.');
      } catch (error) {
        result['availabilityStatus'] =
            error is TimeoutException ? 'timeout' : 'error';
        result['availabilityError'] = _safeError(error);
        failures
            .add('Native store availability did not complete successfully.');
      }

      if (result['storeAvailable'] == true) {
        try {
          final response = await store
              .queryProductDetails({premiumProductId}).timeout(_queryTimeout);
          final matching = response.productDetails
              .where((product) => product.id == premiumProductId)
              .toList();
          result['productFound'] = matching.isNotEmpty;
          // Record public queried IDs only; never output transaction IDs,
          // account identifiers, receipts, error messages or error details.
          result['returnedProductIDs'] =
              matching.map((product) => product.id).toSet().toList()..sort();
          result['notFoundProductIDs'] = response.notFoundIDs
              .where((id) => id == premiumProductId)
              .toSet()
              .toList()
            ..sort();
          result['unexpectedProductCount'] =
              response.productDetails.length - matching.length;
          result['unexpectedNotFoundCount'] = response.notFoundIDs
              .where((id) => id != premiumProductId)
              .length;
          final error = response.error;
          result['queryStatus'] = error != null
              ? 'error'
              : matching.isEmpty
                  ? 'not_found'
                  : 'found';
          if (error != null) {
            result['queryError'] = {
              'source': _safeCode(error.source),
              'code': _safeCode(error.code),
            };
            failures.add('The native product query returned an error.');
          }
          if (matching.isEmpty) {
            failures.add('The configured remove-ads product was not returned.');
          }
        } catch (error) {
          result['queryStatus'] =
              error is TimeoutException ? 'timeout' : 'error';
          result['queryError'] = _safeError(error);
          failures
              .add('The native product query did not complete successfully.');
        }

        if (_verifyRestore) {
          await _observeRestore(store, result, failures);
        }
      } else if (_verifyRestore) {
        result['restoreStatus'] = 'skipped_store_unavailable';
      }
    } catch (error) {
      result['probeError'] = _safeError(error);
      failures.add('The native store probe could not initialize.');
    } finally {
      stopwatch.stop();
      result['elapsedMilliseconds'] = stopwatch.elapsedMilliseconds;
      result['status'] = failures.isEmpty ? 'product_ready' : 'not_ready';
      _report(binding, result);
    }
    expect(failures, isEmpty,
        reason:
            'See storeAvailability report data and sanitized console output.');
  }, skip: !supported, timeout: const Timeout(Duration(seconds: 90)));
}

Future<void> _observeRestore(InAppPurchase store, Map<String, Object?> result,
    List<String> failures) async {
  var matchingRestoredEvents = 0;
  var otherProductEvents = 0;
  var streamErrors = 0;
  final observed = Completer<void>();
  final subscription = store.purchaseStream.listen((purchases) {
    for (final purchase in purchases) {
      if (purchase.productID != premiumProductId) {
        otherProductEvents++;
      } else if (purchase.status == PurchaseStatus.restored) {
        matchingRestoredEvents++;
        if (!observed.isCompleted) observed.complete();
      }
    }
  }, onError: (Object error) {
    streamErrors++;
    result['restoreStreamError'] = _safeError(error);
    if (!observed.isCompleted) observed.complete();
  });
  try {
    await store.restorePurchases().timeout(_restoreTimeout);
    if (!observed.isCompleted) {
      await observed.future
          .timeout(_restoreObservationTimeout, onTimeout: () {});
    }
    result['restoreStatus'] = matchingRestoredEvents > 0
        ? 'matching_restored_event_observed'
        : 'invocation_completed_no_matching_event_observed';
  } catch (error) {
    result['restoreStatus'] = error is TimeoutException ? 'timeout' : 'error';
    result['restoreError'] = _safeError(error);
    failures.add('The optional native restore invocation did not complete.');
  } finally {
    // A timeout bounds the Dart wait; StoreKit does not expose cancellation of
    // an already submitted native restore. No entitlement is granted here.
    try {
      await subscription.cancel().timeout(const Duration(seconds: 3));
    } catch (error) {
      result['restoreCleanupError'] = _safeError(error);
      failures.add('The optional restore listener did not close cleanly.');
    }
    result['matchingRestoredEventCount'] = matchingRestoredEvents;
    result['otherProductEventCount'] = otherProductEvents;
    result['restoreStreamErrorCount'] = streamErrors;
    if (streamErrors > 0) failures.add('The restore stream reported an error.');
  }
}

Map<String, String> _safeError(Object error) => {
      'type': error.runtimeType.toString(),
      if (error is PlatformException) 'code': _safeCode(error.code),
    };

String _safeCode(String code) =>
    RegExp(r'^[A-Za-z0-9_.-]{1,80}$').hasMatch(code) ? code : 'redacted';

void _report(
    IntegrationTestWidgetsFlutterBinding binding, Map<String, Object?> result) {
  // The binding's reportData is returned to the driver as response data.
  binding.reportData = {...?binding.reportData, 'storeAvailability': result};
  debugPrint('store-availability ${jsonEncode(result)}');
}
