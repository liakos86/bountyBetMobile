import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserAward.dart';
import 'package:flutter_app/utils/MockUtils.dart';
import 'package:flutter_app/utils/client/HttpActionsClient.dart';
import 'package:http/http.dart';

import '../models/User.dart';
import '../models/constants/Constants.dart';
import '../models/constants/UrlConstants.dart';
import '../models/interfaces/StatefulWidgetWithName.dart';
import '../utils/SecureUtils.dart';
import '../widgets/row/LeaderBoardAwardRow.dart';
import '../widgets/row/LeaderBoardRow.dart';
import 'LivePage.dart';
import 'ParentPage.dart';


class LeaderBoardPage extends StatefulWidgetWithName {

  LeaderBoardPage(){
    setName('Leaderboard');
  }

  @override
  LeaderBoardPageState createState() => LeaderBoardPageState();

}

class LeaderBoardPageState extends State<LeaderBoardPage>{

  Map<String, List<User>> leaders = {};

  @override
  void initState() {
    super.initState();

    leaders['0'] = <User>[];
    leaders['1'] = <User>[];

    getLeaderBoard();
    Timer.periodic(const Duration(seconds: 30), (timer) {(
        getLeaderBoard()
    );
   }
   );


  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 2,
            backgroundColor: Colors.deepOrange.shade100,
            bottom: TabBar(
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.grey[400],
              indicatorColor: Colors.black87,
              indicatorWeight: 8,

              tabs: [
                Tab( text: 'This month'),
                Tab( text: 'All time'),

              ],
            ),
          ),

          body:

          PageStorage(

              bucket: pageBucket,
              child:
              TabBarView(
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
                          'pageLeadeAll'),
                      padding: const EdgeInsets.all(8),
                      itemCount: leaders["1"]?.length,
                      itemBuilder: (context, item) {
                        return _buildAwardRow(leaders["1"]![item],    'all$item');
                      }),


                ],)
          )

      ),
    );


  }


  void getLeaderBoard() async{

    Map<String, List<User>> leadersMap = await HttpActionsClient.getLeadingUsers();

    if (leadersMap.isNotEmpty) {
      for (MapEntry leadersEntry in leadersMap.entries) {

          List<User>? existingLeaders = leaders[leadersEntry.key];
          List<User> incomingLeaders = leadersEntry.value;
          for (User u in incomingLeaders){
            if (existingLeaders!.contains(u)){
              User existing = existingLeaders.where((element) => element.mongoUserId == u.mongoUserId).first;
              existing.copyBalancesFrom(u);
            }else{
              existingLeaders.add(u);
            }
          }

          for (User u in existingLeaders!){
            if (!incomingLeaders.contains(u)){
              existingLeaders.remove(u);
            }
          }


          // leaders[leadersEntry.key]?.addAll(leadersEntry.value);

      }

      setState(() {
        leaders;
      });
    }

  }

  Widget _buildUserRow( User leader, String key) {

    return LeaderBoardRow(user: leader, key: PageStorageKey<String>(key));

  }

  Widget _buildAwardRow( User leader, String key) {

    UserAward award = leader.awards.elementAt(0);

    // return LeaderBoardRow(user: leader, key: PageStorageKey<String>(key));

    return LeaderBoardAwardRow(award: award, username: leader.username, key: PageStorageKey<String>(key));

  }


}