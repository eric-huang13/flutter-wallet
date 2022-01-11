import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/buttons/add_friend_button.dart';
import 'package:pylons_wallet/pages/new_screens/new_home.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transaction_signing_gateway/model/wallet_public_info.dart';

import '../../../mocks/mock_wallet_store.dart';
import '../../helpers/size_extensions.dart';

void main() {
  testWidgets('Test banner/avatar loading/rejection', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final mockWalletStore = MockWalletStore();
    GetIt.I.registerSingleton<WalletsStore>(mockWalletStore);
    PylonsApp.currentWallet = const WalletPublicInfo(name: 'name', publicAddress: '', walletId: '', chainId: '');
    final homeScreen = find.byType(NewHomeScreen);
    await tester.setScreenSize();
    await tester.testAppForWidgetTesting(const Material(child: NewHomeScreen()));
    expect(homeScreen, findsOneWidget);
    final NewHomeScreenState homeState = tester.state(homeScreen);

    print('Expect default banner/avatar, since no extant values in sharedPreferences');
    expect(homeState.getBannerImage(prefs), homeState.defaultBannerImage);
    expect(homeState.getAvatarImage(prefs), homeState.defaultAvatarImage);

    print('Set banner/avatar to legal values; expect those images now');
    homeState.setAvatarToFile(prefs, File('assets/images/testing/low_res_low_filesize.png'));
    homeState.setBannerToFile(prefs, File('assets/images/testing/low_res_low_filesize.png'));
    expect(homeState.getBannerImage(prefs), isNot(homeState.defaultBannerImage));
    expect(homeState.getAvatarImage(prefs), isNot(homeState.defaultAvatarImage));

    print('Set banner/avatar to illegal (high-filesize) values; expect unchanged');
    var bannerToExpect = homeState.getBannerImage(prefs);
    var avatarToExpect = homeState.getAvatarImage(prefs);
    homeState.setAvatarToFile(prefs, File('assets/images/testing/low_res_high_filesize.png'));
    homeState.setBannerToFile(prefs, File('assets/images/testing/low_res_high_filesize.png'));
    expect(homeState.getBannerImage(prefs), bannerToExpect);
    expect(homeState.getAvatarImage(prefs), avatarToExpect);

    await tester.pumpAndSettle();
  });
}
