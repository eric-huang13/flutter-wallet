
/// entryIDs : ["title_title"]
/// weight : "1"

class Outputs {
  late List<String> entryIDs;
  late String weight;

  Outputs({required this.entryIDs, required this.weight});

  Outputs.fromJson(dynamic json) {
    entryIDs = (json['entryIDs'] as List).cast<String>();
    weight = json['weight'] as String;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['entryIDs'] = entryIDs;
    map['weight'] = weight;
    return map;
  }
}