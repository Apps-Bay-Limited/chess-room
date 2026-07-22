#!/usr/bin/env bash
set -euo pipefail

release_repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$release_repo_root"

release_target="${1:-all}"
ads_config_file="lib/config/ads_release.json"
android_properties_file="android/local.properties"
android_signing_file="android/key.properties"
ios_secret_file="ios/Secret.xcconfig"
ios_privacy_manifest="ios/Runner/PrivacyInfo.xcprivacy"
test_admob_publisher="3940256099942544"

fail() {
  echo "Release validation failed: $1" >&2
  exit 1
}

command -v flutter >/dev/null || fail "flutter is not available"
command -v jq >/dev/null || fail "jq is required to validate release configuration"

test -f "$ads_config_file" || fail "$ads_config_file is missing; restore it from the release secrets backup"
jq -e . "$ads_config_file" >/dev/null || fail "$ads_config_file is not valid JSON"

required_ad_keys=(
  BANNER_ID_ANDROID
  OPEN_AD_ID_ANDROID
  REWARD_AD_ID_ANDROID
  REWARD_INTERSTITIAL_AD_ID_ANDROID
  BANNER_ID_IOS
  OPEN_AD_ID_IOS
  REWARD_AD_ID_IOS
  REWARD_INTERSTITIAL_AD_ID_IOS
)

for ad_key in "${required_ad_keys[@]}"; do
  ad_value="$(jq -r --arg key "$ad_key" '.[$key] // empty' "$ads_config_file")"
  test -n "$ad_value" || fail "$ad_key is missing or empty in $ads_config_file"
  [[ "$ad_value" =~ ^ca-app-pub-[0-9]+/[0-9]+$ ]] || fail "$ad_key is not a valid AdMob ad-unit ID"
  [[ "$ad_value" != *"$test_admob_publisher"* ]] || fail "$ad_key is still a Google test ID"
done

validate_android() {
  test -f "$android_properties_file" || fail "$android_properties_file is missing"
  grep -Eq '^AdMobAppId[[:space:]]*=[[:space:]]*ca-app-pub-[0-9]+~[0-9]+[[:space:]]*$' "$android_properties_file" ||
    fail "AdMobAppId is missing or invalid in $android_properties_file"
  grep -Eq "^AdMobAppId[[:space:]]*=[[:space:]]*ca-app-pub-$test_admob_publisher~" "$android_properties_file" &&
    fail "AdMobAppId in $android_properties_file is still a Google test ID"

  test -f "$android_signing_file" || fail "$android_signing_file is missing"
  signing_store_path="$(sed -n 's/^storeFile[[:space:]]*=[[:space:]]*//p' "$android_signing_file" | tail -1)"
  test -n "$signing_store_path" || fail "storeFile is missing from $android_signing_file"
  if ! test -f "android/$signing_store_path" && ! test -f "$signing_store_path"; then
    fail "the production Android keystore referenced by $android_signing_file is missing"
  fi
  return 0
}

validate_ios() {
  test -f "$ios_secret_file" || fail "$ios_secret_file is missing"
  grep -Eq '^GADApplicationIdentifier[[:space:]]*=[[:space:]]*ca-app-pub-[0-9]+~[0-9]+[[:space:]]*$' "$ios_secret_file" ||
    fail "GADApplicationIdentifier is missing or invalid in $ios_secret_file"
  grep -Eq "^GADApplicationIdentifier[[:space:]]*=[[:space:]]*ca-app-pub-$test_admob_publisher~" "$ios_secret_file" &&
    fail "GADApplicationIdentifier in $ios_secret_file is still a Google test ID"

  test -f "$ios_privacy_manifest" || fail "$ios_privacy_manifest is missing"
  plutil -lint "$ios_privacy_manifest" >/dev/null || fail "$ios_privacy_manifest is not a valid plist"
  privacy_tracking="$(plutil -extract NSPrivacyTracking raw -o - "$ios_privacy_manifest" 2>/dev/null || true)"
  privacy_domains="$(plutil -extract NSPrivacyTrackingDomains json -o - "$ios_privacy_manifest" 2>/dev/null || true)"
  if test -n "$privacy_domains"; then
    privacy_domain_count="$(printf '%s' "$privacy_domains" | jq 'length')"
    test "$privacy_domain_count" -gt 0 ||
      fail "NSPrivacyTrackingDomains must be omitted instead of declared as an empty array"
    test "$privacy_tracking" = "true" ||
      fail "NSPrivacyTracking must be true when NSPrivacyTrackingDomains is present"
  fi
  return 0
}

build_android() {
  validate_android
  echo "Building validated Android release bundle..."
  flutter build appbundle --release --dart-define-from-file="$ads_config_file"
}

build_ios() {
  validate_ios
  echo "Building validated iOS release archive..."
  flutter build ipa --release --dart-define-from-file="$ads_config_file"
}

case "$release_target" in
  android)
    build_android
    ;;
  ios)
    build_ios
    ;;
  all)
    build_android
    build_ios
    ;;
  *)
    fail "target must be android, ios, or all"
    ;;
esac
