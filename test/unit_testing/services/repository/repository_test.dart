
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/model/export.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/third_party_services/local_storage_service.dart';

import '../../../mocks/mock_constants.dart';
import '../../../mocks/mock_local_data_source.dart';
import '../../../mocks/mock_repository.dart';
import '../../../mocks/mock_wallet_store.dart';

void main() {

  final mockWalletStore = MockWalletStore();
  GetIt.I.registerSingleton<WalletsStore>(mockWalletStore);
  final mockRepository = MockRepository();
  GetIt.I.registerSingleton<Repository>(mockRepository);
  final localdataSource = MockLocalDataSource();
  GetIt.I.registerSingleton<LocalDataSource>(localdataSource);

  test('test CreatePaymentIntent',  () async {

    final req = StripeCreatePaymentIntentRequest(
        address: MOCK_ADDRESS,
        coinInputIndex: 0,
        productID: 'recipe/cookbook_for_test_stripe_5/cookbook_for_test_stripe_5'
    );
    final response = await mockRepository.CreatePaymentIntent(req);
    expect(true, response.getOrElse(() => StripeCreatePaymentIntentResponse()).success);
  });

  test('test GeneratePaymentReceipt', () async {

    final req = StripeGeneratePaymentReceiptRequest(
        clientSecret: '',
        paymentIntentID: ''
    );
    final response = await mockRepository.GeneratePaymentReceipt(req);
    expect(true, response.getOrElse(() => StripeGeneratePaymentReceiptResponse()).success);
  });

  test('test GenerateRegistrationToken', () async {

    final String address = MOCK_ADDRESS;

    final response = await mockRepository.GenerateRegistrationToken(address);
    expect(true, response.getOrElse(() => StripeGenerateRegistrationTokenResponse()).success);
  });

  test('test RegisterAccount', () async {

    final req = StripeRegisterAccountRequest(
        Signature: '',
        Address: MOCK_ADDRESS,
        Token: ''
    );
    final response = await mockRepository.RegisterAccount(req);
    expect(true, response.getOrElse(() => StripeRegisterAccountResponse()).success);
  });

  test('test GenerateUpdateToken', () async {

    final response = await mockRepository.GenerateUpdateToken(MOCK_ADDRESS);
    expect(true, response.getOrElse(() => StripeGenerateUpdateTokenResponse()).success);
  });

  test('test UpdateAccount', () async {

    final req = StripeUpdateAccountRequest(
        Signature: '',
        Address: MOCK_ADDRESS,
        Token: ''
    );
    final response = await mockRepository.UpdateAccount(req);
    expect(true, response.getOrElse(() => StripeUpdateAccountResponse()).success);
  });

  test('test GeneratePayoutToken', () async {

    final req = StripeGeneratePayoutTokenRequest(
        address: '',
        amount: Int64.ONE
    );
    final response = await mockRepository.GeneratePayoutToken(req);
    expect(true, response.getOrElse(() => StripeGeneratePayoutTokenResponse()).success);
  });

  test('test Payout', () async {

    final req = StripePayoutRequest(
      address: '',
      amount: Int64.ONE,
      token: '',
      signature: '',
    );
    final response = await mockRepository.Payout(req);
    expect(true, response.getOrElse(() => StripePayoutResponse()).success);
  });

  test('test GetAccountLink', () async {

    final req = StripeAccountLinkRequest(
        Signature: '',
        Account: ''
    );
    final response = await mockRepository.GetAccountLink(req);
    expect(true, response.getOrElse(() => StripeAccountLinkResponse()).success);
  });
}