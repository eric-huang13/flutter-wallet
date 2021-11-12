import 'package:http/http.dart' as http;
import 'package:pylons_wallet/utils/query_helper.dart';

abstract class StripeResponse {

}


class StripeServices{
  final _httpClient = http.Client();

  Future<void> CreatePaymentIntent(Map<String, dynamic> map) async {
    //POST
    //{address:, productID:, coin_inputs_index:}
    final helper = QueryHelper(httpClient: _httpClient);
    final result = await helper.queryPost(PylonsApp. .baseFaucetUrl, data);


  }

  Future<void> GeneratePaymentReceipt() async {

  }

  Future<void> GenerateRegistrationToken() async {

  }

  Future<void> RegisterAccount() async {

  }

  Future<void> GenerateUpdateToken() async {

  }

  Future<void> UpdateAccount() async {

  }

  Future<void> GeneratePayoutToken() async {

  }

  Future<void> Payout() async {

  }

  Future<void> StripeWebhooks() async {

  }


}