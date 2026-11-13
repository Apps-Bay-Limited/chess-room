# Play premium product

The Google Play counterpart of the App Store's Premium purchase.

| | |
| --- | --- |
| Product ID | `com.appsbay.chess_room.remove_ads` |
| Purchase option | `buy`, legacy-compatible so `queryProductDetails` and `buyNonConsumable` see it |
| Type | one permanent purchase, never consumed |
| Base price | USD 2.99, matching the App Store listing |

Play only accepts lowercase letters, digits, underscores and periods in a
product ID, so Android cannot reuse `com.appsbay.chessRoom1.remove_ads`. The
app resolves the right identifier per platform in `premiumProductId`.

The two stores bill and restore on their own. A player who bought on Apple does
not own the Play product, and the paywall says so: `premiumBenefits` shows the
iPhone/iPad/Mac line on Apple and the Google Play account line on Android.

## Files

- `product.json` — identifiers, the purchase-option contract, and the approved
  USD base price. Nothing priced is sent to Play unless `basePrice.approval` is
  `approved`.
- `listings/*.json` — title (≤55 characters) and description (≤200) in the
  seven languages the app itself ships, plus `zh-TW`.

## Managing it

```bash
python3 tool/play_premium_product.py --validate   # local only, no credentials
python3 tool/play_premium_product.py --discover   # read-only inventory
python3 tool/play_premium_product.py --quote      # read-only regional prices
python3 tool/play_premium_product.py --create     # upsert; stays DRAFT
python3 tool/play_premium_product.py --activate   # makes it buyable
```

Play treats a purchase option's state as output-only on an upsert, so `--create`
can never make the product buyable. That only happens on `--activate`, which is
the one step worth pausing over.

## State

Created on 2026-11-13 with eight listings and 174 regional prices converted
from USD 2.99 at regions version `2026/01`. The `buy` option was activated on
2026-11-14 and is **ACTIVE**.

Devices only see the product once a build containing Play Billing support is
on a Play track; until then `queryProductDetails` reports it as not found.

Google's legacy `inappproducts` API now answers HTTP 403 `Please migrate to the
new publishing API.` Use `monetization.onetimeproducts`, which is what the tool
calls.
