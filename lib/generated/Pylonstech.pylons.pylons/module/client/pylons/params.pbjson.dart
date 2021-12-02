///
//  Generated code. Do not modify.
//  source: pylons/params.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

const GoogleInAppPurchasePackage$json = const {
  '1': 'GoogleInAppPurchasePackage',
  '2': const [
    const {'1': 'packageName', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'packageName'},
    const {'1': 'productID', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'productID'},
    const {'1': 'amount', '3': 3, '4': 1, '5': 9, '8': const {}, '10': 'amount'},
  ],
};

const CoinIssuer$json = const {
  '1': 'CoinIssuer',
  '2': const [
    const {'1': 'coinDenom', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'coinDenom'},
    const {'1': 'packages', '3': 2, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.GoogleInAppPurchasePackage', '8': const {}, '10': 'packages'},
    const {'1': 'googleInAppPurchasePubKey', '3': 3, '4': 1, '5': 9, '8': const {}, '10': 'googleInAppPurchasePubKey'},
    const {'1': 'entityName', '3': 4, '4': 1, '5': 9, '10': 'entityName'},
  ],
};

const PaymentProcessor$json = const {
  '1': 'PaymentProcessor',
  '2': const [
    const {'1': 'CoinDenom', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'CoinDenom'},
    const {'1': 'pubKey', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'pubKey'},
    const {'1': 'processorPercentage', '3': 3, '4': 1, '5': 9, '8': const {}, '10': 'processorPercentage'},
    const {'1': 'validatorsPercentage', '3': 4, '4': 1, '5': 9, '8': const {}, '10': 'validatorsPercentage'},
    const {'1': 'name', '3': 5, '4': 1, '5': 9, '10': 'name'},
  ],
};

const Params$json = const {
  '1': 'Params',
  '2': const [
    const {'1': 'minNameFieldLength', '3': 1, '4': 1, '5': 4, '8': const {}, '10': 'minNameFieldLength'},
    const {'1': 'minDescriptionFieldLength', '3': 2, '4': 1, '5': 4, '8': const {}, '10': 'minDescriptionFieldLength'},
    const {'1': 'coinIssuers', '3': 3, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.CoinIssuer', '8': const {}, '10': 'coinIssuers'},
    const {'1': 'paymentProcessors', '3': 4, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.PaymentProcessor', '8': const {}, '10': 'paymentProcessors'},
    const {'1': 'recipeFeePercentage', '3': 5, '4': 1, '5': 9, '8': const {}, '10': 'recipeFeePercentage'},
    const {'1': 'itemTransferFeePercentage', '3': 6, '4': 1, '5': 9, '8': const {}, '10': 'itemTransferFeePercentage'},
    const {'1': 'updateItemStringFee', '3': 7, '4': 1, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'updateItemStringFee'},
    const {'1': 'minTransferFee', '3': 8, '4': 1, '5': 9, '8': const {}, '10': 'minTransferFee'},
    const {'1': 'maxTransferFee', '3': 9, '4': 1, '5': 9, '8': const {}, '10': 'maxTransferFee'},
    const {'1': 'updateUsernameFee', '3': 10, '4': 1, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'updateUsernameFee'},
    const {'1': 'distrEpochIdentifier', '3': 11, '4': 1, '5': 9, '8': const {}, '10': 'distrEpochIdentifier'},
    const {'1': 'engineVersion', '3': 12, '4': 1, '5': 4, '8': const {}, '10': 'engineVersion'},
  ],
  '7': const {},
};

