import 'native_promotion_test.dart' as promotion;
import 'release_smoke_test.dart' as smoke;
import 'store_availability_test.dart' as store;

/// Runs the independent native fixtures sequentially in one installed build.
/// SMOKE_PHASE defaults to save; cross-launch restoration is a separate run.
/// VERIFY_RESTORE remains false unless explicitly enabled for a sandbox account.
void main() {
  smoke.main();
  promotion.main();
  store.main();
}
