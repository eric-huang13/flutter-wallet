import 'coins_json.dart';

/// coins : [{"denom":"pylon","amount":"12"}]

class CoinInputs {
  late List<Coins> coins;

  CoinInputs({
    required this.coins,
  });

  CoinInputs.fromJson(dynamic json) {
    if (json['coins'] != null) {
      coins = [];
      json['coins'].forEach((v) {
        coins.add(Coins.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['coins'] = coins.map((v) => v.toJson()).toList();
    return map;
  }
}
