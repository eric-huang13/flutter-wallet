/// Recipe : {"cookbookID":"Easel_autocookbook_pylo149haucpqld30pksrzqyff67prswul9vmmle27v","ID":"pylo149haucpqld30pksrzqyff67prswul9vmmle27v_2021_10_18_11_40_28","nodeVersion":"","name":"title title","description":"aaaaaaaaassasssssssssss\n","version":"v1.0.0","coinInputs":[{"coins":[{"denom":"pylon","amount":"12"}]}],"itemInputs":[],"entries":{"coinOutputs":[],"itemOutputs":[{"ID":"title_title","doubles":[{"key":"Residual","rate":"0.000000000000000001","weightRanges":[{"lower":"2000000000000000000.000000000000000000","upper":"2000000000000000000.000000000000000000","weight":"1"}],"program":"1"}],"longs":[{"key":"Quantity","rate":"0.000000000000000001","weightRanges":[{"lower":"23","upper":"23","weight":"1"}],"program":"1"},{"key":"Width","rate":"0.000000000000000001","weightRanges":[{"lower":"1920","upper":"1920","weight":"1"}],"program":""},{"key":"Height","rate":"0.000000000000000001","weightRanges":[{"lower":"1288","upper":"1288","weight":"1"}],"program":"1"}],"strings":[{"key":"Name","rate":"0.000000000000000001","value":"title title","program":""},{"key":"NFT_URL","rate":"0.000000000000000001","value":"https://www.imagesource.com/wp-content/uploads/2019/06/Rio.jpg","program":""},{"key":"Description","rate":"0.000000000000000001","value":"aaaaaaaaassasssssssssss\n","program":""},{"key":"Currency","rate":"0.000000000000000001","value":"pylon","program":""},{"key":"Price","rate":"0.000000000000000001","value":"12","program":"1"}],"mutableStrings":[],"transferFee":[],"tradePercentage":"0.000000000000000001","quantity":"23","amountMinted":"2","tradeable":true}],"itemModifyOutputs":[]},"outputs":[{"entryIDs":["title_title"],"weight":"1"}],"blockInterval":"1","enabled":true,"extraInfo":"\"\""}

class RecipeJson {
  late Recipe recipe;

  RecipeJson({
    required this.recipe});

  RecipeJson.fromJson(Map<String, dynamic> json) {
    recipe = Recipe.fromJson(json['Recipe'] as Map<String, dynamic>);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['Recipe'] = recipe.toJson();
    return map;
  }

}

/// cookbookID : "Easel_autocookbook_pylo149haucpqld30pksrzqyff67prswul9vmmle27v"
/// ID : "pylo149haucpqld30pksrzqyff67prswul9vmmle27v_2021_10_18_11_40_28"
/// nodeVersion : ""
/// name : "title title"
/// description : "aaaaaaaaassasssssssssss\n"
/// version : "v1.0.0"
/// coinInputs : [{"coins":[{"denom":"pylon","amount":"12"}]}]
/// itemInputs : []
/// entries : {"coinOutputs":[],"itemOutputs":[{"ID":"title_title","doubles":[{"key":"Residual","rate":"0.000000000000000001","weightRanges":[{"lower":"2000000000000000000.000000000000000000","upper":"2000000000000000000.000000000000000000","weight":"1"}],"program":"1"}],"longs":[{"key":"Quantity","rate":"0.000000000000000001","weightRanges":[{"lower":"23","upper":"23","weight":"1"}],"program":"1"},{"key":"Width","rate":"0.000000000000000001","weightRanges":[{"lower":"1920","upper":"1920","weight":"1"}],"program":""},{"key":"Height","rate":"0.000000000000000001","weightRanges":[{"lower":"1288","upper":"1288","weight":"1"}],"program":"1"}],"strings":[{"key":"Name","rate":"0.000000000000000001","value":"title title","program":""},{"key":"NFT_URL","rate":"0.000000000000000001","value":"https://www.imagesource.com/wp-content/uploads/2019/06/Rio.jpg","program":""},{"key":"Description","rate":"0.000000000000000001","value":"aaaaaaaaassasssssssssss\n","program":""},{"key":"Currency","rate":"0.000000000000000001","value":"pylon","program":""},{"key":"Price","rate":"0.000000000000000001","value":"12","program":"1"}],"mutableStrings":[],"transferFee":[],"tradePercentage":"0.000000000000000001","quantity":"23","amountMinted":"2","tradeable":true}],"itemModifyOutputs":[]}
/// outputs : [{"entryIDs":["title_title"],"weight":"1"}]
/// blockInterval : "1"
/// enabled : true
/// extraInfo : "\"\""

