# Chess Room 1.5.0+14 — release audit

Recorded 23 October 2026 with Flutter 3.47.7 / Dart 3.13.5. This records local verification, not store submission.

## Fixes verified

- Home survives incorrectly typed daily-progress preferences and retains its last known progress after a failed refresh.
- Required promotion consumes system Back. Every promotion choice commits once despite queued taps.
- New-game, restart, import and delete confirmations ignore stale callbacks after dismissal.
- History save/delete and opening-completion mutations serialize across store instances without changing storage keys or formats.
- Failed opening/library completion saves can retry without replaying the solution. Library retries preserve the current position and reject input while storage is busy.
- Successful practice saves release their UI independently of rating bookkeeping. Regression fixtures deliberately block that bookkeeping.
- Page text meets 4.5:1 contrast across every selectable theme; board palettes retain their original colors.
- All seven locales use a source-piece hint label consistent with puzzle behavior.

## Automated checks

- **All 348 unit/widget tests passed** on the final source: `/private/tmp/chess_room_release_audit_commit_full.log`.
- Final static analysis: `/private/tmp/chess_room_release_audit_commit_analyze.log`; **0 errors, 0 warnings**, with existing/generated informational style findings.
- The corrected review-queue fixture also passes in `/private/tmp/chess_room_release_audit_retry_final.log`; its assertions remain part of the complete passing suite.
- `git diff --check` passes. Release/capture shell scripts pass syntax checks.
- Store validator passes 43 metadata fields and 15 historical screenshots. The checked-in manifest and images remain labeled **1.4.0+13**; this does not validate them as current 1.5 screenshots.

## Native check and limits

The iPhone 17e simulator (iOS 26.5) compiled the updated native smoke target successfully in 82.3 seconds. Its subsequent app launch stalled in CoreSimulator; the run was canceled and this dedicated simulator shut down. A fresh native runtime pass is therefore **not established by this audit**. Installed app data was retained with `--keep-app-running`; no device erase or uninstall was performed. The dedicated simulator may retain the test entry point and should be restored to `lib/main.dart` after a successful rerun.

Earlier 1.5 UI smoke passes and screenshots from before the final audit fixes remain local at `/private/tmp/chess_room_polish_native_verified.log` and `build/ux-polish/screenshots/`. They cover real moves, saved-game restoration, promotion/undo/redo, Settings and Training, but do not replace native verification of the final fixes. Historical 1.4 physical-device, store-query and signed-artifact evidence remains in `RELEASE_VALIDATION.md`.

## Before publishing

- Rerun retained-app native save/restore and normal-entry launch on the final build. Include actual OS background/foreground during AI work and pending promotion.
- Check purchase/restore and entitlement persistence with the owner's sandbox account, and live consent/ad presentation with approved test-device setup.
- Refresh store screenshots for the updated UI and build/sign current production artifacts using `tool/release_build.sh`. Historical 1.4 artifacts and screenshots do not certify 1.5.
- No purchase, store upload, release submission or screenshot experiment was performed in this audit.
