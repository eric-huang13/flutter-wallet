import 'package:pylons_wallet/utils/third_party_services/local_storage_service.dart';

class MockLocalDataSource extends LocalDataSource {
  @override
  String StripeToken = '';

  @override
  String StripeAccount = '';

  @override
  Future<void> loadData() async {
  }

  @override
  Future<void> saveData() async {
  }

  @override
  Future<void> clearDataOnIosUnInstall() {
    // TODO: implement clearDataOnIosUnInstall
    throw UnimplementedError();
  }

}