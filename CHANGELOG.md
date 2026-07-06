# Changelog

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
