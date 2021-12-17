import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/stores/wallet_store_imp.dart';
import 'package:transaction_signing_gateway/gateway/transaction_signing_gateway.dart';
import '../../mocks/mock_constants.dart';
import '../../mocks/mock_custom_transaction_gateway.dart';
import '../../mocks/mock_repository.dart';
import '../../mocks/mock_transaction_gateway.dart';

void main() {
  late WalletsStoreImp walletsStoreImp;
  MockCustomTransactionSigningGateway mockCustomTransactionSigningGateway;
  MockTransactionSigningGateway mockTransactionSigningGateway;

  setUp(() {
    final repository = MockRepository();

    mockTransactionSigningGateway = MockTransactionSigningGateway();
    mockCustomTransactionSigningGateway = MockCustomTransactionSigningGateway();
    walletsStoreImp = WalletsStoreImp(mockTransactionSigningGateway, MOCK_BASE_ENV, mockCustomTransactionSigningGateway, repository: repository);
  });

  group('getProfile', () {
    test('should return the create account error', () async {
      final response = await walletsStoreImp.getProfile();
      expect(response.success, false);
      expect(response.errorCode, HandlerFactory.ERR_PROFILE_DOES_NOT_EXIST);
      expect(response.error, 'create_profile_before_using');
    });
  });
}
