import 'dart:collection';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetStatus.dart';
import 'package:flutter_app/models/match_event.dart';
import 'package:flutter_app/widgets/row/UserPredictionRow.dart';

import '../models/UserPrediction.dart';
import '../models/UserBet.dart';
import 'UserBetPredictionRow.dart';

class UserBetRow extends StatelessWidget{

  final UserBet bet;

  //HashMap eventsPerIdMap;

  const UserBetRow({Key? key, required this.bet}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return

      Theme(
        key: UniqueKey(),
    data: Theme.of(context).copyWith(
    listTileTheme: ListTileTheme.of(context).copyWith(
    dense: true,
    ),
    ),
      child:
      ExpansionTile(
      initiallyExpanded: true,
      tilePadding: const EdgeInsets.all(8),
      backgroundColor: bet.betStatus == BetStatus.LOST ? Colors.red[100] : (bet.betStatus == BetStatus.WON ? Colors.green[200] : Colors.white),
      subtitle: Text('Bet: ${bet.betAmount.toStringAsFixed(2)}'),
      leading:

          bet.betStatus==BetStatus.LOST ?
          const Icon( Icons.highlight_remove, color:   Colors.red)
              : bet.betStatus==BetStatus.WON ?
          const Icon(Icons.check_circle_outline_outlined, color:   Colors.green) :
          const Icon(Icons.pending_outlined, color:   Colors.black),



      title: Text('Possible earnings: ' + bet.toReturn().toStringAsFixed(2),
          style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
      children: bet.predictions.map((item)=> _buildSelectedOddRow(item)).toList()
    ));
  }

  Widget _buildSelectedOddRow(UserPrediction bettingOdd) {
    // return UserBetPredictionRow(prediction: bettingOdd);
    return UserPredictionRow(key: UniqueKey(), prediction: bettingOdd, callback: null,);
  }

}