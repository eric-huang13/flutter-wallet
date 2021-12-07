///
//  Generated code. Do not modify.
//  source: pylons/params.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use googleInAppPurchasePackageDescriptor instead')
const GoogleInAppPurchasePackage$json = const {
  '1': 'GoogleInAppPurchasePackage',
  '2': const [
    const {'1': 'packageName', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'packageName'},
    const {'1': 'productID', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'productID'},
    const {'1': 'amount', '3': 3, '4': 1, '5': 9, '8': const {}, '10': 'amount'},
  ],
};

/// Descriptor for `GoogleInAppPurchasePackage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List googleInAppPurchasePackageDescriptor = $convert.base64Decode('ChpHb29nbGVJbkFwcFB1cmNoYXNlUGFja2FnZRI5CgtwYWNrYWdlTmFtZRgBIAEoCUIX8t4fE3lhbWw6InBhY2thZ2VfbmFtZSJSC3BhY2thZ2VOYW1lEjMKCXByb2R1Y3RJRBgCIAEoCUIV8t4fEXlhbWw6InByb2R1Y3RfaWQiUglwcm9kdWN0SUQSVwoGYW1vdW50GAMgASgJQj/I3h8A8t4fDXlhbWw6ImFtb3VudCLa3h8mZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5JbnRSBmFtb3VudA==');
@$core.Deprecated('Use coinIssuerDescriptor instead')
const CoinIssuer$json = const {
  '1': 'CoinIssuer',
  '2': const [
    const {'1': 'coinDenom', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'coinDenom'},
    const {'1': 'packages', '3': 2, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.GoogleInAppPurchasePackage', '8': const {}, '10': 'packages'},
    const {'1': 'googleInAppPurchasePubKey', '3': 3, '4': 1, '5': 9, '8': const {}, '10': 'googleInAppPurchasePubKey'},
    const {'1': 'entityName', '3': 4, '4': 1, '5': 9, '10': 'entityName'},
  ],
};

/// Descriptor for `CoinIssuer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List coinIssuerDescriptor = $convert.base64Decode('CgpDb2luSXNzdWVyEjMKCWNvaW5EZW5vbRgBIAEoCUIV8t4fEXlhbWw6ImNvaW5fZGVub20iUgljb2luRGVub20SdAoIcGFja2FnZXMYAiADKAsyNC5QeWxvbnN0ZWNoLnB5bG9ucy5weWxvbnMuR29vZ2xlSW5BcHBQdXJjaGFzZVBhY2thZ2VCIvLeHxp5YW1sOiJnb29nbGVfaWFwX3BhY2thZ2VzIsjeHwBSCHBhY2thZ2VzEloKGWdvb2dsZUluQXBwUHVyY2hhc2VQdWJLZXkYAyABKAlCHPLeHxh5YW1sOiJnb29nbGVfaWFwX3B1YmtleSJSGWdvb2dsZUluQXBwUHVyY2hhc2VQdWJLZXkSHgoKZW50aXR5TmFtZRgEIAEoCVIKZW50aXR5TmFtZQ==');
@$core.Deprecated('Use paymentProcessorDescriptor instead')
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

/// Descriptor for `PaymentProcessor`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paymentProcessorDescriptor = $convert.base64Decode('ChBQYXltZW50UHJvY2Vzc29yEjMKCUNvaW5EZW5vbRgBIAEoCUIV8t4fEXlhbWw6ImNvaW5fZGVub20iUglDb2luRGVub20SKgoGcHViS2V5GAIgASgJQhLy3h8OeWFtbDoicHViX2tleSJSBnB1YktleRJ/ChNwcm9jZXNzb3JQZXJjZW50YWdlGAMgASgJQk3y3h8beWFtbDoicHJvY2Vzc29yX3BlcmNlbnRhZ2UiyN4fANreHyZnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkRlY1ITcHJvY2Vzc29yUGVyY2VudGFnZRKBAQoUdmFsaWRhdG9yc1BlcmNlbnRhZ2UYBCABKAlCTfLeHxt5YW1sOiJ2YWxpZGF0b3JzX3BlY2VudGFnZSLI3h8A2t4fJmdpdGh1Yi5jb20vY29zbW9zL2Nvc21vcy1zZGsvdHlwZXMuRGVjUhR2YWxpZGF0b3JzUGVyY2VudGFnZRISCgRuYW1lGAUgASgJUgRuYW1l');
@$core.Deprecated('Use paramsDescriptor instead')
const Params$json = const {
  '1': 'Params',
  '2': const [
    const {'1': 'coinIssuers', '3': 1, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.CoinIssuer', '8': const {}, '10': 'coinIssuers'},
    const {'1': 'paymentProcessors', '3': 2, '4': 3, '5': 11, '6': '.Pylonstech.pylons.pylons.PaymentProcessor', '8': const {}, '10': 'paymentProcessors'},
    const {'1': 'recipeFeePercentage', '3': 3, '4': 1, '5': 9, '8': const {}, '10': 'recipeFeePercentage'},
    const {'1': 'itemTransferFeePercentage', '3': 4, '4': 1, '5': 9, '8': const {}, '10': 'itemTransferFeePercentage'},
    const {'1': 'updateItemStringFee', '3': 5, '4': 1, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'updateItemStringFee'},
    const {'1': 'minTransferFee', '3': 6, '4': 1, '5': 9, '8': const {}, '10': 'minTransferFee'},
    const {'1': 'maxTransferFee', '3': 7, '4': 1, '5': 9, '8': const {}, '10': 'maxTransferFee'},
    const {'1': 'updateUsernameFee', '3': 8, '4': 1, '5': 11, '6': '.cosmos.base.v1beta1.Coin', '8': const {}, '10': 'updateUsernameFee'},
    const {'1': 'distrEpochIdentifier', '3': 9, '4': 1, '5': 9, '8': const {}, '10': 'distrEpochIdentifier'},
    const {'1': 'engineVersion', '3': 10, '4': 1, '5': 4, '8': const {}, '10': 'engineVersion'},
  ],
  '7': const {},
};

/// Descriptor for `Params`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paramsDescriptor = $convert.base64Decode('CgZQYXJhbXMSYwoLY29pbklzc3VlcnMYASADKAsyJC5QeWxvbnN0ZWNoLnB5bG9ucy5weWxvbnMuQ29pbklzc3VlckIb8t4fE3lhbWw6ImNvaW5faXNzdWVycyLI3h8AUgtjb2luSXNzdWVycxJ7ChFwYXltZW50UHJvY2Vzc29ycxgCIAMoCzIqLlB5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5QYXltZW50UHJvY2Vzc29yQiHy3h8ZeWFtbDoicGF5bWVudF9wcm9jZXNzb3JzIsjeHwBSEXBheW1lbnRQcm9jZXNzb3JzEoABChNyZWNpcGVGZWVQZXJjZW50YWdlGAMgASgJQk7y3h8ceWFtbDoicmVjaXBlX2ZlZV9wZXJjZW50YWdlIsjeHwDa3h8mZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5EZWNSE3JlY2lwZUZlZVBlcmNlbnRhZ2USkwEKGWl0ZW1UcmFuc2ZlckZlZVBlcmNlbnRhZ2UYBCABKAlCVfLeHyN5YW1sOiJpdGVtX3RyYW5zZmVyX2ZlZV9wZXJjZW50YWdlIsjeHwDa3h8mZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5EZWNSGWl0ZW1UcmFuc2ZlckZlZVBlcmNlbnRhZ2UScgoTdXBkYXRlSXRlbVN0cmluZ0ZlZRgFIAEoCzIZLmNvc21vcy5iYXNlLnYxYmV0YTEuQ29pbkIl8t4fHXlhbWw6InVwZGF0ZV9pdGVtX3N0cmluZ19mZWUiyN4fAFITdXBkYXRlSXRlbVN0cmluZ0ZlZRJxCg5taW5UcmFuc2ZlckZlZRgGIAEoCUJJ8t4fF3lhbWw6Im1pbl90cmFuc2Zlcl9mZWUiyN4fANreHyZnaXRodWIuY29tL2Nvc21vcy9jb3Ntb3Mtc2RrL3R5cGVzLkludFIObWluVHJhbnNmZXJGZWUScQoObWF4VHJhbnNmZXJGZWUYByABKAlCSfLeHxd5YW1sOiJtYXhfdHJhbnNmZXJfZmVlIsjeHwDa3h8mZ2l0aHViLmNvbS9jb3Ntb3MvY29zbW9zLXNkay90eXBlcy5JbnRSDm1heFRyYW5zZmVyRmVlEmsKEXVwZGF0ZVVzZXJuYW1lRmVlGAggASgLMhkuY29zbW9zLmJhc2UudjFiZXRhMS5Db2luQiLy3h8aeWFtbDoidXBkYXRlX3VzZXJuYW1lX2ZlZSLI3h8AUhF1cGRhdGVVc2VybmFtZUZlZRJVChRkaXN0ckVwb2NoSWRlbnRpZmllchgJIAEoCUIh8t4fHXlhbWw6ImRpc3RyX2Vwb2NoX2lkZW50aWZpZXIiUhRkaXN0ckVwb2NoSWRlbnRpZmllchI/Cg1lbmdpbmVWZXJzaW9uGAogASgEQhny3h8VeWFtbDoiZW5naW5lX3ZlcnNpb24iUg1lbmdpbmVWZXJzaW9uOgSYoB8A');
