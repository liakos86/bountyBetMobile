import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserAward.dart';
import 'package:flutter_app/models/context/AppContext.dart';
import 'package:flutter_app/utils/MockUtils.dart';
import 'package:flutter_app/utils/client/HttpActionsClient.dart';
import 'package:flutter_app/widgets/row/LeaderboardUserRowNew.dart';
import 'package:http/http.dart';

import '../models/User.dart';
import '../models/constants/Constants.dart';
import '../models/constants/UrlConstants.dart';
import '../models/interfaces/StatefulWidgetWithName.dart';
import '../utils/SecureUtils.dart';
import '../widgets/CustomTabIcon.dart';
import '../widgets/row/LeaderBoardAwardRow.dart';
import '../widgets/row/LeaderBoardRow.dart';
import 'LivePage.dart';
import 'ParentPage.dart';


class LeaderBoardPage extends StatefulWidget{//}WithName {

  // LeaderBoardPage(){
  //   setName('Leaderboard');
  // }

  @override
  LeaderBoardPageState createState() => LeaderBoardPageState();

}

class LeaderBoardPageState extends State<LeaderBoardPage> with SingleTickerProviderStateMixin, WidgetsBindingObserver {

  Map<String, List<User>> leaders = {};

  late TabController _tabController;

  bool isMinimized = false;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      // App is minimized or moved to the background
      setState(() {
        isMinimized = true;
      });
    } else if (state == AppLifecycleState.resumed) {
      // App is active again
      setState(() {
        isMinimized = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    leaders['0'] = <User>[];
    leaders['1'] = <User>[];

    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addObserver(this); // Add observer


    getLeaderBoard();
    Timer.periodic(const Duration(seconds: 30), (timer) {(
        getLeaderBoard()
    );
   }
   );


  }

  @override
  Widget build(BuildContext context) {

    const int items = 4;
    double width = MediaQuery.of(context).size.width;
    const double labelPadding = 4;
    double labelWidth = (width - (labelPadding * (items - 1))) / items;


    return
      // DefaultTabController(
      // length: items,
      // child:
      Scaffold(
        backgroundColor: Colors.black,
          appBar: AppBar(
            toolbarHeight: 5,
            backgroundColor: Colors.black87,
            bottom: TabBar(
              // isScrollable: true,
              labelPadding: const EdgeInsets.symmetric(horizontal: labelPadding),
              indicator: const BoxDecoration(),
              controller: _tabController,
              // labelColor: Colors.black87,
              // unselectedLabelColor: Colors.grey[400],
              // indicatorColor: Colors.black87,
              // indicatorWeight: 8,

              tabs: [
                CustomTabIcon(width: labelWidth, text: 'This month', isSelected: _tabController.index == 0,),
                CustomTabIcon(width: labelWidth, text: 'All time', isSelected: _tabController.index == 1,),
                CustomTabIcon(width: labelWidth, text: 'My stats', isSelected: _tabController.index == 2,),
                CustomTabIcon(width: labelWidth, text: 'Me all time', isSelected: _tabController.index == 3,),

              ],

              onTap: (index) {
                setState(() {
                  _tabController.index = index;
                });
              }
            ),
          ),

          body:

          PageStorage(

              bucket: pageBucket,
              child:
              TabBarView(
                controller: _tabController,
                children: [
                  ListView.builder(
                      key: const PageStorageKey<String>(
                          'pageLeaderCurr'),
                      padding: const EdgeInsets.all(8),
                      itemCount: leaders["0"]?.length,
                      itemBuilder: (context, item) {
                        return _buildUserRow(leaders["0"]![item],    'curr$item');
                      }),


                  ListView.builder(
                      key: const PageStorageKey<String>(
                          'pageLeaderAll'),
                      padding: const EdgeInsets.all(8),
                      itemCount: leaders["1"]?.length,
                      itemBuilder: (context, item) {
                        return _buildAwardRow(leaders["1"]![item],    'all$item');
                      }),

                  ListView.builder(
                      key: const PageStorageKey<String>(
                          'pageLeaderCurrMe'),
                      padding: const EdgeInsets.all(8),
                      itemCount: 1,
                      itemBuilder: (context, item) {
                        return _buildUserRow(AppContext.user,    'currme$item');
                      }),

                  ListView.builder(
                      key: const PageStorageKey<String>(
                          'pageLeaderAllMe'),
                      padding: const EdgeInsets.all(8),
                      itemCount: 1,
                      itemBuilder: (context, item) {
                        return _buildUserRow(AppContext.user,    'allme$item');
                      }),


                ],)
          )

      // ),
    );


  }

  void getLeaderBoard() async{
    if (isMinimized){
      return;
    }

    Map<String, List<User>> leadersMap = await HttpActionsClient.getLeadingUsers();


    if (leadersMap.isNotEmpty) {
      for (MapEntry leadersEntry in leadersMap.entries) {

          List<User>? existingLeaders = leaders[leadersEntry.key];
          List<User> incomingLeaders = leadersEntry.value;
          for (User u in incomingLeaders){
            User existing = existingLeaders!.firstWhere((element) => element.mongoUserId == u.mongoUserId, orElse: () => User.defUser(),);
            if (existing.mongoUserId != Constants.defMongoUserId){
              existing.copyBalancesFrom(u);
            }else{
              existingLeaders.add(u);
            }
          }

          for (User u in List.of(existingLeaders!)){
            if (!incomingLeaders.contains(u)){
              existingLeaders.remove(u);
            }
          }

          existingLeaders.sort();
      }

      if (!mounted){
        print('not mounted');
        return;
      }


      setState(() {
        leaders;
      });
    }

  }

  Widget _buildUserRow( User leader, String key) {
    return LeaderBoardUserFullInfoRow(user: leader, key: PageStorageKey<String>(key));

  }

  Widget _buildAwardRow( User leader, String key) {

    UserAward award = leader.awards.elementAt(0);

    return LeaderBoardAwardRow(award: award, username: leader.username, key: PageStorageKey<String>(key));

  }


}