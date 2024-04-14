import 'dart:async';
import 'dart:convert';

import 'package:animated_background/particles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/MockUtils.dart';
import 'package:http/http.dart';

import '../models/User.dart';
import '../models/constants/UrlConstants.dart';
import '../models/interfaces/StatefulWidgetWithName.dart';
import '../widgets/row/LeaderboardUserRow.dart';
import '../widgets/row/LeaderboardUserRowNew.dart';


class LeaderBoardPage extends StatefulWidgetWithName {

  LeaderBoardPage(){
    setName('Leaderboard');
  }

  @override
  LeaderBoardPageState createState() => LeaderBoardPageState();

}

class LeaderBoardPageState extends State<LeaderBoardPage>{

  List<User> leaders = <User>[];

  @override
  void initState() {
    super.initState();

    getLeadingUsers();
    Timer.periodic(const Duration(seconds: 30), (timer) {(
        getLeadingUsers()
    );
   }
   );


  }

  @override
  Widget build(BuildContext context) {



    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: leaders.length,
        itemBuilder: (context, item) {
          return _buildUserRow(item);
        });

  }


  void getLeadingUsers() async{

    String getLeadersUrl = UrlConstants.GET_LEADERS_URL;
    try {
      Response leadersResponse = await get(Uri.parse(getLeadersUrl))
          .timeout(const Duration(seconds: 5));
      var responseDec = jsonDecode(leadersResponse.body);
      List<User> usersFromServer = <User>[];
      for (var userJson in responseDec) {
        User userFromServer = User.fromJson(userJson);
        usersFromServer.add(userFromServer);
      }

      leaders.clear();
      leaders.addAll(usersFromServer);


    } catch (e) {
      leaders.add(MockUtils.mockUser());
      print(e);
    }

    setState(() {
      leaders;
    });
  }

  Widget _buildUserRow( int item) {

    User leader = leaders[item];



    return LeaderboardUserRowNew(user: leader, position: item+1);

  }


}