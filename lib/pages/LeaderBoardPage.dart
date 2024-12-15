import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserAward.dart';
import 'package:flutter_app/utils/MockUtils.dart';
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

    getLeadingUsers();
    Timer.periodic(const Duration(seconds: 30), (timer) {(
        getLeadingUsers()
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



    // return ListView.builder(
    //     padding: const EdgeInsets.all(8),
    //     itemCount: leaders['0']?.length,
    //     itemBuilder: (context, item) {
    //       return _buildUserRow(item);
    //     });

  }


  void getLeadingUsers() async{

    if (access_token == null) {
      access_token = await SecureUtils().retrieveValue(
          Constants.accessToken);
      await authorizeAsync();
      if (access_token == null) {
        print('LEDERS COULD NOT AUTHORIZE ********************************************************************');
        return ;
      }
    }


    Map leadersMap = LinkedHashMap();

    String getLeadersUrl = UrlConstants.GET_LEADERS_URL;
    try {
      Response leadersResponse = await get(Uri.parse(getLeadersUrl), headers:  {'Authorization': 'Bearer $access_token'})
          .timeout(const Duration(seconds: 5));
      leadersMap = await jsonDecode(leadersResponse.body) as Map;

      //var currentMonthLeadersJson = leadersMap["0"];

      for (MapEntry leadersEntry in  leadersMap.entries) {
        List<User> currentMonthLeaders = <User>[];

        for (var leaderEntry in leadersEntry.value) {
          User userFromServer = User.fromJson(leaderEntry);
          currentMonthLeaders.add(userFromServer);
        }


        //TODO copy valus

        leaders[leadersEntry.key]?.clear();
        leaders[leadersEntry.key]?.addAll(currentMonthLeaders);
      }



    } catch (e) {
      leaders['0']?.add(MockUtils.mockUser());
      leaders['1']?.add(MockUtils.mockUser());
      print(e);
    }

    setState(() {
      leaders;
    });
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