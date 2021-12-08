import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:http/http.dart' as http;
import 'package:pylons_wallet/entities/amount.dart';
import 'package:pylons_wallet/entities/balance.dart';
import 'package:pylons_wallet/utils/base_env.dart';

class PylonsBalance {
  BaseEnv baseEnv;

  PylonsBalance(this.baseEnv);

  Future<List<Balance>> getBalance(String walletAddress) async {
    final uri = '${baseEnv.baseApiUrl}/cosmos/bank/v1beta1/balances/$walletAddress';
    final response = await http.get(Uri.parse(uri));
    final balancesResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final balancesList = balancesResponse["balances"] as List;
    final balances = <Balance>[];
    for (final balance in balancesList) {
      balances.add(Balance(denom: balance["denom"] as String, amount: Amount(Decimal.parse(balance["amount"] as String))));
    }
    if(balances.indexWhere((balance)=>balance.denom == "upylon") == -1) {
      balances.add(Balance(denom: "upylon", amount: Amount(Decimal.zero)));
    }
    return balances;
  }
}
