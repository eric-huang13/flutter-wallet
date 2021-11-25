
import 'package:fixnum/fixnum.dart';
import 'package:pylons_wallet/services/stripe_services/stripe_services.dart';

class MockStripeServices extends StripeServices {
  @override
  Future<StripeCreatePaymentIntentResponse> CreatePaymentIntent(StripeCreatePaymentIntentRequest req) async {
    return StripeCreatePaymentIntentResponse(clientsecret: '', success: true);
  }

  @override
  Future<StripeGeneratePaymentReceiptResponse> GeneratePaymentReceipt(StripeGeneratePaymentReceiptRequest req) async {
    return StripeGeneratePaymentReceiptResponse(
      success: true,
      purchaseID: '',
      processorName: '',
      payerAddr: '',
      amount: '',
      signature: '',
    );
  }

  @override
  Future<StripeGeneratePayoutTokenResponse> GeneratePayoutToken(StripeGeneratePayoutTokenRequest req) async {
    return StripeGeneratePayoutTokenResponse(success: true,RedeemAmount: Int64.ONE, token: '');
  }

  @override
  Future<StripeGenerateRegistrationTokenResponse> GenerateRegistrationToken(String address) async {
    return StripeGenerateRegistrationTokenResponse(success: true, token: '');
  }

  @override
  Future<StripeGenerateUpdateTokenResponse> GenerateUpdateToken(String address) async {
    return StripeGenerateUpdateTokenResponse(success: true, token: '');
  }

  @override
  Future<StripeAccountLinkResponse> GetAccountLink(StripeAccountLinkRequest req) async {
    return StripeAccountLinkResponse(success: true, accountlink: '', account: '');
  }

  @override
  Future<StripePayoutResponse> Payout(StripePayoutRequest req) async {
    return StripePayoutResponse(success: true, transfer_id: '' );
  }

  @override
  Future<StripeRegisterAccountResponse> RegisterAccount(StripeRegisterAccountRequest req) async {
    return StripeRegisterAccountResponse(success: true, accountlink: '', account: '');
  }

  @override
  Future<StripeUpdateAccountResponse> UpdateAccount(StripeUpdateAccountRequest req) async {
    return StripeUpdateAccountResponse(success: true, account: '', accountlink: '');
  }

}