import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  /// This method will clear the data on IOS reinstall
  Future<void> clearDataOnIosUnInstall();
}

class LocalDataSourceImp implements LocalDataSource {
  SharedPreferences sharedPreferences;

  LocalDataSourceImp(this.sharedPreferences);

  @override
  Future<void> clearDataOnIosUnInstall() async {
    if (Platform.isAndroid) {
      return SynchronousFuture('');
    }

    if (sharedPreferences.getBool('first_run') ?? true) {
      const storage = FlutterSecureStorage();

      await storage.deleteAll();

      sharedPreferences.setBool('first_run', false);
    }
  }
}
