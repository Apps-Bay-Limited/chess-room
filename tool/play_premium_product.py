#!/usr/bin/env python3
"""Manage the Google Play one-time product that sells Chess Room Premium.

The product is the Play counterpart of the App Store's
`com.appsbay.chessRoom1.remove_ads`. Play only accepts lowercase letters,
digits, underscores and periods in a product ID, so Android carries its own
identifier and the two stores bill and restore separately.

Actions, from least to most consequential:

    python3 tool/play_premium_product.py --validate    # local only, no network
    python3 tool/play_premium_product.py --discover    # read-only inventory
    python3 tool/play_premium_product.py --quote       # read-only price quote
    python3 tool/play_premium_product.py --create      # upsert as a draft
    python3 tool/play_premium_product.py --activate    # makes it BUYABLE

`--create` leaves the purchase option in its default DRAFT state: Play treats
the option's state as output-only on an upsert, so nothing becomes buyable
until `--activate` is run. Keep that split; it is the only safeguard between
editing the catalog and putting a price in front of players.

Credentials come from the service-account key the other Play scripts use.
"""

import argparse
import glob
import json
import ssl
import sys
import urllib.error
import urllib.parse
import urllib.request
from decimal import Decimal, InvalidOperation
from pathlib import Path

import certifi
from google.auth.transport.requests import Request
from google.oauth2 import service_account

ROOT = Path(__file__).resolve().parent.parent
DIRECTORY = ROOT / 'store/google_play/premium'
SA_GLOB = '/Users/banghuazhao/Development/secret/GooglePlay_API/*.json'
SCOPE = 'https://www.googleapis.com/auth/androidpublisher'
API = 'https://androidpublisher.googleapis.com/androidpublisher/v3/applications'
SSL_CTX = ssl.create_default_context(cafile=certifi.where())


class ProductError(Exception):
    pass


def token():
    keys = [p for p in glob.glob(SA_GLOB) if not p.endswith('key_info.json')]
    if not keys:
        raise ProductError('No Google Play service-account key found')
    credentials = service_account.Credentials.from_service_account_file(
        keys[0], scopes=[SCOPE])
    credentials.refresh(Request())
    return credentials.token


def api(url, method='GET', body=None):
    data = json.dumps(body).encode() if body is not None else None
    headers = {'Authorization': 'Bearer ' + token()}
    if data is not None:
        headers['Content-Type'] = 'application/json'
    request = urllib.request.Request(url, data=data, headers=headers, method=method)
    try:
        with urllib.request.urlopen(request, timeout=120, context=SSL_CTX) as response:
            payload = response.read()
    except urllib.error.HTTPError as error:
        detail = error.read().decode(errors='replace')
        raise ProductError(f'{method} {url.split("?")[0]} failed: HTTP {error.code}\n{detail}') from None
    return json.loads(payload) if payload else {}


def load():
    """Read and check the local product definition and its listings."""
    try:
        product = json.loads((DIRECTORY / 'product.json').read_text())
    except (OSError, ValueError):
        raise ProductError(f'Missing or invalid {DIRECTORY / "product.json"}') from None

    identity = product.get('productId', '')
    if not identity or len(identity) > 100 or not all(
            character.islower() or character.isdigit() or character in '._'
            for character in identity) or not (identity[0].isdigit() or identity[0].islower()):
        raise ProductError('Play product IDs are lowercase letters, digits, underscores and periods')

    price = product.get('basePrice', {})
    if price.get('approval') != 'approved' or price.get('currency') != 'USD':
        raise ProductError('No approved USD base price; nothing priced may be sent to Play')
    try:
        amount = Decimal(str(price.get('amount')))
    except InvalidOperation:
        raise ProductError('The approved base price must be an exact USD amount') from None
    if not amount.is_finite() or amount <= 0 or amount != amount.quantize(Decimal('0.01')):
        raise ProductError('The approved base price must be an exact positive USD amount')

    listings = []
    for path in sorted((DIRECTORY / 'listings').glob('*.json')):
        try:
            listing = json.loads(path.read_text())
        except (OSError, ValueError):
            raise ProductError(f'Invalid listing: {path.name}') from None
        if (listing.get('languageCode') != path.stem or
                not 1 <= len(listing.get('title', '')) <= 55 or
                not 1 <= len(listing.get('description', '')) <= 200):
            raise ProductError(f'{path.name} needs a title <=55 and description <=200 characters')
        listings.append(listing)
    if not any(listing['languageCode'] == 'en-US' for listing in listings):
        raise ProductError('Play requires an en-US listing')

    return product, listings, amount


