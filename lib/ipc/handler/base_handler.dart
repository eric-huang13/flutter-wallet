import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';

abstract class BaseHandler {
  Future<SDKIPCResponse> handle();
}
