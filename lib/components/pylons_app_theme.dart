import 'package:cosmos_ui_components/cosmos_theme.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/constants/constants.dart';

class PylonsAppTheme extends CosmosThemeData {
  static const TextStyle HOME_TITLE = TextStyle(fontFamily: 'Inter', fontSize: 22);
  static const TextStyle HOME_LABEL = TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.grey);

  static const IconThemeData ICON_THEME_ENABLED = IconThemeData(color: Colors.indigo, size: 14);
  static const IconThemeData ICON_THEME_DISABLED = IconThemeData(color: Colors.white70, size: 14);



  static Color cardBackground = const Color(
      0x80C4C4C4);

  ThemeData buildAppTheme() {
    return ThemeData(
        scaffoldBackgroundColor: Colors.white,
        disabledColor: Colors.grey,
        dividerColor: Colors.grey,
        primarySwatch: Colors.blue,
        primaryColor: kBlue,
        fontFamily: 'Inter',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: kBlue,
        ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'Inter'),
          headline2: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, fontFamily: 'Inter', fontStyle: FontStyle.normal),
          subtitle1: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
          subtitle2: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Inter'),
          bodyText1: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, fontFamily: 'Inter'),
          headline5: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, fontFamily: 'Inter', color: kBlue)
        ));
  }
}
