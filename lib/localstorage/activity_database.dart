import 'package:path/path.dart';
import 'package:pylons_wallet/entities/activity.dart';
import 'package:sqflite/sqflite.dart';

class ActivityDatabase {
  static final ActivityDatabase _database = ActivityDatabase._internal();

  final String tableName = "activities";
  late Database db;
  bool didInit = false;

  static ActivityDatabase get() {
    return _database;
  }

  ActivityDatabase._internal();

  Future<Database> _getDb() async {
    if (!didInit) {
      await _init();
    }
    return db;
  }

  Future init() async {
    return await _init();
  }

  Future _init() async {
    // Get a location using path_provider
    final databasePath = await getDatabasesPath();
    //String path = join(documentsDirectory.path, "pylon.db");
    final path = join(databasePath, "pylon.db");
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute("CREATE TABLE $tableName ("
          "${Activity.db_id} INTEGER PRIMARY KEY AUTOINCREMENT,"
          "${Activity.db_username} TEXT,"
          "${Activity.db_action} TEXT,"
          "${Activity.db_item_name} TEXT,"
          "${Activity.db_item_url} TEXT,"
          "${Activity.db_item_desc} TEXT,"
          "${Activity.db_item_cookbookid} TEXT,"
          "${Activity.db_item_recipeid} TEXT,"
          "${Activity.db_item_id} TEXT,"
          "${Activity.db_timestamp} TEXT"
          ")");
    });
    didInit = true;
  }

  /// Get a book by its id, if there is not entry for that ID, returns null.
  Future<Activity?> getActivity(String id) async {
    final db = await _getDb();
    final result = await db.rawQuery(
        'SELECT * FROM $tableName WHERE ${Activity.db_id} = "$id" LIMIT 1');
    if (result.isEmpty) {
      return null;
    }
    return Activity.fromMap(result[0]);
  }

  /// Get all books with ids, will return a list with all the books found
  Future<List<Activity>> getActivities(List<String> ids) async {
    final db = await _getDb();
    // Building SELECT * FROM TABLE WHERE ID IN (id1, id2, ..., idn)
    final idsString = ids.map((it) => '"$it"').join(',');
    final result = await db.rawQuery(
        'SELECT * FROM $tableName WHERE ${Activity.db_id} IN ($idsString)');
    final activities = <Activity>[];
    for (final Map<String, dynamic> item in result) {
      activities.add(Activity.fromMap(item));
    }
    return activities;
  }

  Future<List<Activity>> getAllActivities() async {
    final db = await _getDb();
    final result = await db
        .rawQuery('SELECT * FROM $tableName ORDER BY ${Activity.db_id} DESC');
    final activities = <Activity>[];
    for (final Map<String, dynamic> item in result) {
      activities.add(Activity.fromMap(item));
    }
    return activities;
  }

  //TODO escape not allowed characters eg. ' " '
  /// Inserts or replaces the book.
  Future updateActivity(Activity activity) async {
    final db = await _getDb();
    await db.rawInsert(
        'INSERT OR REPLACE INTO '
        '$tableName(${Activity.db_id}, ${Activity.db_username}, ${Activity.db_action},  ${Activity.db_item_name}, ${Activity.db_item_url}, ${Activity.db_item_desc}, ${Activity.db_item_cookbookid}, ${Activity.db_item_recipeid}, ${Activity.db_item_id}, ${Activity.db_timestamp})'
        ' VALUES(?, ?, ?, ?, ?, ?, ?, ?)',
        [
          activity.id,
          activity.username,
          activity.actionString(),
          activity.itemName,
          activity.itemUrl,
          activity.itemDesc,
          activity.cookbookID,
          activity.recipeID,
          activity.itemID,
          activity.timestamp,
        ]);
  }

  Future addActivity(Activity activity) async {
    final db = await _getDb();
    await db.rawInsert(
        'INSERT INTO '
        '$tableName(${Activity.db_username}, ${Activity.db_action}, ${Activity.db_item_name}, ${Activity.db_item_url}, ${Activity.db_item_desc}, ${Activity.db_item_cookbookid}, ${Activity.db_item_recipeid}, ${Activity.db_item_id}, ${Activity.db_timestamp})'
        ' VALUES(?, ?, ?,  ?, ?, ?, ?, ?, ?)',
        [
          activity.username,
          activity.actionString(),
          activity.itemName,
          activity.itemUrl,
          activity.itemDesc,
          activity.cookbookID,
          activity.recipeID,
          activity.itemID,
          activity.timestamp,
        ]);
  }

  Future close() async {
    final db = await _getDb();
    return db.close();
  }
}
