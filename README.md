# Chess Room - Chess Puzzles & Games

Welcome to the **Chess Room**! This repository contains the source code for the **Chess Room - Chess Puzzles & Games** app, available on the [App Store](https://apps.apple.com/us/app/chess-room-chess-puzzles-games/id1642306743). The app is developed using **Flutter**.

## Features

- **Interactive Chess Puzzles**: Solve engaging chess puzzles of varying difficulty.
- **Play Chess Games**: Compete against AI opponents or other players.
- **Learn Chess Tactics**: Improve your skills with curated lessons and tutorials.
- **Customizable Chess Boards**: Personalize the look and feel of your chessboard and pieces.
- **Performance Analysis**: Track your progress and identify areas for improvement.
- **Quick Play & Continue**: Start an AI match with your remembered settings or resume an automatically saved unfinished game. Local clocks pause while you are away.
- **Daily Practice**: 71 offline daily puzzles and a 77-position training library, including mate-in-two combinations, hints, and explanations. Daily completion and streaks appear on the home screen.
- **Refined Play & Learning**: A focused home screen, grouped settings, named AI levels, labeled clocks, optional board coordinates, and position-specific puzzle explanations in all seven languages.
- **Practice Progress & Safer History**: Puzzle/opening completion totals, confirmation before deleting saved games, and a board-flip control during replay.

## Installation

To run the project locally, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/Apps-Bay-Limited/chess-room.git
   ```
2. Navigate to the project directory:
   ```bash
   cd chess-room
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app on an emulator or a connected device:
   ```bash
   flutter run
   ```

## Requirements

- **Flutter / Dart**: Flutter 3.38.1 or later and Dart 3.10 or later are required. The current release is verified with Flutter 3.47.7 and Dart 3.13.5. Use an SDK compatible with the committed dependency lockfile.
- **iOS**: Version 15.0 or later.


## Environment Setup

1. Install Flutter by following the [official documentation](https://flutter.dev/docs/get-started/install).
2. Set up an emulator or connect a physical device.

## Release configuration and builds

iOS dependencies use Swift Package Manager, including `google_mobile_ads` 9.2.0.
Open `ios/Runner.xcworkspace` after running `flutter pub get`; Xcode resolves
the generated Flutter plugin package. CocoaPods, `pod install`, and a Podfile
are no longer required. Keep SwiftPM enabled in `pubspec.yaml` and commit
updates to the app's Swift package resolution lockfiles.

Version 1.5.0+14 audit results and remaining release checks live in
`store/RELEASE_VALIDATION_1.5.md`. The older 1.4.0 copy, screenshots and native
evidence in `store/README.md` and `store/RELEASE_VALIDATION.md` are retained as
historical records. Refresh store screenshots for the current interface before
uploading a 1.5 release.

Run the native save and restore phases on the same device to check that real
preferences survive a process restart. The harness uses its own saved-game key,
does not clear user game history, and never initiates a purchase:

```bash
flutter drive --profile --keep-app-running --driver=test_driver/release_smoke.dart --target=integration_test/release_smoke_test.dart --dart-define=SMOKE_PHASE=save --dart-define-from-file=lib/config/ads_release.json -d DEVICE_ID
flutter drive --profile --keep-app-running --driver=test_driver/release_smoke.dart --target=integration_test/release_smoke_test.dart --dart-define=SMOKE_PHASE=restore --dart-define-from-file=lib/config/ads_release.json -d DEVICE_ID
```

Use debug mode for emulators/simulators. StoreKit purchase restoration requires
the owner's sandbox test account and is separate from the unattended smoke test.
For the interface regression pass, use `integration_test/ux_polish_test.dart`
as the target with the same save/restore phases. It also checks native promotion,
undo/redo, Settings, and Training. Set `CAPTURE_STORE=true` and
`CHESS_SCREENSHOT_DIR` to capture the updated screens in a separate output folder.
Keep `--keep-app-running` on every `flutter drive` invocation: the default
cleanup uninstalls the app and deletes its local data. Use a dedicated test
device, terminate only Chess Room between the save and restore phases, and
restore the normal `lib/main.dart` entry point after testing.

Release builds must be produced with `tool/release_build.sh`. The script validates signing and AdMob configuration, rejects Google test IDs, and injects the Dart ad-unit values with `--dart-define-from-file`. Do not use a bare `flutter build` for store artifacts.

Required ignored files:

- `lib/config/ads_release.json`: copy `lib/config/ads_release.json.example` and supply production values for `BANNER_ID_ANDROID`, `OPEN_AD_ID_ANDROID`, `REWARD_AD_ID_ANDROID`, `REWARD_INTERSTITIAL_AD_ID_ANDROID`, `BANNER_ID_IOS`, `OPEN_AD_ID_IOS`, `REWARD_AD_ID_IOS`, and `REWARD_INTERSTITIAL_AD_ID_IOS`.
- `android/local.properties`: set the production `AdMobAppId` in addition to the Flutter SDK path.
- `ios/Secret.xcconfig`: set the production `GADApplicationIdentifier`; `ios/Flutter/Release.xcconfig` includes this file.
- `android/key.properties` and its referenced production keystore. Restore the keystore from `/Users/banghuazhao/Development/secret/keystore/` if the configured file is missing.

Before releasing ads, publish a European regulations message for both app IDs in AdMob Privacy & messaging. The app uses Google's UMP flow and waits for consent before initializing ads. Keep the public privacy policy aligned with the data disclosed by the Google Mobile Ads SDK.

Build one platform or both:

```bash
./tool/release_build.sh android
./tool/release_build.sh ios
./tool/release_build.sh all
```

For the mandatory profile launch smoke test, use the same configuration file:

```bash
flutter run --profile --dart-define-from-file=lib/config/ads_release.json -d DEVICE_ID
```

Do not run another Flutter command between the iOS release script and any follow-up Xcode archive/export action; doing so can regenerate `Generated.xcconfig` without the injected defines.

## Folder Structure

```plaintext
lib/
├── models/           # Data models
├── views/            # App screens (UI)
├── logic/            # Business logic 
├── utils/            # Utility functions and 
pubspec.yaml          # Project dependencies
```

## Contributing

Contributions are welcome! Please follow these steps to contribute:

1. Fork the repository.
2. Create a new branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Make your changes and commit them:
   ```bash
   git commit -m "Add your feature description"
   ```
4. Push your branch:
   ```bash
   git push origin feature/your-feature-name
   ```
5. Open a pull request and describe your changes.

## License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

---

Happy coding! 👑♟️
