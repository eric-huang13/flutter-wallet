
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/services/stripe_services/stripe_services.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/third_party_services/local_storage_service.dart';

import '../../../mocks/mock_constants.dart';
import '../../../mocks/mock_local_data_source.dart';
import '../../../mocks/mock_stripe_services.dart';
import '../../../mocks/mock_wallet_store.dart';

void main() {

  final mockWalletStore = MockWalletStore();
  GetIt.I.registerSingleton<WalletsStore>(mockWalletStore);
  final stripeServices = MockStripeServices();
  GetIt.I.registerSingleton<StripeServices>(stripeServices);
  final localdataSource = MockLocalDataSource();
  GetIt.I.registerSingleton<LocalDataSource>(localdataSource);

  test('test CreatePaymentIntent',  () async {

    final req = StripeCreatePaymentIntentRequest(
        address: MOCK_ADDRESS,
        coinInputIndex: 0,
        productID: 'recipe/cookbook_for_test_stripe_5/cookbook_for_test_stripe_5'
    );
    final response = await stripeServices.CreatePaymentIntent(req);
    expect(true, response is StripeCreatePaymentIntentResponse);
    expect(true, response.success);
  });

  test('test GeneratePaymentReceipt', () async {

    final req = StripeGeneratePaymentReceiptRequest(
        clientSecret: '',
        paymentIntentID: ''
    );
    final response = await stripeServices.GeneratePaymentReceipt(req);
    expect(true, response is StripeGeneratePaymentReceiptResponse);
    expect(true, response.success);
  });

  test('test GenerateRegistrationToken', () async {

    final String address = MOCK_ADDRESS;

    final response = await stripeServices.GenerateRegistrationToken(address);
    expect(true, response is StripeGenerateRegistrationTokenResponse);
    expect(true, response.success);
  });

  test('test RegisterAccount', () async {

    final req = StripeRegisterAccountRequest(
        Signature: '',
        Address: MOCK_ADDRESS,
        Token: ''
    );
    final response = await stripeServices.RegisterAccount(req);
    expect(true, response is StripeRegisterAccountResponse);
    expect(true, response.success);
  });

  test('test GenerateUpdateToken', () async {

    final response = await stripeServices.GenerateUpdateToken(MOCK_ADDRESS);
    expect(true, response is StripeGenerateUpdateTokenResponse);
    expect(true, response.success);
  });

  test('test UpdateAccount', () async {

    final req = StripeUpdateAccountRequest(
        Signature: '',
        Address: MOCK_ADDRESS,
        Token: ''
    );
    final response = await stripeServices.UpdateAccount(req);
    expect(true, response is StripeUpdateAccountResponse);
    expect(true, response.success);
  });

  test('test GeneratePayoutToken', () async {

    final req = StripeGeneratePayoutTokenRequest(
        address: '',
        amount: Int64.ONE
    );
    final response = await stripeServices.GeneratePayoutToken(req);
    expect(true, response is StripeGeneratePayoutTokenResponse);
    expect(true, response.success);
  });

  test('test Payout', () async {

    final req = StripePayoutRequest(
      address: '',
      amount: Int64.ONE,
      token: '',
      signature: '',
    );
    final response = await stripeServices.Payout(req);
    expect(true, response is StripePayoutResponse);
    expect(true, response.success);
  });

  test('test GetAccountLink', () async {

    final req = StripeAccountLinkRequest(
        Signature: '',
        Account: ''
    );
    final response = await stripeServices.GetAccountLink(req);
    expect(true, response is StripeAccountLinkResponse);
    expect(true, response.success);
  });
}