import 'dart:collection';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetStatus.dart';
import 'package:flutter_app/models/match_event.dart';
import 'package:flutter_app/widgets/row/UserPredictionRow.dart';
import 'package:intl/intl.dart';

import '../../models/UserPrediction.dart';
import '../../models/UserBet.dart';
import '../../models/constants/ColorConstants.dart';
import '../../models/constants/Constants.dart';
import '../../models/constants/MatchConstants.dart';
import './UserBetPredictionRow.dart';
import 'UserPredictionRowTilted.dart';

class UserBetRow extends StatefulWidget {



  final UserBet bet;

  //HashMap eventsPerIdMap;

  const UserBetRow({Key? key, required this.bet}) : super(key: key);

  @override
  UserBetRowState createState() => UserBetRowState();


}

  class UserBetRowState extends State<UserBetRow>{

   late final UserBet bet;

   late final String placementTime;

   // late final ExpansionTileController controller;

   @override
  void initState() {
     // controller = ExpansionTileController();
    bet = widget.bet;
    DateTime currentPeriodStartTime = DateTime.fromMillisecondsSinceEpoch(bet.betPlacementMillis.toInt()).toLocal();
    placementTime = '${currentPeriodStartTime.day < 10 ? '0' : Constants.empty}${currentPeriodStartTime.day}/${currentPeriodStartTime.month < 10 ? '0' : Constants.empty}${currentPeriodStartTime.month} ${currentPeriodStartTime.hour < 10 ? '0' : Constants.empty}${currentPeriodStartTime.hour}:${currentPeriodStartTime.minute < 10 ? '0' : Constants.empty}${currentPeriodStartTime.minute}' ;
     super.initState();
  }


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
          backgroundColor: Colors.yellow[50],

      initiallyExpanded: true,

      tilePadding: const EdgeInsets.only(left: 8),
      subtitle: Text(maxLines:2, '$placementTime - Bet: ${bet.betAmount.toStringAsFixed(2)} \r\nbetId:${bet.betId}'),
      leading:

          bet.betStatus==BetStatus.LOST ?
          const Icon( Icons.highlight_remove, color:   Colors.red)
              : ( bet.betStatus==BetStatus.WON ?
          const Icon(Icons.check_circle_outline_outlined, color: Color(ColorConstants.my_green)) :
          const Icon(Icons.downloading_outlined, color:   Colors.blueAccent) ),



      title: Text('Possible earnings: ${bet.toReturn().toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold)),
      children: bet.predictions.map((item)=> _buildSelectedOddRow(item)).toList()
    ));
  }

  Widget _buildSelectedOddRow(UserPrediction bettingOdd) {
    return UserPredictionRowTilted(key: UniqueKey(), prediction: bettingOdd, callback: null,);
  }

}