class Recipe {
  late String cookbookID;
  late String id;
  late String nodeVersion;
  late String name;
  late String description;
  late String version;
  late List<CoinInputs> coinInputs;
  late List<dynamic> itemInputs;
  late Entries entries;
  late List<Outputs> outputs;
  late String blockInterval;
  late bool enabled;
  late String extraInfo;

  Recipe({
    required this.cookbookID,
    required this.id,
    required this.nodeVersion,
    required this.name,
    required this.description,
    required this.version,
    required this.coinInputs,
    required this.itemInputs,
    required this.entries,
    required this.outputs,
    required this.blockInterval,
    required this.enabled,
    required this.extraInfo,});

  Recipe.fromJson(Map<String, dynamic> json) {
    cookbookID = json['cookbookID'] as String;
    id = json['ID'] as String;
    nodeVersion = json['nodeVersion'] as String;
    name = json['name'] as String;
    description = json['description'] as String;
    version = json['version'] as String;
    if (json['coinInputs'] != null) {
      coinInputs = [];
      json['coinInputs'].forEach((v) {
        coinInputs.add(CoinInputs.fromJson(v));
      });
    }
    if (json['itemInputs'] != null) {
      itemInputs = [];
      json['itemInputs'].forEach((v) {
        // itemInputs?.add(dynamic.fromJson(v));
      });
    }
    entries = Entries.fromJson(json['entries']);
    if (json['outputs'] != null) {
      outputs = [];
      json['outputs'].forEach((v) {
        outputs.add(Outputs.fromJson(v));
      });
    }
    blockInterval = json['blockInterval'] as String;
    enabled = json['enabled'] as bool;
    extraInfo = json['extraInfo'] as String;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['cookbookID'] = cookbookID;
    map['ID'] = id;
    map['nodeVersion'] = nodeVersion;
    map['name'] = name;
    map['description'] = description;
    map['version'] = version;
    map['coinInputs'] = coinInputs.map((v) => v.toJson()).toList();
    map['itemInputs'] = itemInputs.map((v) => v.toJson()).toList();
    map['entries'] = entries.toJson();
    map['outputs'] = outputs.map((v) => v.toJson()).toList();
    map['blockInterval'] = blockInterval;
    map['enabled'] = enabled;
    map['extraInfo'] = extraInfo;
    return map;
  }

}

/// entryIDs : ["title_title"]
/// weight : "1"

class Outputs {
  late List<String> entryIDs;
  late String weight;

  Outputs({
    required this.entryIDs,
    required this.weight});

  Outputs.fromJson(dynamic json) {
    entryIDs = (json['entryIDs'] as List).cast<String>();
    weight = json['weight'] as String;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['entryIDs'] = entryIDs;
    map['weight'] = weight;
    return map;
  }

}

/// coinOutputs : []
/// itemOutputs : [{"ID":"title_title","doubles":[{"key":"Residual","rate":"0.000000000000000001","weightRanges":[{"lower":"2000000000000000000.000000000000000000","upper":"2000000000000000000.000000000000000000","weight":"1"}],"program":"1"}],"longs":[{"key":"Quantity","rate":"0.000000000000000001","weightRanges":[{"lower":"23","upper":"23","weight":"1"}],"program":"1"},{"key":"Width","rate":"0.000000000000000001","weightRanges":[{"lower":"1920","upper":"1920","weight":"1"}],"program":""},{"key":"Height","rate":"0.000000000000000001","weightRanges":[{"lower":"1288","upper":"1288","weight":"1"}],"program":"1"}],"strings":[{"key":"Name","rate":"0.000000000000000001","value":"title title","program":""},{"key":"NFT_URL","rate":"0.000000000000000001","value":"https://www.imagesource.com/wp-content/uploads/2019/06/Rio.jpg","program":""},{"key":"Description","rate":"0.000000000000000001","value":"aaaaaaaaassasssssssssss\n","program":""},{"key":"Currency","rate":"0.000000000000000001","value":"pylon","program":""},{"key":"Price","rate":"0.000000000000000001","value":"12","program":"1"}],"mutableStrings":[],"transferFee":[],"tradePercentage":"0.000000000000000001","quantity":"23","amountMinted":"2","tradeable":true}]
/// itemModifyOutputs : []

class Entries {
  late List<dynamic> coinOutputs;
  late List<ItemOutputs> itemOutputs;
  late List<dynamic> itemModifyOutputs;

  Entries({
    required this.coinOutputs,
    required this.itemOutputs,
    required this.itemModifyOutputs,});

