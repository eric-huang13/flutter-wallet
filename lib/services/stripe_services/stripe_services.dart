import 'dart:convert';
import 'package:fixnum/fixnum.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/query_helper.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeCreatePaymentIntentRequest {
  final String address;
  final String productID;
  final int coinInputIndex;

  StripeCreatePaymentIntentRequest(
      {required this.address,
      required this.productID,
      required this.coinInputIndex});

  Map<String, dynamic> toJson() => {
        'address': address,
        'productID': productID,
        'coin_inputs_index': coinInputIndex
      };
}

class StripeCreatePaymentIntentResponse {
  final bool success;
  final String clientsecret;

  StripeCreatePaymentIntentResponse(
      {this.clientsecret = '', this.success = false});

  factory StripeCreatePaymentIntentResponse.from(
      RequestResult<Map<String, dynamic>> ret) {
    if (ret.isSuccessful && ret.value != null) {
      return StripeCreatePaymentIntentResponse(
          clientsecret: ret.value?.entries
              .firstWhere((e) => e.key == 'clientSecret',
                  orElse: () => MapEntry('clientSecret', ''))
              .value as String,
          success: true);
    }
    return StripeCreatePaymentIntentResponse();
  }
}

class StripeGeneratePaymentReceiptRequest {
  final String paymentIntentID;
  final String clientSecret;

  StripeGeneratePaymentReceiptRequest(
      {required this.paymentIntentID, required this.clientSecret});

  Map<String, dynamic> toJson() =>
      {'payment_intent_id': paymentIntentID, 'client_secret': clientSecret};
}

class StripeGeneratePaymentReceiptResponse {
  final bool success;
  final String purchaseID;
  final String processorName;
  final String payerAddr;
  final String amount;
  final String productID;
  final String signature;

  StripeGeneratePaymentReceiptResponse(
      {this.purchaseID = '',
      this.processorName = '',
      this.payerAddr = '',
      this.amount = '',
      this.productID = '',
      this.signature = '',
      this.success = false});

  factory StripeGeneratePaymentReceiptResponse.from(
      RequestResult<Map<String, dynamic>> ret) {
    if (ret.isSuccessful && ret.value != null) {
      return StripeGeneratePaymentReceiptResponse(
          productID: ret.value?.entries
              .firstWhere((e) => e.key == 'productID',
                  orElse: () => MapEntry('productID', ''))
              .value as String,
          payerAddr: ret.value?.entries
              .firstWhere((e) => e.key == 'payerAddr',
                  orElse: () => MapEntry('payerAddr', ''))
              .value as String,
          amount: ret.value?.entries
              .firstWhere((e) => e.key == 'amount',
                  orElse: () => MapEntry('amount', ''))
              .value as String,
          signature: ret.value?.entries
              .firstWhere((e) => e.key == 'signature',
                  orElse: () => MapEntry('signature', ''))
              .value as String,
          purchaseID: ret.value?.entries
              .firstWhere((e) => e.key == 'purchaseID',
                  orElse: () => MapEntry('purchaseID', ''))
              .value as String,
          processorName: ret.value?.entries
              .firstWhere((e) => e.key == 'processorName',
                  orElse: () => MapEntry('processorName', ''))
              .value as String,
          success: true);
    }
    return StripeGeneratePaymentReceiptResponse();
  }

  Map<String, dynamic> toJson() => {
        'purchaseID': purchaseID,
        'processorName': processorName,
        'payerAddr': payerAddr,
        'amount': amount,
        'productID': productID,
        'signature': signature
      };
}

class StripeGenerateRegistrationTokenResponse {
  final bool success;
  final String token;

  StripeGenerateRegistrationTokenResponse(
      {this.token = '', this.success = false});

  factory StripeGenerateRegistrationTokenResponse.from(
      RequestResult<Map<String, dynamic>> ret) {
    if (ret.isSuccessful && ret.value != null) {
      return StripeGenerateRegistrationTokenResponse(
          token: ret.value?.entries
              .firstWhere((e) => e.key == 'token',
                  orElse: () => MapEntry('token', ''))
              .value as String,
          success: true);
    }
    return StripeGenerateRegistrationTokenResponse();
  }
}

class StripeRegisterAccountRequest {
  final String Address;
  final String Token;
  final String Signature;

  StripeRegisterAccountRequest(
      {required this.Address, required this.Token, required this.Signature});

  Map<String, dynamic> toJson() => {
        'address': this.Address,
        'token': this.Token,
        'signature': this.Signature
      };
}

