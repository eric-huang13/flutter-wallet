
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/services/stripe_services/stripe_handler.dart';
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

  test('test handleStripePayout',  () async {


    String amount = "1";
    final payoutRet = await StripeHandler().handleStripePayout(amount);
  });

  test('test handleStripeAccountLink', ()async {

    final stripeAccountLinkRet = await StripeHandler().handleStripeAccountLink();

  });
}