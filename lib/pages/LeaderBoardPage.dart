import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../models/User.dart';
import '../models/constants/UrlConstants.dart';
import '../models/interfaces/StatefulWidgetWithName.dart';
import '../widgets/row/LeaderboardUserRow.dart';


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
  }

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: leaders.length,
        itemBuilder: (context, item) {
          return _buildUserRow(leaders[item]);
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

      setState(() {
        leaders = usersFromServer;
      });

    } catch (e) {
      print(e);
    }
  }

  Widget _buildUserRow(User leader) {

    return LeaderboardUserRow(user: leader);

  }


}