class StripeRegisterAccountResponse {
  final String accountlink;
  final String account;
  final bool success;

  StripeRegisterAccountResponse({
    this.accountlink = '',
    this.account = '',
    this.success = false,
  });

  factory StripeRegisterAccountResponse.from(
      RequestResult<Map<String, dynamic>> ret) {
    if (ret.isSuccessful && ret.value != null) {
      return StripeRegisterAccountResponse(
          accountlink: ret.value?.entries
              .firstWhere((e) => e.key == 'accountlink',
                  orElse: () => MapEntry('accountlink', ''))
              .value as String,
          account: ret.value?.entries
              .firstWhere((e) => e.key == 'account',
                  orElse: () => MapEntry('account', ''))
              .value as String,
          success: true);
    }
    return StripeRegisterAccountResponse();
  }
}

class StripeGenerateUpdateTokenResponse {
  final String token;
  final bool success;

  StripeGenerateUpdateTokenResponse({
    this.token = '',
    this.success = false,
  });

  factory StripeGenerateUpdateTokenResponse.from(
      RequestResult<Map<String, dynamic>> ret) {
    if (ret.isSuccessful && ret.value != null) {
      return StripeGenerateUpdateTokenResponse(
          token: ret.value?.entries
              .firstWhere((e) => e.key == 'token',
                  orElse: () => MapEntry('token', ''))
              .value as String,
          success: true);
    }
    return StripeGenerateUpdateTokenResponse();
  }
}

//reserve
class StripeUpdateAccountRequest {
  final String Address;
  final String Token;
  final String Signature;

  StripeUpdateAccountRequest(
      {required this.Address, required this.Token, required this.Signature});

  Map<String, dynamic> toJson() => {
        'address': this.Address,
        'token': this.Token,
        'signature': this.Signature
      };
}

//reserve
class StripeUpdateAccountResponse {
  final String accountlink;
  final String account;
  final bool success;

  StripeUpdateAccountResponse(
      {this.accountlink = '', this.account = '', this.success = false});

  factory StripeUpdateAccountResponse.from(
      RequestResult<Map<String, dynamic>> ret) {
    if (ret.isSuccessful && ret.value != null) {
      return StripeUpdateAccountResponse(
          accountlink: ret.value?.entries
              .firstWhere((e) => e.key == 'accountlink',
                  orElse: () => MapEntry('accountlink', ''))
              .value as String,
          account: ret.value?.entries
              .firstWhere((e) => e.key == 'account',
                  orElse: () => MapEntry('account', ''))
              .value as String,
          success: true);
    }
    return StripeUpdateAccountResponse();
  }
}

class StripeAccountLinkRequest {
  final String Account;
  final String Signature;

  StripeAccountLinkRequest({required this.Account, required this.Signature});

  Map<String, dynamic> toJson() =>
      {'account': this.Account, 'signature': this.Signature};
}

class StripeAccountLinkResponse {
  final String accountlink;
  final String account;
  final bool success;

  StripeAccountLinkResponse(
      {this.accountlink = '', this.account = '', this.success = false});

  factory StripeAccountLinkResponse.from(
      RequestResult<Map<String, dynamic>> ret) {
    if (ret.isSuccessful && ret.value != null) {
      return StripeAccountLinkResponse(
          accountlink: ret.value?.entries
              .firstWhere((e) => e.key == 'accountlink',
                  orElse: () => MapEntry('accountlink', ''))
              .value as String,
          account: ret.value?.entries
              .firstWhere((e) => e.key == 'account',
                  orElse: () => MapEntry('account', ''))
              .value as String,
          success: true);
    }
    return StripeAccountLinkResponse();
  }
}

class StripeGeneratePayoutTokenRequest {
  final String address;
  final Int64 amount;

  StripeGeneratePayoutTokenRequest(
      {required this.address, required this.amount});
}

class StripeGeneratePayoutTokenResponse {
  final String token;
  final Int64 RedeemAmount;
  final bool success;

  StripeGeneratePayoutTokenResponse({
    this.token = '',
    this.RedeemAmount = Int64.ZERO,
    this.success = false,
  });

  factory StripeGeneratePayoutTokenResponse.from(
      RequestResult<Map<String, dynamic>> ret) {
    if (ret.isSuccessful && ret.value != null) {
      return StripeGeneratePayoutTokenResponse(
          token: ret.value?.entries
              .firstWhere((e) => e.key == 'token',
                  orElse: () => MapEntry('token', ''))
              .value as String,
          RedeemAmount: Int64.parseInt((ret.value?.entries
                  .firstWhere((e) => e.key == 'RedeemAmount',
                      orElse: () => MapEntry('RedeemAmount', 0))
                  .value as int)
              .toString()),
          success: true);
    }
    return StripeGeneratePayoutTokenResponse();
  }
}