  Entries.fromJson(dynamic json) {
    if (json['coinOutputs'] != null) {
      coinOutputs = [];
      json['coinOutputs'].forEach((v) {
        // coinOutputs.add(dynamic.fromJson(v));
      });
    }
    if (json['itemOutputs'] != null) {
      itemOutputs = [];
      json['itemOutputs'].forEach((v) {
        itemOutputs.add(ItemOutputs.fromJson(v));
      });
    }
    if (json['itemModifyOutputs'] != null) {
      itemModifyOutputs = [];
      json['itemModifyOutputs'].forEach((v) {
        // itemModifyOutputs.add(dynamic.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['coinOutputs'] = coinOutputs.map((v) => v.toJson()).toList();
    map['itemOutputs'] = itemOutputs.map((v) => v.toJson()).toList();
    map['itemModifyOutputs'] = itemModifyOutputs.map((v) => v.toJson()).toList();
    return map;
  }

}

/// ID : "title_title"
/// doubles : [{"key":"Residual","rate":"0.000000000000000001","weightRanges":[{"lower":"2000000000000000000.000000000000000000","upper":"2000000000000000000.000000000000000000","weight":"1"}],"program":"1"}]
/// longs : [{"key":"Quantity","rate":"0.000000000000000001","weightRanges":[{"lower":"23","upper":"23","weight":"1"}],"program":"1"},{"key":"Width","rate":"0.000000000000000001","weightRanges":[{"lower":"1920","upper":"1920","weight":"1"}],"program":""},{"key":"Height","rate":"0.000000000000000001","weightRanges":[{"lower":"1288","upper":"1288","weight":"1"}],"program":"1"}]
/// strings : [{"key":"Name","rate":"0.000000000000000001","value":"title title","program":""},{"key":"NFT_URL","rate":"0.000000000000000001","value":"https://www.imagesource.com/wp-content/uploads/2019/06/Rio.jpg","program":""},{"key":"Description","rate":"0.000000000000000001","value":"aaaaaaaaassasssssssssss\n","program":""},{"key":"Currency","rate":"0.000000000000000001","value":"pylon","program":""},{"key":"Price","rate":"0.000000000000000001","value":"12","program":"1"}]
/// mutableStrings : []
/// transferFee : []
/// tradePercentage : "0.000000000000000001"
/// quantity : "23"
/// amountMinted : "2"
/// tradeable : true

class ItemOutputs {
  late String id;
  late List<Doubles> doubles;
  late List<Longs> longs;
  late List<Strings> strings;
  late List<dynamic> mutableStrings;
  late List<dynamic> transferFee;
  late String tradePercentage;
  late String quantity;
  late String amountMinted;
  late bool tradeable;

  ItemOutputs({
    required this.id,
    required this.doubles,
    required this.longs,
    required this.strings,
    required this.mutableStrings,
    required this.transferFee,
    required this.tradePercentage,
    required this.quantity,
    required this.amountMinted,
    required this.tradeable,});

  ItemOutputs.fromJson(dynamic json) {
    id = json['ID'] as String;
    if (json['doubles'] != null) {
      doubles = [];
      json['doubles'].forEach((v) {
        doubles.add(Doubles.fromJson(v));
      });
    }
    if (json['longs'] != null) {
      longs = [];
      json['longs'].forEach((v) {
        longs.add(Longs.fromJson(v));
      });
    }
    if (json['strings'] != null) {
      strings = [];
      json['strings'].forEach((v) {
        strings.add(Strings.fromJson(v));
      });
    }
    if (json['mutableStrings'] != null) {
      mutableStrings = [];
      json['mutableStrings'].forEach((v) {
        // mutableStrings.add(dynamic.fromJson(v));
      });
    }
    if (json['transferFee'] != null) {
      transferFee = [];
      json['transferFee'].forEach((v) {
        // transferFee.add(dynamic.fromJson(v));
      });
    }
    tradePercentage = json['tradePercentage'] as String;
    quantity = json['quantity'] as String;
    amountMinted = json['amountMinted'] as String;
    tradeable = json['tradeable'] as bool;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['ID'] = id;
    map['doubles'] = doubles.map((v) => v.toJson()).toList();
    map['longs'] = longs.map((v) => v.toJson()).toList();
    map['strings'] = strings.map((v) => v.toJson()).toList();
    map['mutableStrings'] = mutableStrings.map((v) => v.toJson()).toList();
    map['transferFee'] = transferFee.map((v) => v.toJson()).toList();
    map['tradePercentage'] = tradePercentage;
    map['quantity'] = quantity;
    map['amountMinted'] = amountMinted;
    map['tradeable'] = tradeable;
    return map;
  }

}

/// key : "Name"
/// rate : "0.000000000000000001"
/// value : "title title"
/// program : ""

class Strings {
  late String key;
  late String? rate;
  late String value;
  late String program;

  Strings({
    required this.key,
    required this.rate,
    required this.value,
    required this.program,});

  Strings.fromJson(dynamic json) {
    key = json['key'] as String;
    rate = json['rate'] as String?;
    value = json['value'] as String;
    program = json['program'] as String;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['key'] = key;
    map['rate'] = rate;
    map['value'] = value;
    map['program'] = program;
    return map;
  }

}

/// key : "Quantity"
/// rate : "0.000000000000000001"
/// weightRanges : [{"lower":"23","upper":"23","weight":"1"}]
/// program : "1"

class Longs {
  late String key;
  late String? rate;
  late List<WeightRanges> weightRanges;
  late String program;

  Longs({
    required this.key,
    required this.rate,
    required this.weightRanges,
    required this.program,});

  Longs.fromJson(dynamic json) {
    key = json['key'] as String;
    rate = json['rate'] as String;
    if (json['weightRanges'] != null) {
      weightRanges = [];
      json['weightRanges'].forEach((v) {
        weightRanges.add(WeightRanges.fromJson(v));
      });
    }
    program = json['program'] as String;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['key'] = key;
    map['rate'] = rate;
    map['weightRanges'] = weightRanges.map((v) => v.toJson()).toList();
    map['program'] = program;
    return map;
  }

}

/// lower : "23"
/// upper : "23"
/// weight : "1"

class WeightRanges {
  late String lower;
  late String upper;
  late String weight;

  WeightRanges({
    required this.lower,
    required this.upper,
    required this.weight,});

  WeightRanges.fromJson(dynamic json) {
    lower = json['lower'] as String;
    upper = json['upper'] as String;
    weight = json['weight'] as String;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['lower'] = lower;
    map['upper'] = upper;
    map['weight'] = weight;
    return map;
  }

}

/// key : "Residual"
/// rate : "0.000000000000000001"
/// weightRanges : [{"lower":"2000000000000000000.000000000000000000","upper":"2000000000000000000.000000000000000000","weight":"1"}]
/// program : "1"

class Doubles {
  late String key;
  late String rate;
  late List<WeightRanges> weightRanges;
  late String program;

  Doubles({
    required this.key,
    required this.rate,
    required this.weightRanges,
    required this.program,});

  Doubles.fromJson(dynamic json) {
    key = json['key'] as String;
    rate = json['rate'] as String;
    if (json['weightRanges'] != null) {
      weightRanges = [];
      json['weightRanges'].forEach((v) {
        weightRanges.add(WeightRanges.fromJson(v));
      });
    }
    program = json['program'] as String;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['key'] = key;
    map['rate'] = rate;
    map['weightRanges'] = weightRanges.map((v) => v.toJson()).toList();
    map['program'] = program;
    return map;
  }

}


/// coins : [{"denom":"pylon","amount":"12"}]

class CoinInputs {
  late List<Coins> coins;

  CoinInputs({
    required this.coins,});

  CoinInputs.fromJson(dynamic json) {
    if (json['coins'] != null) {
      coins = [];
      json['coins'].forEach((v) {
        coins.add(Coins.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['coins'] = coins.map((v) => v.toJson()).toList();
    return map;
  }

}

/// denom : "pylon"
/// amount : "12"

class Coins {
  late String denom;
  late String amount;

  Coins({
    required this.denom,
    required this.amount});

  Coins.fromJson(dynamic json) {
    denom = json['denom'] as String;
    amount = json['amount'] as String;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['denom'] = denom;
    map['amount'] = amount;
    return map;
  }

}


extension RecipeValues on RecipeJson {
  String get name => recipe.entries.itemOutputs.first.strings.firstWhere((e) => e.key == "Name", orElse: ()=> Strings(key: "", value: "", program: "", rate: "")).value;

  String get nftUrl => recipe.entries.itemOutputs.first.strings.firstWhere((e) => e.key == "NFT_URL", orElse: ()=> Strings(key: "", value: "", program: "", rate: "")).value;

  String get description => recipe.entries.itemOutputs.first.strings.firstWhere((e) => e.key == "Description", orElse: ()=> Strings(key: "", value: "", program: "", rate: "")).value;

  String get currency => recipe.entries.itemOutputs.first.strings.firstWhere((e) => e.key == "Currency", orElse: ()=> Strings(key: "", value: "", program: "", rate: "")).value;

  String get price => recipe.entries.itemOutputs.first.strings.firstWhere((e) => e.key == "Price", orElse: ()=> Strings(key: "", value: "", program: "", rate: "")).value;

  String get width => recipe.entries.itemOutputs.first.longs.firstWhere((e) => e.key == "Width").weightRanges.first.upper;

  String get height => recipe.entries.itemOutputs.first.longs.firstWhere((e) => e.key == "Height").weightRanges.first.upper;

}