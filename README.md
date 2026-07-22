# Chess Room - Chess Puzzles & Games

Welcome to the **Chess Room**! This repository contains the source code for the **Chess Room - Chess Puzzles & Games** app, available on the [App Store](https://apps.apple.com/us/app/chess-room-chess-puzzles-games/id1642306743). The app is developed using **Flutter**.

## Features

- **Interactive Chess Puzzles**: Solve engaging chess puzzles of varying difficulty.
- **Play Chess Games**: Compete against AI opponents or other players.
- **Learn Chess Tactics**: Improve your skills with curated lessons and tutorials.
- **Customizable Chess Boards**: Personalize the look and feel of your chessboard and pieces.
- **Performance Analysis**: Track your progress and identify areas for improvement.

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

- **Flutter**: Version 3.0.0 or later
- **Dart**: Version 2.17.0 or later


## Environment Setup

1. Install Flutter by following the [official documentation](https://flutter.dev/docs/get-started/install).
2. Set up an emulator or connect a physical device.

## Release configuration and builds

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
