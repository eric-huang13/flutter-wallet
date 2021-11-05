

import 'package:pylons_wallet/model/weightranges_json.dart';

/// key : "Quantity"
/// weightRanges : [{"lower":"23","upper":"23","weight":"1"}]
/// program : "1"

class Longs {
  late String key;
  late List<WeightRanges> weightRanges;
  late String program;

  Longs({
    required this.key,
    required this.weightRanges,
    required this.program,
  });

  Longs.fromJson(dynamic json) {
    key = json['key'] as String;
    if (json['weightRanges'] != null) {
      weightRanges = [];
      json['weightRanges'].forEach((v) {
        weightRanges.add(WeightRanges.fromJson(v));
      });
    }
    program = json['program'] as String;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    map['weightRanges'] = weightRanges.map((v) => v.toJson()).toList();
    map['program'] = program;
    return map;
  }
}