def quote(product, amount):
    """Read-only: ask Play what the approved USD price is in every region."""
    units, cents = divmod(int(amount * 100), 100)
    body = {'price': {'currencyCode': 'USD', 'units': str(units),
                      'nanos': cents * 10_000_000}}
    url = f'{API}/{product["packageName"]}/pricing:convertRegionPrices'
    conversion = api(url, method='POST', body=body)
    regions = conversion.get('convertedRegionPrices', {})
    version = (conversion.get('regionVersion') or {}).get('version')
    if not regions or not version:
        raise ProductError('Play returned no regional prices to price the product with')

    us = regions.get('US', {}).get('price', {})
    converted = Decimal(str(us.get('units', 0))) + Decimal(str(us.get('nanos', 0))) / Decimal(10 ** 9)
    if us.get('currencyCode') != 'USD' or converted != amount:
        raise ProductError('Play did not quote the approved price in the US region')
    return regions, version


def payload(product, listings, regions):
    option = {
        'purchaseOptionId': product['purchaseOptionId'],
        'buyOption': {
            'legacyCompatible': product['legacyCompatible'],
            'multiQuantityEnabled': product['multiQuantityEnabled'],
        },
        'regionalPricingAndAvailabilityConfigs': [
            {'regionCode': region, 'price': item['price'], 'availability': 'AVAILABLE'}
            for region, item in sorted(regions.items())
        ],
    }
    # newRegionsConfig is left out on purpose: it would promise availability in
    # regions Play has not launched yet and that this quote never priced.
    return {
        'packageName': product['packageName'],
        'productId': product['productId'],
        'listings': listings,
        'purchaseOptions': [option],
    }


def discover(product):
    url = f'{API}/{product["packageName"]}/oneTimeProducts'
    return api(url).get('oneTimeProducts', [])


def create(product, listings, amount):
    existing = {item.get('productId') for item in discover(product)}
    regions, version = quote(product, amount)
    body = payload(product, listings, regions)
    query = urllib.parse.urlencode({
        'allowMissing': 'true',
        'regionsVersion.version': version,
        'updateMask': 'listings,purchaseOptions',
    })
    url = (f'{API}/{product["packageName"]}/onetimeproducts/'
           f'{product["productId"]}?{query}')
    verb = 'Updated' if product['productId'] in existing else 'Created'
    result = api(url, method='PATCH', body=body)
    states = [option.get('state') for option in result.get('purchaseOptions', [])]
    print(f'{verb} {result.get("productId")} with {len(result.get("listings", []))} listings '
          f'and {len(body["purchaseOptions"][0]["regionalPricingAndAvailabilityConfigs"])} '
          f'regional prices (regions version {version})')
    print('Purchase option state: ' + ', '.join(state or 'UNKNOWN' for state in states))
    return result


def activate(product):
    url = (f'{API}/{product["packageName"]}/oneTimeProducts/'
           f'{product["productId"]}/purchaseOptions:batchUpdateStates')
    body = {'requests': [{
        'packageName': product['packageName'],
        'productId': product['productId'],
        'activatePurchaseOption': {'purchaseOptionId': product['purchaseOptionId']},
        'latencyTolerance': 'PRODUCT_UPDATE_LATENCY_TOLERANCE_LATENCY_SENSITIVE',
    }]}
    result = api(url, method='POST', body=body)
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return result


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    action = parser.add_mutually_exclusive_group()
    action.add_argument('--validate', action='store_true',
                        help='Local checks only (default); loads no credentials')
    action.add_argument('--discover', action='store_true',
                        help='Read-only: list the app\'s existing one-time products')
    action.add_argument('--quote', action='store_true',
                        help='Read-only: quote the approved USD price in every region')
    action.add_argument('--create', action='store_true',
                        help='Upsert the product and its prices; leaves it DRAFT')
    action.add_argument('--activate', action='store_true',
                        help='Activate the purchase option, making it buyable')
    args = parser.parse_args(argv)

    try:
        product, listings, amount = load()
        locales = ', '.join(listing['languageCode'] for listing in listings)
        print(f'{product["productId"]} at USD {amount}, listings: {locales}')

        if args.discover:
            print(json.dumps(
                [{'productId': item.get('productId'),
                  'purchaseOptions': [{'id': option.get('purchaseOptionId'),
                                       'state': option.get('state')}
                                      for option in item.get('purchaseOptions', [])]}
                 for item in discover(product)], indent=2))
        elif args.quote:
            regions, version = quote(product, amount)
            sample = {region: regions[region]['price'] for region in sorted(regions)[:5]}
            print(f'{len(regions)} regional prices at regions version {version}')
            print(json.dumps(sample, indent=2))
        elif args.create:
            create(product, listings, amount)
            print('Not buyable yet: run --activate when the listing should go live')
        elif args.activate:
            activate(product)
        else:
            print('Local validation only; no credentials loaded, no requests made')
        return 0
    except ProductError as error:
        print(str(error), file=sys.stderr)
        return 1


if __name__ == '__main__':
    sys.exit(main())
