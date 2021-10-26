enum ActionType {
  actionUnknonwn,
  actionCreateRecipe,
  actionMint,
  actionPurchase,
  // further types
}

class ActionTypeFactory {
  static final Map<String, ActionType> _stringMap = {
    'unknown': ActionType.actionUnknonwn,
    'created': ActionType.actionCreateRecipe,
    'minted': ActionType.actionMint,
    'purchased': ActionType.actionPurchase,
  };

  static ActionType fromString(String string) {
    return _stringMap[string] ?? ActionType.actionUnknonwn;
  }

  static String itemToString(ActionType item) {
    return _stringMap.keys
        .firstWhere((key) => _stringMap[key] == item, orElse: () => 'unknown');
  }
}

class Activity {
  static final db_id = "id";
  static final db_username = "username";
  static final db_action = "action";
  static final db_item_name = "itemname";
  static final db_item_url = "itemurl";
  static final db_item_desc = "itemdesc";
  static final db_item_cookbookid = "cookbookid";
  static final db_item_recipeid = "recipeid";
  static final db_item_id = "itemid";
  static final db_timestamp = "timestamp";

  String username = "",
      itemName = "",
      itemUrl = "",
      itemDesc = "",
      cookbookID = "",
      recipeID = "",
      itemID = "",
      timestamp = "";
  ActionType action= ActionType.actionUnknonwn;
  int id = 0;
  Activity({
    id,
    username,
    action,
    itemName,
    itemUrl,
    itemDesc,
    cookbookID,
    recipeID,
    itemID,
    timestamp,
  });

  String actionString(){
    return ActionTypeFactory.itemToString(action);
  }

  Activity.fromMap(Map<String, dynamic> map) : this(
      id: map[db_id],
      username: map[db_username],
      action: ActionTypeFactory.fromString(map[db_action].toString()),
      itemName: map[db_item_name],
      itemUrl: map[db_item_url],
      itemDesc: map[db_item_cookbookid],
      cookbookID: map[db_item_cookbookid],
      recipeID: map[db_item_recipeid],
      timestamp: map[db_timestamp]
  );

  Map<String, dynamic> toMap() {
    return {
      db_id: id,
      db_username: username,
      db_action: action,
      db_item_name: itemName,
      db_item_url: itemUrl,
      db_item_desc: itemDesc,
      db_item_cookbookid: cookbookID,
      db_item_recipeid: recipeID,
      db_timestamp: timestamp
    };
  }
}
