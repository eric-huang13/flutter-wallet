import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/pylons_history_card.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

class HomeActivityWidget extends StatefulWidget {
  const HomeActivityWidget({Key? key}) : super(key: key);

  @override
  State<HomeActivityWidget> createState() => _HomeActivityWidgetState();
}

class _HomeActivityWidgetState extends State<HomeActivityWidget> {
  @override
  Widget build(BuildContext context) {
    final walletsStore = GetIt.I.get<WalletsStore>();


    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.only(top: 10.0),
            child: const Center(
              child: PylonsHistoryCard(),
            ),
          );
        },
        childCount: 20,
      ),
    );
  }
}