class StripePayoutRequest {
  final String address;
  final String token;
  final String signature;
  final Int64 amount;

  StripePayoutRequest(
      {this.address = '',
      this.token = '',
      this.signature = '',
      this.amount = Int64.ZERO});

  Map<String, dynamic> toJson() => {
        'address': address,
        'token': token,
        'signature': signature,
        'amount': amount.toInt()
      };
}

class StripePayoutResponse {
  final String transfer_id;
  final bool success;

  StripePayoutResponse({this.transfer_id = '', this.success = false});

  factory StripePayoutResponse.from(RequestResult<Map<String, dynamic>> ret) {
    if (ret.isSuccessful && ret.value != null) {
      return StripePayoutResponse(
          transfer_id: ret.value?.entries
              .firstWhere((e) => e.key == 'transfer_id',
                  orElse: () => MapEntry('transfer_id', ''))
              .value as String,
          success: true);
    }
    return StripePayoutResponse();
  }
}

abstract class StripeServices {
  /// Stripe Backend API to Create PaymentIntent
  /// Input: [StripeCreatePaymentIntentRequest]
  /// return [StripeCreatePaymentIntentResponse]
  Future<StripeCreatePaymentIntentResponse> CreatePaymentIntent(
      StripeCreatePaymentIntentRequest req);

  /// Stripe Backend API to Generate Payment Receipt
  /// Input: [StripeGeneratePaymentReceiptRequest]
  /// return [StripeGeneratePaymentReceiptResponse]
  Future<StripeGeneratePaymentReceiptResponse> GeneratePaymentReceipt(
      StripeGeneratePaymentReceiptRequest req);

  /// Stripe Backend API to Generate Registration Token
  /// Input: [address]
  /// return [StripeGenerateRegistrationTokenResponse]
  Future<StripeGenerateRegistrationTokenResponse> GenerateRegistrationToken(
      String address);

  /// Stripe Backend API to Register Stripe connected Account
  /// Input: [StripeRegisterAccountRequest]
  /// return [StripeRegisterAccountResponse]
  Future<StripeRegisterAccountResponse> RegisterAccount(
      StripeRegisterAccountRequest req);

  /// Stripe Backend API to Generate Updated Token for Connected Account
  /// Input: [address]
  /// return [StripeGenerateUpdateTokenResponse]
  Future<StripeGenerateUpdateTokenResponse> GenerateUpdateToken(String address);

  /// Stripe Backend API to Update Stripe Connected Account
  /// Input: [address]
  /// return [StripeGenerateUpdateTokenResponse]
  Future<StripeUpdateAccountResponse> UpdateAccount(
      StripeUpdateAccountRequest req);

  /// Stripe Backend API to Generate Payout Token
  /// Input: [StripeGeneratePayoutTokenRequest]
  /// return [StripeGeneratePayoutTokenResponse]
  Future<StripeGeneratePayoutTokenResponse> GeneratePayoutToken(
      StripeGeneratePayoutTokenRequest req);

  /// Stripe Backend API to Payout request
  /// Input: [StripePayoutRequest]
  /// return [StripePayoutResponse]
  Future<StripePayoutResponse> Payout(StripePayoutRequest req);

  Future<StripeAccountLinkResponse> GetAccountLink(
      StripeAccountLinkRequest req);
}

/**
 * Stripe Backend API class implementation
 */
class StripeServicesImpl extends StripeServices {
  final String stripeUrl;
  final String stripePubKey;

  final _httpClient = http.Client();

  StripeServicesImpl(this.stripeUrl, this.stripePubKey) {
    Stripe.publishableKey = this.stripePubKey;
  }

  /// Stripe Backend API to Payout request
  /// Input: [StripeCreatePaymentIntentRequest] {address:, productID:, coin_inputs_index:}
  /// return [StripeCreatePaymentIntentResponse] {client_secret}
  @override
  Future<StripeCreatePaymentIntentResponse> CreatePaymentIntent(
      StripeCreatePaymentIntentRequest req) async {
    final helper = QueryHelper(httpClient: _httpClient);
    final result = await helper.queryPost(
        "$stripeUrl/create-payment-intent", req.toJson());
    return StripeCreatePaymentIntentResponse.from(result);
  }

