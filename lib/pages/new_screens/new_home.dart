import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/pages/new_screens/collection_screen.dart';
import 'package:pylons_wallet/pages/new_screens/currency_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class NewHomeScreen extends StatefulWidget {
  NewHomeScreen({Key? key}) : super(key: key);

  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> with SingleTickerProviderStateMixin {

  int tabIndex = 0;
  late TabController _tabController;

  final List<Widget> myTabs = <Widget>[
    Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text('currency'.tr()),
    ),
    Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text('nft_collection'.tr()),
    ),
  ];

  List<Widget> _pages = <Widget>[CurrencyScreen(), CollectionScreen()];


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
        child: DefaultTabController(
          length: 2,
          initialIndex: tabIndex,
          child: Scaffold(
            appBar: TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[700],
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: kPeachDark,
              labelStyle: const TextStyle(fontSize: 16),
              tabs: myTabs,
              padding: const EdgeInsets.only(top: 20),
            ),
            body: TabBarView(
              // physics: NeverScrollableScrollPhysics(),
              children: _pages,
            ),
          ),
        ),
      ),
    );
  }
}
