enum actionType {
  actionMint,
  actionPurchase,
  // further types
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

  late String id, username, action, itemName, itemUrl, itemDesc, cookbookID,
      recipeID, itemID, timestamp;

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

  Activity.fromMap(Map<String, dynamic> map) : this(
      id: map[db_id],
      username: map[db_username],
      action: map[db_action],
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
