import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/pylons_history_card.dart';
import 'package:pylons_wallet/entities/activity.dart';
import 'package:pylons_wallet/localstorage/activity_database.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

class HomeActivityWidget extends StatefulWidget {
  const HomeActivityWidget({Key? key}) : super(key: key);

  @override
  State<HomeActivityWidget> createState() => _HomeActivityWidgetState();
}

class _HomeActivityWidgetState extends State<HomeActivityWidget> {
  final walletsStore = GetIt.I.get<WalletsStore>();
  List<Activity> activities = [];

  @override
  void initState() {
    super.initState();
    //loadData();
    ActivityDatabase.get().addActivity(Activity(
        action: ActionType.actionCreateRecipe,
        username: "1",
        cookbookID: "2",
        recipeID: "3",
        itemName: "4",
        itemDesc: "5",
        itemUrl: "6"
    )).then((value) => {
      ActivityDatabase.get().getAllActivities().then((value) => {
        value.forEach((element) {
          print(element.username);
          print(element.cookbookID);
          print(element.recipeID);
        })
      })
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.only(top: 10.0),
            child: Center(
              child: PylonsHistoryCard(activity: activities[index]),
            ),
          );
        },
        childCount: activities.length,
      ),
    );
  }
  
  //retrieve current user's recent activity
  Future<void> loadData() async {
    activities.clear();
    ActivityDatabase.get().getAllActivities().then((elems)=>
      setState((){
        elems.forEach((element) {
          print(element.username);
          print(element.cookbookID);
          print(element.recipeID);
          activities.add(element);
        });
      })
    );
    
  }

}
