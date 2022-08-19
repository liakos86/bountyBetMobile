import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

    return Container(
       child: ListView.builder(
           padding: const EdgeInsets.all(8),
           itemCount: userBets.length,
           itemBuilder: (context, item) {
             return _buildUserBetRow(userBets[item]);
           })
    );

  }

  Widget _buildUserBetRow(UserBet bet) {
    return UserBetRow(bet, eventsPerIdMap);
  }

}