  /// Stripe Backend API to Generate Payment Receipt
  /// Input: [StripeGeneratePaymentReceiptRequest] {pament_intent_id:, client_secret}
  /// return [StripeGeneratePaymentReceiptResponse]
  /// response: {
  ///    purchaseID: String,
  ///    processorName: String
  ///    payerAddr: String
  ///    amount: String
  ///    productID: String,
  ///    signature: String
  /// }
  @override
  Future<StripeGeneratePaymentReceiptResponse> GeneratePaymentReceipt(
      StripeGeneratePaymentReceiptRequest req) async {
    final helper = QueryHelper(httpClient: _httpClient);
    final result = await helper.queryPost(
        "$stripeUrl/generate-payment-receipt", req.toJson());
    return StripeGeneratePaymentReceiptResponse.from(result);
  }

  /// Stripe Backend API to Generate Payment Receipt
  /// Input: [address] wallet address
  /// return [StripeGenerateRegistrationTokenResponse]
  @override
  Future<StripeGenerateRegistrationTokenResponse> GenerateRegistrationToken(
      String address) async {
    final helper = QueryHelper(httpClient: _httpClient);
    final result = await helper
        .queryGet("$stripeUrl/generate-registration-token?address=${address}");
    return StripeGenerateRegistrationTokenResponse.from(result);
  }

  /// Stripe Backend API to Register Stripe connected account
  /// Input: [StripeRegisterAccountRequest]
  /// return [StripeRegisterAccountResponse]
  @override
  Future<StripeRegisterAccountResponse> RegisterAccount(
      StripeRegisterAccountRequest req) async {
    final helper = QueryHelper(httpClient: _httpClient);
    final result =
        await helper.queryPost("$stripeUrl/register-account", req.toJson());
    return StripeRegisterAccountResponse.from(result);
  }

  /// Stripe Backend API to Generate UpdatedToken for ConnectedAccount
  /// Input: [address] wallet address
  /// return [StripeGenerateUpdateTokenResponse]
  @override
  Future<StripeGenerateUpdateTokenResponse> GenerateUpdateToken(
      String address) async {
    final helper = QueryHelper(httpClient: _httpClient);
    final result = await helper
        .queryGet("$stripeUrl/generate-update-token?address=${address}");
    return StripeGenerateUpdateTokenResponse.from(result);
  }

  /// Stripe Backend API to Update Stripe update account
  /// Input: [StripeUpdateAccountRequest] {address:String, token: String, signature: String}
  /// return [StripeUpdateAccountResponse] redirectURL
  @override
  Future<StripeUpdateAccountResponse> UpdateAccount(
      StripeUpdateAccountRequest req) async {
    final helper = QueryHelper(httpClient: _httpClient);
    final result =
        await helper.queryPost("$stripeUrl/update-account", req.toJson());
    return StripeUpdateAccountResponse.from(result);
  }

  /// Stripe Backend API to Generate payout token
  /// Input: [StripeGeneratePayoutTokenRequest] {address: String, amount: int}
  /// return [StripeGeneratePayoutTokenResponse] {token: String, RedeemAmount: int64}
  @override
  Future<StripeGeneratePayoutTokenResponse> GeneratePayoutToken(
      StripeGeneratePayoutTokenRequest req) async {
    final helper = QueryHelper(httpClient: _httpClient);
    final result = await helper.queryGet(
        "$stripeUrl/generate-payout-token?address=${req.address}&amount=${req.amount}");
    return StripeGeneratePayoutTokenResponse.from(result);
  }

  /// Stripe Backend API to Payout Request
  /// Input: [StripePayoutRequest] {address:String, token:String, signature:String, amount:int}
  /// return [StripePayoutResponse] {transfer_id:String}
  @override
  Future<StripePayoutResponse> Payout(StripePayoutRequest req) async {
    final helper = QueryHelper(httpClient: _httpClient);
    final result = await helper.queryPost("$stripeUrl/payout", req.toJson());
    return StripePayoutResponse.from(result);
  }

  /// Stripe Backend API to Get Stripe Connected Account Link
  /// Input: [StripeAccountLinkRequest]
  /// return [StripeAccountLinkResponse]
  @override
  Future<StripeAccountLinkResponse> GetAccountLink(
      StripeAccountLinkRequest req) async {
    final helper = QueryHelper(httpClient: _httpClient);
    final result =
        await helper.queryPost("$stripeUrl/accountlink", req.toJson());
    return StripeAccountLinkResponse.from(result);
  }
}
