# Chess Room 1.4.0+13 — release validation

Recorded 16 October 2026. This records observed checks and remaining work; it does not record store submission or purchase restoration. Log paths below refer to local temporary execution records.

## Automated checks

- **284 unit/widget tests passed:** `/private/tmp/chess_room_release_tests.log`.
- Final direct analyzer run reported **0 errors, 0 warnings and 236 informational findings** across `lib`, `test`, `integration_test` and `test_driver`: `/private/tmp/chess_room_analyzer_release_final.log`.
- **43 store fields across seven locales passed character limits.** Metadata is prepared; account upload has not started.

## Native evidence

| Environment/check | Observed result | Evidence |
| --- | --- | --- |
| Physical iPhone, iOS 26.7.1, profile 1.4.0 (13): save | Passed Quick Play, actual e2/e4 taps, AI reply, Restart → Cancel preserving FEN, daily puzzle input/progress and isolated unfinished-game save. | `/private/tmp/chess_room_iphone_smoke_save.log` |
| Same iPhone, separate retained-app restore launch | Passed Continue with complete FEN, turn, move history and clocks preserved. | `/private/tmp/chess_room_iphone_smoke_restore.log` |
| Native promotion fixture | Passed restored pending-promotion state, actual queen picker, persisted promotion and undo/redo. This does not establish all underpromotions or real OS backgrounding during the dialog. | Combined validation log below |
| Same iPhone, combined target after CocoaPods fix | **All three native tests passed in 13 seconds:** save flow, promotion fixture and product query. | `/private/tmp/chess_room_iphone_validation.log` |
| Normal app entry point, same iPhone/profile | Built in 27.2 seconds, launched in 5.5 seconds, normal app restored. No duplicate WebView class warnings; all eight production ad-unit IDs resolved. This is configuration/launch evidence, not evidence that an ad displayed. | `/private/tmp/chess_room_iphone_normal_app.log` |
| Pixel 10 emulator, Android 17 / API 37, device Wi-Fi/data off and network reported none | Offline save, actual force-stop and separate restore passed; native test phases took 13 and 12 seconds. | Prior offline native run results |
| Same Android emulator, final screenshot/restore run | Passed restore in 8 seconds; final RGB captures completed. | `/private/tmp/chess_room_android_final_capture.log` |
| iPhone 17 Pro Max and iPad 13-inch M5 simulators, iOS 26.5 | Both passed force-stop and separate restore during native capture runs. | Final screenshot sets below |

The iOS dependency fix disables SwiftPM for this project and uses CocoaPods consistently. The deployment target was aligned from iOS 14 to **iOS 15 for Flutter 3.47**. Android tooling is Gradle 8.14.3, AGP 8.11.1 and Kotlin 2.2.21.

## StoreKit evidence

The native iOS store returned `com.appsbay.chessRoom1.remove_ads` in **649 ms**, with no query error or not-found product IDs. Sanitized result: [`validation/store_availability.json`](validation/store_availability.json).

**No purchase, account-backed restoration, receipt validation or entitlement grant was performed.** `restoreRequested`, `purchaseAttempted`, `entitlementPreferencesWritten` and `restorationVerified` are all false. Product lookup does not establish restored ownership or entitlement persistence.

## Screenshot status

All **15 selected English screenshots passed visual review and opaque 8-bit RGB PNG validation**. Native debug-only capture runs at each live screen state; the host writes the returned PNG bytes. Dimensions and hashes are recorded in [`asset_manifest.json`](asset_manifest.json).

| Source | Native dimensions | Verified files |
| --- | --- | --- |
| Android Pixel 10 emulator | 1080 × 1920 | Five in `screenshots/android/` |
| iPhone 17 Pro Max simulator, iOS 26.5 | 1320 × 2868 | Five in `screenshots/iphone/` |
| iPad 13-inch M5 simulator, iOS 26.5 | 2064 × 2752 | Five in `screenshots/ipad/` |

Capture names and states are defined in `README.md` and the native harness. These are emulator/simulator captures, not physical-device screenshots; no store upload has occurred. Both Apple simulators have the normal app restored, status-bar overrides reset and are shut down. The Android emulator has its normal app restored, its original 1600 × 1000/density 160 display overrides and Wi-Fi/data settings restored, and is shut down.

## Release artifacts

- **Android release AAB built successfully** using `tool/release_build.sh android` with validated production ad configuration: `build/app/outputs/bundle/release/app-release.aab` (61.0 MB). `jarsigner -verify` returned **jar verified**, exit 0. Its self-signed certificate has the usual trust-chain/no-timestamp warnings; store acceptance has not been tested.
- Android SHA-256: `173ba98c4846f1eff5a33e7cf605bd91114e172f4db079fd4b29ff51a6c0fadd`.
- Android build/signature logs: `/private/tmp/chess_room_android_release_final.log`, `/private/tmp/chess_room_android_signature_final.log`.
- **App Store IPA built successfully** using `tool/release_build.sh ios`: `build/ios/ipa/Chess Room.ipa` (27.5 MB). Archive and export took 67.4 and 27.0 seconds. The exported app reports version **1.4.0 (13)** and minimum iOS **15.0**.
- The exported app passed `codesign --verify --deep --strict` (exit 0). All **10 bundled privacy manifests** passed the release script's plist and tracking-domain checks. This does not establish App Store review acceptance.
- iOS SHA-256: `53a87f8780b0b0fa1f520093dd4eaafbae2ae0bee5155465c7527bb9f817542b`.
- iOS build/signature logs: `/private/tmp/chess_room_ios_release.log`, `/private/tmp/chess_room_ios_signature.log`.

## Test-device data incident

Initial `flutter drive` commands omitted `--keep-app-running`. Flutter's default cleanup uninstalled the test iPhone app, removing the isolated probe save and **potentially pre-existing local app data**. No pre-existing data backup was available to this task. Subsequent scripts use `--keep-app-running`; retained-app save/restore passed, and the normal app entry point has been restored. Those later passes do not establish recovery of any earlier local data.

## Remaining work

- Use the owner's prepared sandbox account for purchase/restore and entitlement-persistence validation. The unattended native probe does not replace this.
- Validate live AdMob consent and native ad presentation/dismissal with approved test-device setup; check actual OS rating-sheet presentation separately from API eligibility tests.
- Complete subjective audio/haptics and measured performance checks, plus actual OS background/foreground while AI work or promotion is pending. Synthetic lifecycle callbacks only prove callback behavior.
- App Store Connect is signed out. Build/metadata/screenshot uploads, release submission and screenshot-order experiments have not started.
