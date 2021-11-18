import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_wallet/ipc/ipc_engine.dart';

import '../../mocks/mock_constants.dart';



void main() {
  test('test encoding', () {

    var sender = "pylo1t3xupuj9f72jpxddkfs2sps4lsj8ejznd9r4jj";
    var key = "txCreateCookbook";

    final list = <String>[sender,key,MOCK_COOKBOOK];
    var result = IPCEngine().encodeMessage(list);

    print(result);

  });
}

