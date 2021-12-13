import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  String StripeToken = '';
  bool StripeAccountRegistered = false;
  String StripeAccount = '';
  Future<void> loadData();
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
    StripeAccountRegistered = prefs.getBool('StripeAccountRegistered') ?? false;
  }

  @override
  Future<void> saveData() async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();
    // set value
    prefs.setString('StripeToken', StripeToken);
    prefs.setString('StripeAccount', StripeAccount);
    prefs.setBool('StripeAccountRegistered', StripeAccountRegistered);
  }

  @override
  String StripeToken = '';

  @override
  bool StripeAccountRegistered = false;

  @override
  String StripeAccount = '';

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
