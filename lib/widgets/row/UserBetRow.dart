import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetStatus.dart';

import '../../enums/FantasyLeagueStatus.dart';
import '../../models/UserPrediction.dart';
import '../../models/UserBet.dart';
import '../../models/constants/ColorConstants.dart';
import '../../models/constants/Constants.dart';
import '../../models/context/AppContext.dart';
import 'LiveMatchRowTilted.dart';
import 'MatchRowTilted.dart';
// import 'UserPredictionCardTilted.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'UserPredictionCardTilted.dart';


class UserBetRow extends StatefulWidget {

  final UserBet bet;

  const UserBetRow({Key? key, required this.bet}) : super(key: key);

  @override
  UserBetRowState createState() => UserBetRowState();


}

  class UserBetRowState extends State<UserBetRow>{

   late final UserBet bet;

   late final String placementTime;


   @override
  void initState() {
    bet = widget.bet;
    DateTime currentPeriodStartTime = DateTime.fromMillisecondsSinceEpoch(bet.betPlacementMillis.toInt()).toLocal();
    placementTime = '${currentPeriodStartTime.day < 10 ? '0' : Constants.empty}${currentPeriodStartTime.day}/${currentPeriodStartTime.month < 10 ? '0' : Constants.empty}${currentPeriodStartTime.month} ${currentPeriodStartTime.hour < 10 ? '0' : Constants.empty}${currentPeriodStartTime.hour}:${currentPeriodStartTime.minute < 10 ? '0' : Constants.empty}${currentPeriodStartTime.minute}' ;
     super.initState();
  }


   @override
   Widget build(BuildContext context) {
     return Card(
       key: PageStorageKey<String>('user_bet_${bet.betId}'),
       color: Colors.blue.shade50,
       margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
       child: Padding(
         padding: const EdgeInsets.all(8.0),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [

             // Title row with leading icon and possible earnings
             Row(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Padding(
                   padding: const EdgeInsets.only(right: 8.0),
                   child: _buildStatusIcon(),
                 ),
                 Expanded(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         '${AppLocalizations.of(context)!.possible_earnings} ${bet.toReturn().toStringAsFixed(2)}',
                         style: const TextStyle(
                           fontSize: 14,
                           color: Colors.black87,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                       const SizedBox(height: 4),
                       Text(
                         '$placementTime - ${AppLocalizations.of(context)!.amount}: ${bet.betAmount.toStringAsFixed(2)} \r\nbetId:${bet.betId}',
                         maxLines: 2,
                         style: Theme.of(context).textTheme.bodySmall,
                       ),
                     ],
                   ),
                 ),
               ],
             ),

             const SizedBox(height: 8),

             // Children predictions
             Column(
               children: bet.predictions
                   .map((item) => _buildSelectedOddRow(item))
                   .toList(),
             ),
           ],
         ),
       ),
     );
   }

   Widget _buildStatusIcon() {
     switch (bet.betStatus) {
       case BetStatus.LOST:
         return const Icon(Icons.highlight_remove, color: Colors.red);
       case BetStatus.WON:
         return const Icon(Icons.check_circle_outline_outlined, color: Color(ColorConstants.my_blue));
       default:
         return const Icon(Icons.downloading_outlined, color: Colors.blueAccent);
     }
   }


  Widget _buildSelectedOddRow(UserPrediction bettingOdd) {
    return UserPredictionCardTilted(key: PageStorageKey<String>('user_prediction_${bettingOdd.mongoId}'), prediction: bettingOdd, event: AppContext.findEvent(bettingOdd.eventId), callback: null,);
  }

}