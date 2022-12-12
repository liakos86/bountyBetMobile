import 'dart:collection';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetStatus.dart';
import 'package:flutter_app/models/match_event.dart';

import '../models/UserPrediction.dart';
import '../models/UserBet.dart';
import 'UserBetPredictionRow.dart';

class UserBetRow extends StatelessWidget{

  UserBet bet;

  //HashMap eventsPerIdMap;

  UserBetRow(this.bet);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      tilePadding: EdgeInsets.all(8),
      backgroundColor: bet.betStatus == BetStatus.LOST ? Colors.red[100] : (bet.betStatus == BetStatus.WON ? Colors.green[100] : Colors.white),
      subtitle: Text('Bet: ' + bet.betAmount.toStringAsFixed(2)),
      leading: Icon(Icons.sports, color: Colors.orangeAccent),
      title: Text('Possible earnings: ' + bet.toReturn().toStringAsFixed(2),
          style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
      children: bet.predictions.map((item)=> _buildSelectedOddRow(item)).toList()
    );
  }

  Widget _buildSelectedOddRow(UserPrediction bettingOdd) {
    return UserBetPredictionRow(prediction: bettingOdd);
  }

}