# Changelog

## 1.6.0+15

### Added
- A macOS build that ships from the same App Store record as iOS, sharing the
  bundle identifier `com.appsbay.chessRoom1`.
- Premium, the renamed Remove Ads purchase, now resolves on both iOS and macOS;
  a purchase on either platform restores on the other with no new product.
- Premium unlocks every board theme and piece set, unlimited library puzzles and
  opening courses, unlimited game review, and the complete game archive.
- A new Appearance section in Settings with board and piece-set pickers, a live
  board preview, and locks on the premium entries.
- An upgrade sheet reachable from every gated surface, localized in all seven
  supported locales.
- Free allowances that reset daily: three library puzzles and three game
  reviews per day, plus the first opening course and the ten most recent games.

### Changed
- `tool/release_build.sh` accepts a `macos` target that archives and exports a
  signed Mac App Store installer.
- Mac icons are generated from `flutter_launcher_icons-macos.yaml`, keeping the
  generator away from the iOS asset catalogue.

### Notes
- The stored entitlement key is unchanged, so existing Remove Ads buyers keep
  their purchase and gain the new premium features.
- Games beyond the free tier's ten are hidden rather than deleted, so upgrading
  restores the whole archive.
- The Mac build serves no ads: the Google Mobile Ads SDK has no macOS
  implementation, so ad surfaces, consent, and tracking requests are skipped.

## 1.5.0+14

### Added
- Training progress totals for puzzles and openings, with refresh and retry support.
- Confirmation before deleting saved games and a board flip control in replay.
- Optional board coordinates during games and localized board-square accessibility labels.
- Position-specific puzzle explanations with example moves, supporting pieces, and verified tactical details.
- A visible sound setting using the existing saved preference.

### Changed
- Updated Google Mobile Ads to 9.2.0 and migrated iOS dependencies to Swift Package Manager, removing CocoaPods integration.
- Refined Home with one primary play action, compact navigation, and a smaller brand header.
- Unified charcoal surfaces, brass accents, typography, cards, and navigation across play and practice.
- Kept page text readable on bright app themes and clarified source-piece puzzle hints.
- Grouped Settings, clarified legal-move and move-suggestion controls, and named AI difficulty choices.
- Labeled clocks and emphasized the active side; bounded game boards and reading widths on larger screens.
- Added recoverable practice-progress and saved-game storage errors without changing saved-data formats.
- Updated all seven supported locales for the new interface and teaching text.

### Fixed
- Promotion choices fit narrow dialogs, and queued taps cannot promote twice or close the match.
- Required promotion cannot be dismissed with system Back.
- Damaged daily-progress preferences no longer interrupt Home startup or resume.
- Concurrent history saves and opening completions preserve every result.
- Failed opening and puzzle-library completion saves can be retried without replaying a solution.
- PGN import keeps its controller alive through dismissal and ignores queued confirmations.
- Large-text clock settings remain readable in longer translations.

## 1.4.0+13

### Added
- Quick Play using remembered AI difficulty, side, and time settings.
- Automatic unfinished-game saves and a Continue Game action, including move history, undo/redo, promotion, and clocks.
- Daily puzzle completion and streak progress on the home screen.
- Expanded offline practice to 71 daily puzzles and 77 library puzzles, with eight themes, three difficulty levels, hints, explanations, and mate-in-two combinations.

### Changed
- App-open ads now respect active practice sessions, a minimum background interval, and a cooldown.
- Rating requests follow completed activities and wait for a safe return home, with persistent eligibility and request limits.
- In-game Restart asks for confirmation and pauses the clock while the choice is open.
- Local game clocks pause while the app is backgrounded or the match is closed.
- Starting another match asks before replacing an unfinished game.
- Completed daily puzzles lead directly to further practice, and library sessions start with unsolved positions.
- Added translations for the new home and practice flows in all seven supported locales.

### Release preparation
- Added a native integration smoke harness using isolated match/history storage.
- Added native promotion/undo/redo checks and a non-purchasing StoreKit product probe.
- Prepared localized store metadata and screenshot-order experiment plans.
- Updated Android build tooling for Flutter 3.47 and aligned iOS deployment targets to iOS 15.
- Unified iOS plugin installation through CocoaPods to avoid duplicate WebView classes.

## 1.3.0+12

### Fixed
- Removed the unnecessary app-level iOS privacy manifest; privacy declarations remain supplied by the SDKs that perform the corresponding API access and data collection.
- Extended release validation to audit every privacy manifest embedded in the finished IPA.

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
