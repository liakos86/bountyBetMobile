import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetStatus.dart';
import 'package:flutter_app/models/UserBet.dart';

import '../models/User.dart';
import '../models/interfaces/StatefulWidgetWithName.dart';
import '../widgets/UserBetRow.dart';


class MyBetsPage extends StatefulWidgetWithName{

  User? user;

  //HashMap eventsPerIdMap = HashMap();

  @override
  MyBetsPageState createState() => MyBetsPageState(user);

  // MyBetsPage(User user, HashMap<dynamic, dynamic> eventsPerIdMap){
  //   this.user = user;
  //   this.eventsPerIdMap = eventsPerIdMap;
  //   setName('My Bets');
  // }

  MyBetsPage({
    Key? key,
    required this.user,
   // required this.eventsPerIdMap
    //setName('Today\'s Odds')

  } ) : super(key: key);

}

class MyBetsPageState extends State<MyBetsPage>{

  User? user;

  // eventsPerIdMap = HashMap();

  MyBetsPageState(this.user);


  @override
  Widget build(BuildContext context) {
    if (user == null){
      return Text('Please login');
    }

    List<UserBet>? userBets = user?.userBets;

    List<UserBet> pendingBets = <UserBet>[];
    List<UserBet> settledBets = <UserBet>[];
    for (UserBet bet in userBets!){
      if (BetStatus.PENDING == bet.betStatus){
        pendingBets.add(bet);
      }else{
        settledBets.add(bet);
      }

    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 10,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_car), text: 'All'),
              Tab(icon: Icon(Icons.directions_bike), text: 'Open',),
              Tab(icon: Icon(Icons.directions_bike), text: 'Settled',),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: userBets.length,
                itemBuilder: (context, item) {
                  return _buildUserBetRow(userBets[item]);
                }),

            ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: pendingBets.length,
                itemBuilder: (context, item) {
                  return _buildUserBetRow(pendingBets[item]);
                }),

            ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: settledBets.length,
                itemBuilder: (context, item) {
                  return _buildUserBetRow(settledBets[item]);
                })
          ],)

        ),
    );

  }

  Widget _buildUserBetRow(UserBet bet) {

    return UserBetRow(bet);
  }

}
