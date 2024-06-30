// import 'dart:ui';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/enums/BetPredictionStatus.dart';
// import 'package:flutter_app/models/match_event.dart';
//
// import '../models/UserPrediction.dart';
//
// class UserPlacedBetPredictionRow extends StatelessWidget{
//
//   UserPrediction prediction;
//   //MatchEvent event;
//
//   UserPlacedBetPredictionRow({
//     //required this.event,
//     required this.prediction
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Container(
//         margin: EdgeInsets.all(4), // every row of list has margin of 4 across all directions
//         height: 30,
//         // every row of list has height 150
//         child:
//            Row(children: [
//                         Text('${prediction.homeTeam.name} - ${prediction.awayTeam.name} ${prediction.betPredictionType.toString()}  @  ${prediction.value.toStringAsFixed(2)}',
//                           style: TextStyle(fontSize: 15, color: Colors.black),),
//                   ],)
//
//     );
//   }
//
// }