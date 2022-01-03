import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  // stripe token generated from stripe backend server
  String StripeToken = '';

  // stripe connected account id retrieved from stripe backend server
  String StripeAccount = '';

  /// This method load data from local storage
  Future<void> loadData();

  /// This method save data to local storage
  Future<void> saveData();

  /// This method will clear the data on IOS reinstall
  Future<void> clearDataOnIosUnInstall();
}

class LocalDataSourceImp implements LocalDataSource {
  SharedPreferences sharedPreferences;
  LocalDataSourceImp(this.sharedPreferences);

  @override
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    StripeToken = prefs.getString('StripeToken') ?? "";
    StripeAccount = prefs.getString('StripeAccount') ?? "";
  }

  @override
  Future<void> saveData() async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();
    // set value
    prefs.setString('StripeToken', StripeToken);
    prefs.setString('StripeAccount', StripeAccount);
  }

  @override
  String StripeToken = '';

  @override
  String StripeAccount = '';

  @override
  Future<void> clearDataOnIosUnInstall() async {
    if (Platform.isAndroid) {
      return SynchronousFuture('');
    }

    if ((sharedPreferences.getString('first_run') ?? "true") == "true") {
      const storage = FlutterSecureStorage();

      await storage.deleteAll();

      sharedPreferences.setString('first_run', "false");
    }
  }
}
