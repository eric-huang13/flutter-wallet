import 'dart:io';


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/utils/dependency_injection/dependency_injection.dart' as di;
import 'package:pylons_wallet/utils/dependency_injection/dependency_injection.dart';
import 'package:pylons_wallet/utils/third_party_services/local_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //HttpOverrides.global = MyHttpOverrides();
  await EasyLocalization.ensureInitialized();
  // Read the values from .env file
  await dotenv.load(fileName: "env/.dev_env");
  await di.init();

  await GetIt.I.allReady();
  await sl<LocalDataSource>().clearDataOnIosUnInstall();


  runApp(
    EasyLocalization(supportedLocales: const [Locale('en'), Locale('ru')], path: 'i18n', fallbackLocale: const Locale('en'), saveLocale: false, useOnlyLangCode: true, child: PylonsApp()),
  );
}



class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
