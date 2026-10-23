# Chess Room store release assets

This directory holds the proposed store copy and screenshot experiment plan for version 1.4.0. Uploading the copy, submitting a release, and starting an experiment require access to the store accounts. This document does not record a submission or an experiment result. Native validation and capture outcomes belong in `RELEASE_VALIDATION.md`.

The app is now preparing 1.5.0+14. The checked-in screenshot set and its manifest remain the historical 1.4 captures; they do not show the current interface. See `RELEASE_VALIDATION_1.5.md` for the current audit and refresh the captures before using them for 1.5 store submission.

## Metadata

Plain-text fields are under `metadata/<locale>/`. The prepared locales are `en-US`, `ar-SA`, `es-ES`, `fr-FR`, `ja`, `zh-Hans`, and `zh-Hant`.

| File | Intended field | Maximum characters |
| --- | --- | ---: |
| `title.txt` | App Store name | 30 |
| `subtitle.txt` | App Store subtitle | 30 |
| `promotional_text.txt` | App Store promotional text | 170 |
| `description.txt` | App description | 4,000 |
| `keywords.txt` | App Store keywords, comma separated | 100 |
| `release_notes.txt` | Version release notes | 4,000 |
| `en-US/google_play_short_description.txt` | Google Play short description | 80 |

The Google Play short-description path above is relative to `metadata/`; the other files exist in each locale directory. Count the field content without the final file newline, and preserve Unicode text when uploading. The English title, `Chess Room: Play & Learn Chess`, uses all 30 characters.

The copy describes 71 positions in the daily rotation and 77 exercises in the puzzle library. The library includes daily positions; these are overlapping collections. Do not advertise 148 unique puzzles. Other supported claims include offline AI games, two players sharing a device, automatic unfinished-game saving, Continue Game, Quick Play, hints, explanations, and combinations including mate in two.

## Native screenshots

`integration_test/release_smoke_test.dart` defines captures from the running native app. Debug-only native capture handlers produce opaque PNGs at each named screen state. The host driver writes those bytes unchanged to `CHESS_SCREENSHOT_DIR`, or to `build/release-smoke/screenshots` when the variable is absent. Keep `--keep-app-running` on every `flutter drive` command because its default cleanup uninstalls the app and deletes local data. Use a dedicated test device.

After `flutter pub get`, run `./tool/capture_store.sh iphone SIMULATOR_ID`, `./tool/capture_store.sh ipad SIMULATOR_ID`, or `./tool/capture_store.sh android EMULATOR_ID`. Configure Android's test display to a store-compatible portrait size such as 1080×1920 before capture and restore its original display settings afterward. The script runs save and restore launches with an app-only termination between them. The final selected folder combines the save-phase game image with the restore-phase home, recovery, and puzzle images; repeated names are deliberately replaced. Run `python3 tool/validate_store_assets.py --require-screenshots` afterward.

| Capture name | App state it is intended to show |
| --- | --- |
| `01-quick-play.png` | Home with the Quick Play action; Continue is also visible when a saved game exists |
| `02-play-offline.png` | An offline AI game after both sides have moved |
| `03-continue-game.png` | The restored unfinished game after a separate app launch |
| `04-daily-practice.png` | A daily puzzle before its solution is played |
| `05-learn-from-solutions.png` | The solved puzzle and its explanation |

These names describe intended captures, not proof that files exist or passed review. Keep the original native captures and record the device, locale, build, phase, dimensions, and capture result in `RELEASE_VALIDATION.md`. Inspect every selected image for readable text, safe areas, and the correct screen state before producing store-size exports. Screenshots must show the app's actual interface and available features.

The smoke test uses an isolated unfinished-game key and isolated puzzle progress. Its programmatic lifecycle events exercise application callbacks; they do not establish that the operating system actually backgrounded or terminated the app. Separate save and restore launches are the intended persistence check. StoreKit entitlement and purchase restoration need their own account-backed validation.

## Screenshot-order experiment

The question is which opening value proposition encourages more visitors to install: a daily learning habit or an immediate game. Use the same five approved captures, captions, locale, dimensions, icon, and listing text in both variants; change only their order.

| Position | Variant A: daily practice first | Variant B: Quick Play first |
| --- | --- | --- |
| 1 | `04-daily-practice.png` | `01-quick-play.png` |
| 2 | `05-learn-from-solutions.png` | `02-play-offline.png` |
| 3 | `03-continue-game.png` | `03-continue-game.png` |
| 4 | `02-play-offline.png` | `04-daily-practice.png` |
| 5 | `01-quick-play.png` | `05-learn-from-solutions.png` |

Variant A tests whether learning and returning daily are the stronger entry point. Variant B tests whether starting an offline match is the stronger entry point. Both are hypotheses.

When console access is available, configure a randomized comparison in one locale and device group with an even allocation where supported. Use store-page conversion to first-time installs as the primary outcome. Define the minimum detectable improvement and stopping rule from the available traffic before starting; follow the console's confidence and sample-size guidance. Avoid changing acquisition campaigns or the app release during the comparison. If in-app attribution supports it, also compare first-session activity completion and Day 1/Day 7 retention; install conversion alone does not establish better retention.

Apple supports testing alternate screenshot presentations with [product page optimization](https://developer.apple.com/app-store/product-page-optimization/). Google Play supports graphics and copy comparisons through [store listing experiments](https://support.google.com/googleplay/android-developer/answer/12053285?hl=en). Check the account's current configuration before setting up either experiment. This plan has not been uploaded or started.
