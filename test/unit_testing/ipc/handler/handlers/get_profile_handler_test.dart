import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/handler/handlers/create_cook_book_handler.dart';
import 'package:pylons_wallet/ipc/handler/handlers/get_profile_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import '../../../../mocks/mock_constants.dart';
import '../../../../mocks/mock_wallet_store.dart';



void main() {
  test('should return the user name from get profile', () async {
    final mockWalletStore = MockWalletStore();

    GetIt.I.registerSingleton<WalletsStore>(mockWalletStore);

    final sdkipcMessage = SDKIPCMessage(action: HandlerFactory.GET_PROFILE, json: '', sender: SENDER_APP);

    final handler = GetProfileHandler(sdkipcMessage);
    final response = await handler.handle();



    expect(MOCK_USERNAME, response.data['username']);
    expect(SENDER_APP, response.sender);
    expect(HandlerFactory.GET_PROFILE, response.action);
  });
}
