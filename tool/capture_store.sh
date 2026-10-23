#!/usr/bin/env bash
set -euo pipefail

capture_repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$capture_repo_root"
capture_family="${1:?Usage: capture_store.sh iphone|ipad|android DEVICE_ID}"
capture_device="${2:?Pass a simulator or emulator device ID}"
export CHESS_SCREENSHOT_DIR="$capture_repo_root/store/screenshots/$capture_family"

case "$capture_family" in
  iphone|ipad|android)
    ;;
  *)
    echo "Choose iphone, ipad, or android." >&2
    exit 1
    ;;
esac

# Release builds omit development plugins from generated registrants. Refresh
# them before running the integration-test entry point again.
flutter pub get

for capture_phase in save restore; do
  # Keep the app installed: flutter drive's default cleanup deletes local data.
  flutter drive --debug --no-pub --keep-app-running \
    --driver=test_driver/release_smoke.dart \
    --target=integration_test/release_smoke_test.dart \
    --dart-define="SMOKE_PHASE=$capture_phase" \
    --dart-define=CAPTURE_STORE=true -d "$capture_device"
  if test "$capture_phase" = save; then
    if test "$capture_family" = android; then
      "${ANDROID_HOME:-$HOME/Library/Android/sdk}/platform-tools/adb" \
        -s "$capture_device" shell am force-stop com.appsbay.chess_room
    else
      xcrun simctl terminate "$capture_device" com.appsbay.chessRoom1 || true
    fi
  fi
done
