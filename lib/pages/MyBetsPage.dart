import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetStatus.dart';
import 'package:flutter_app/models/UserBet.dart';

import '../models/interfaces/StatefulWidgetWithName.dart';
import '../widgets/UserBetRow.dart';


class MyBetsPage extends StatefulWidgetWithName{

  List<UserBet> userBets = <UserBet>[];

  HashMap eventsPerIdMap = HashMap();

  @override
  MyBetsPageState createState() => MyBetsPageState(userBets, eventsPerIdMap);

  MyBetsPage(List<UserBet> userBets, HashMap<dynamic, dynamic> eventsPerIdMap){
    this.userBets = userBets;
    this.eventsPerIdMap = eventsPerIdMap;
    setName('My Bets');
  }

}

class MyBetsPageState extends State<MyBetsPage>{

  List<UserBet> userBets = <UserBet>[];

  HashMap eventsPerIdMap = HashMap();

  MyBetsPageState(this.userBets, this.eventsPerIdMap);


  @override
  Widget build(BuildContext context) {
    List<UserBet> pendingBets = <UserBet>[];
    List<UserBet> settledBets = <UserBet>[];
    for (UserBet bet in userBets){
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
    return UserBetRow(bet, eventsPerIdMap);
  }

}
