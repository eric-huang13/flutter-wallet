import 'dart:convert';

import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';

abstract class BaseHandler {
  late SDKIPCMessage sdkipcMessage;

  Future<SDKIPCResponse> handle();
}
