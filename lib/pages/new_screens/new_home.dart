import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/pages/new_screens/collection_screen.dart';

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
      child: Text('Moneys'),
    ),
    Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text('NFT Collection'),
    ),
  ];

  List<Widget> _pages = <Widget>[Text("Moneys"), CollectionScreen()];


  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController.addListener(_tabSelect);
  }

  void _tabSelect() {
    setState(() {
      tabIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // return Container(
    //   color: Colors.white,
    //   child: SafeArea(
    //     child: Scaffold(
    //       body: Column(
    //         children: [
    //           const VerticalSpace(20),
    //           Container(
    //             decoration: const BoxDecoration(
    //               border: Border(bottom: BorderSide(color: Colors.grey))
    //             ),
    //             child: TabBar(
    //               controller: _tabController,
    //               labelColor: Colors.black,
    //               unselectedLabelColor: Colors.grey[700],
    //               indicatorSize: TabBarIndicatorSize.tab,
    //               indicatorColor: kPeachDark,
    //               labelStyle: const TextStyle(fontSize: 16),
    //               tabs: myTabs,
    //               labelPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
    //             ),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
    //           child: _pages[tabIndex],
    //           )
    //         ],
    //       )
    //     ),
    //   ),
    // );

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
