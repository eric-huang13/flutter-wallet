import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/pages/new_screens/collection_screen.dart';
import 'package:pylons_wallet/pages/new_screens/currency_screen.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewHomeScreen extends StatefulWidget {
  const NewHomeScreen({Key? key}) : super(key: key);

  @override
  State<NewHomeScreen> createState() => NewHomeScreenState();
}

class NewHomeScreenState extends State<NewHomeScreen>
    with SingleTickerProviderStateMixin {
  int tabIndex = 0;
  late TabController _tabController;
  WalletsStore get walletsStore => GetIt.I.get();
  final AssetImage defaultBannerImage =
      const AssetImage('assets/images/Rectangle 156.png');
  final AssetImage defaultAvatarImage = const AssetImage(
      'assets/images/pylons-logo-24x24.png'); // todo: sensible default avatar
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static const AVATAR_FILESIZE_LIMIT =
      1024 * 1024 * 4; // 4MB (this should always divide cleanly)
  static const AVATAR_RESOLUTION_LIMIT_X = 2048;
  static const AVATAR_RESOLUTION_LIMIT_Y = 2048;
  static const AVATAR_URI_KEY = "pylons_avatar_file_uri";
  static const BANNER_FILESIZE_LIMIT =
      1024 * 1024 * 4; // 4MB (this should always divide cleanly)
  static const BANNER_RESOLUTION_LIMIT_X = 2048;
  static const BANNER_RESOLUTION_LIMIT_Y = 2048;
  static const BANNER_URI_KEY = "pylons_banner_file_uri";

  ImageProvider getAvatarImage(SharedPreferences prefs) {
    File? avatarFile;
    final uri = prefs.getString(AVATAR_URI_KEY);
    if (uri != null) {
      avatarFile = File.fromUri(Uri.parse(uri));
    }
    if (avatarFile == null) {
      return defaultAvatarImage;
    } else {
      return FileImage(avatarFile);
    }
  }

  ImageProvider getBannerImage(SharedPreferences prefs) {
    File? bannerFile;
    final uri = prefs.getString(BANNER_URI_KEY);
    if (uri != null) {
      bannerFile = File.fromUri(Uri.parse(uri));
    }
    if (bannerFile == null) {
      return defaultBannerImage;
    } else {
      return FileImage(bannerFile);
    }
  }

  void setAvatarToFile(SharedPreferences prefs, File? file) {
    if (file != null) {
      final bytes =
          file.readAsBytesSync(); // TODO: shouldn't do this synchronously
      if (bytes.length > AVATAR_FILESIZE_LIMIT) {
        showFileSizeError(AVATAR_FILESIZE_LIMIT);
      } else {
        prefs.setString(AVATAR_URI_KEY, file.uri.toString());
      }
    }
  }

  void setBannerToFile(SharedPreferences prefs, File? file) {
    if (file != null) {
      final bytes =
          file.readAsBytesSync(); // TODO: shouldn't do this synchronously
      if (bytes.length > BANNER_FILESIZE_LIMIT) {
        showFileSizeError(BANNER_FILESIZE_LIMIT);
      } else {
        prefs.setString(BANNER_URI_KEY, file.uri.toString());
      }
    }
  }

  void showFileSizeError(int limit) {
    var displayLimit = limit / 1024 / 1024;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("filesize_err_title".tr()),
          content:
              Text('filesize_err'.tr() + displayLimit.toString() + 'mb'.tr()),
          actions: <Widget>[
            TextButton(
              child: Text("close".tr()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  FutureBuilder<SharedPreferences> handleBanner() {
    return FutureBuilder(
        future: _prefs,
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (snapshot.hasData) {
            return Stack(children: [
              Container(height: 270),
              Container(
                  height: 230,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          alignment: FractionalOffset.center,
                          image: getBannerImage(snapshot.requireData)))),
              Positioned(
                  top: 24,
                  left: 16,
                  child: GestureDetector(
                      onTap: () {
                        print("nop");
                      },
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/icons/sort.png'),
                                  fit: BoxFit.scaleDown))))),
              Positioned(
                  top: 24,
                  right: 16,
                  child: GestureDetector(
                      onTap: () {
                        pickImageFromGallery(2048, 2048, 100, context).then((file) {
                          setState(() {
                            setBannerToFile(snapshot.requireData, file);
                          });
                        });
                      },
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/icons/edit.png'),
                                  fit: BoxFit.scaleDown))))),
              Positioned(
                  top: 150,
                  height: 110,
                  left: 16,
                  right: 16,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.indigo,
                          backgroundBlendMode: BlendMode.screen,
                          borderRadius: BorderRadius.circular(12)))),
              Positioned(
                  left: 110,
                  top: 170,
                  child: Text(walletsStore.getWallets().name,
                      style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white))),
              Positioned(
                  left: 110,
                  top: 190,
                  child: GestureDetector(
                      onTap: () {
                        print("nop 3");
                      },
                      behavior: HitTestBehavior.translucent,
                      child: Text("see_profile".tr(),
                          style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white)))),
              Positioned(
                  left: 110,
                  top: 220,
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "${"followers".tr()}  ",
                        style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                    const TextSpan(
                        text: "23",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white))
                  ]))),
              Positioned(
                  left: 200,
                  top: 220,
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "${"following".tr()}  ",
                        style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                    const TextSpan(
                        text: "23",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white))
                  ]))),
              Positioned(
                  left: 30,
                  top: 170,
                  child: GestureDetector(
                      onTap: () {
                        pickImageFromGallery(2048, 2048, 100, context).then((file) {
                          setState(() {
                            setAvatarToFile(snapshot.requireData, file);
                          });
                        });
                      },
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: getAvatarImage(snapshot.requireData),
                                  fit: BoxFit.cover)))))
            ]);
          } else {
            return Container(); // this never happens in production
          }
        });
  }

  final List<Widget> myTabs = <Widget>[
    Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text('nft_collection'.tr(),
          style: const TextStyle(
              fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w500)),
    ),
    Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text('currency'.tr(),
          style: const TextStyle(
              fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w500)),
    ),
  ];

  final List<Widget> _pages = <Widget>[
    const CollectionScreen(),
    const CurrencyScreen()
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController.addListener(_tabSelect);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _tabSelect() {
    setState(() {
      tabIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: SafeArea(
            child: WillPopScope(
          onWillPop: () async => false,
          child: DefaultTabController(
            length: 2,
            initialIndex: tabIndex,
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(318),
                  child: Column(children: [
                    handleBanner(),
                    TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey[700],
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: kPeachDark,
                      labelStyle: const TextStyle(fontSize: 16),
                      tabs: myTabs,
                      padding: const EdgeInsets.only(top: 20),
                    )
                  ])),
              body: TabBarView(
                children: _pages,
              ),
            ),
          ),
        )));
  }
}
