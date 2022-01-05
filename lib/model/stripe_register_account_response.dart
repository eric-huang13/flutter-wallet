import 'package:pylons_wallet/utils/query_helper.dart';

class StripeRegisterAccountResponse {
  final String accountlink;
  final String account;
  final bool success;

  StripeRegisterAccountResponse({
    this.accountlink = '',
    this.account = '',
    this.success = false,
  });

  factory StripeRegisterAccountResponse.from(
      RequestResult<Map<String, dynamic>> ret) {
    if (ret.isSuccessful && ret.value != null) {
      return StripeRegisterAccountResponse(
          accountlink: ret.value?.entries
              .firstWhere((entry) => entry.key == 'accountlink',
                  orElse: () => const MapEntry('accountlink', ''))
              .value as String,
          account: ret.value?.entries
              .firstWhere((entry) => entry.key == 'account',
                  orElse: () => const MapEntry('account', ''))
              .value as String,
          success: true);
    }
    return StripeRegisterAccountResponse();
  }
}
