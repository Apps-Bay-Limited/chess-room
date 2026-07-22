# Changelog

## 1.3.0+11

### Fixed
- Removed an empty tracking-domains declaration from the iOS privacy manifest to satisfy App Store validation.
- Added release validation for the relationship between `NSPrivacyTracking` and `NSPrivacyTrackingDomains`.

## 1.3.0+10

### Added
- Full game history with PGN import, export, and move-by-move replay.
- Expanded game review covering every recorded move.
- A Training hub with themed chess puzzles and an opening trainer.
- A localized How to Play Chess guide covering rules, special moves, draws, and beginner tips.
- French, Spanish, Japanese, and Arabic localization, including right-to-left Arabic layout.
- A permanent Remove Ads purchase with restore support on iOS.
- Consent-first ad initialization with a privacy choices entry point.

### Changed
- Reorganized the main menu around play, daily puzzles, training, and settings.
- Moved Game History and More Apps into Settings.
- Restricted ads to general-audience content and tightened iOS privacy declarations.

## 1.2.0+9

### Added
- Daily Puzzle with streak tracking.
- Biggest Mistake Review after games.
- Shareable result cards.
- Optional in-game tips powered by a stronger chess search than the selected opponent difficulty.
- More time-limit choices in a compact one-row picker.

### Changed
- Daily Puzzle and review actions now match the game menu style.
- Daily Puzzle navigation styling now matches the app accent color.

## 1.1.0+7

### Fixed
- Chessboard was completely unresponsive to taps — pieces could not be selected at all.
- Castling was silently non-functional in every game due to an inverted path-check condition.
- Redo crashed the app on any non-promotion move (`LateInitializationError` on an uninitialized promotion field).
- Board continued to accept taps/moves after the game had already ended.
- `GameInfoAndControls` leaked a `ScrollController` on every rebuild while a game clock was running.
- AI move calculation had no error handling, risking an indefinite hang if the calculation failed.
- Chess clock now uses actual elapsed wall-clock time instead of a fixed tick, so it no longer desyncs after the app is backgrounded.
- App-open ad no longer shows over an active game.

### Changed
- Unified design system: consistent spacing, colors, and button styling across all screens.
- Added haptic feedback for piece selection, moves, game end, toggles, and pickers.
- Added press-state animations to buttons, respecting the system's Reduce Motion setting.
- Banner ads now reserve fixed layout space so they never overlap content or cause a layout jump.
- Localized 2-player game-status text (was hardcoded English).

### Removed
- Web and Windows platform support (this app targets iOS and Android only).
- Dead code: `RoundedButton`, `MainMenuButtons`, `RestartExitButtons`, `RoundedAlertButton`.

## 1.0.6+6 and earlier
See git history.
