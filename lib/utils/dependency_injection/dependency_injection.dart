import 'package:alan/proto/cosmos/bank/v1beta1/export.dart' as bank;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart'
    as pylons;
import 'package:pylons_wallet/pages/new_screens/purchase_item/purchase_item_view_model.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/services/third_party_services/network_info.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/stores/wallet_store_imp.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:pylons_wallet/utils/custom_transaction_broadcaster/custom_transaction_broadcaster_imp.dart';
import 'package:pylons_wallet/utils/custom_transaction_signer/custom_transaction_signer.dart';
import 'package:pylons_wallet/utils/custom_transaction_signing_gateaway/custom_transaction_signing_gateway.dart';
import 'package:pylons_wallet/utils/third_party_services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transaction_signing_gateway/alan/alan_credentials_serializer.dart';
import 'package:transaction_signing_gateway/alan/alan_transaction_broadcaster.dart';
import 'package:transaction_signing_gateway/alan/alan_transaction_signer.dart';
import 'package:transaction_signing_gateway/gateway/transaction_signing_gateway.dart';
import 'package:transaction_signing_gateway/mobile/no_op_transaction_summary_ui.dart';
import 'package:http/http.dart' as http;
import 'package:transaction_signing_gateway/storage/cosmos_key_info_storage.dart';
import 'package:transaction_signing_gateway/storage/flutter_secure_storage_data_store.dart';
import 'package:transaction_signing_gateway/storage/shared_prefs_plain_data_store.dart';

import '../query_helper.dart';

final sl = GetIt.instance;

/// This method is used for initializing the dependencies
Future<void> init() async {
  /// Core Logics
  sl.registerLazySingleton<HandlerFactory>(() => HandlerFactory());

  /// Data Sources
  sl.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImp(sl()),
  );

  sl.registerLazySingleton<QueryHelper>(() => QueryHelper(httpClient: sl()));

  /// External Dependencies
  sl.registerSingletonAsync<SharedPreferences>(
      () => SharedPreferences.getInstance());

  sl.registerLazySingleton<http.Client>(() => http.Client());

  sl.registerLazySingleton(() => BaseEnv()
    ..setEnv(
        lcdUrl: dotenv.env['LCD_URL']!,
        grpcUrl: dotenv.env['GRPC_URL']!,
        lcdPort: dotenv.env['LCD_PORT']!,
        grpcPort: dotenv.env['GRPC_PORT']!,
        ethUrl: dotenv.env['ETH_URL']!,
        tendermintPort: dotenv.env['TENDERMINT_PORT']!,
        faucetUrl: dotenv.env['FAUCET_URL'],
        faucetPort: dotenv.env['FAUCET_PORT'],
        wsUrl: dotenv.env['WS_URL']!,
        stripeUrl: dotenv.env['STRIPE_SERVER'],
        stripePubKey: dotenv.env['STRIPE_PUB_KEY'],
        stripeTestEnv: dotenv.env['STRIPE_TEST_ENV'] == 'true' ? true : false,
        stripeCallbackUrl: dotenv.env['STRIPE_CALLBACK_URL'] ?? "",
      stripeCallbackRefreshUrl: dotenv.env['STRIPE_CALLBACK_REFRESH_URL'] ?? ""

    ));





  sl.registerLazySingleton(() => TransactionSigningGateway(
        transactionSummaryUI: NoOpTransactionSummaryUI(),
        signers: [
          AlanTransactionSigner(sl.get<BaseEnv>().networkInfo),
        ],
        broadcasters: [
          AlanTransactionBroadcaster(sl.get<BaseEnv>().networkInfo),
        ],
        infoStorage:
        CosmosKeyInfoStorage(
          serializers: [AlanCredentialsSerializer()],
          plainDataStore: SharedPrefsPlainDataStore(),
          secureDataStore: FlutterSecureStorageDataStore(),
        ),

      ));

  sl.registerLazySingleton(() => CustomTransactionSigningGateway(
        transactionSummaryUI: NoOpTransactionSummaryUI(),
        signers: [
          CustomTransactionSigner(sl.get<BaseEnv>().networkInfo),
        ],
        broadcasters: [
          CustomTransactionBroadcasterImp(sl.get<BaseEnv>().networkInfo),
        ],
        infoStorage:  CosmosKeyInfoStorage(
          serializers: [AlanCredentialsSerializer()],
          plainDataStore: SharedPrefsPlainDataStore(),
          secureDataStore: FlutterSecureStorageDataStore(),
        ),
      ));

  sl.registerLazySingleton<WalletsStore>(
      () => WalletsStoreImp(sl(), sl(), sl(), repository: sl()));

  /// Services
  sl.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<pylons.QueryClient>(
      () => pylons.QueryClient(sl.get<BaseEnv>().networkInfo.gRPCChannel));
  sl.registerLazySingleton<bank.QueryClient>(
      () => bank.QueryClient(sl.get<BaseEnv>().networkInfo.gRPCChannel));

  /// Repository
  sl.registerLazySingleton<Repository>(() => RepositoryImp(
      networkInfo: sl(),
      queryClient: sl(),
      bankQueryClient: sl(),
      queryHelper: sl(),
      baseEnv: sl()));




  /// ViewModels
  sl.registerLazySingleton(() => PurchaseItemViewModel(sl()));
}
