// import 'dart:ui';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/enums/BetPredictionStatus.dart';
//
// import '../../models/UserPrediction.dart';
// import '../../models/constants/ColorConstants.dart';
//
// class UserBetPredictionRow extends StatelessWidget{
//
//   final UserPrediction prediction;
//   //user.nt event;
//
//   UserBetPredictionRow({
//     required this.prediction
//   });
//
//   @override
//   Widget build(BuildContext context) {
//   //print("STATUS:" + prediction.betPredictionStatus.toString());
//     return Container(
//         margin: const EdgeInsets.all(4), // every row of list has margin of 4 across all directions
//         // height: 50,
//         // every row of list has height 150
//         child: Stack( // the row will be drawn as items on top of each other
//           children: [
//
//             Positioned(
//                 bottom:0,
//                 right: 0,
//                 left : 0,
//                 child: Container(
//                     height: 50,
//
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                         borderRadius: BorderRadius.all(Radius.circular(10)),
//                     )
//                 )),
//
//             Positioned(
//                 bottom:0,
//                 right: 0,
//                 left : 0,
//                 child: Container(
//                     height: 15,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.only(
//                             bottomLeft: Radius.circular(10),
//                             bottomRight: Radius.circular(10)
//                         ),
//                         gradient: LinearGradient(
//                             begin: Alignment.bottomCenter,
//                             end: Alignment.topCenter,
//                             colors: [
//                               Colors.black.withOpacity(0.1),
//                               Colors.transparent
//                             ]
//                         )
//                     )
//                 )),
//             Positioned(bottom : 0,
//               child: Padding(
//                   padding: EdgeInsets.all(10),
//                   child: Row(children: [
//
//                     Icon(
//                       Icons.pending,
//                       color:  prediction.betPredictionStatus == BetPredictionStatus.LOST ? Colors.red : (prediction.betPredictionStatus == BetPredictionStatus.WON  ? const Color(ColorConstants.my_green) : null)
//                     ),
//                     SizedBox(width: 10),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Text('${prediction.homeTeam.getLocalizedName()} - ${prediction.awayTeam.getLocalizedName()}',
//                           style: const TextStyle(fontSize: 15, color: Colors.black),),
//                         Text('${prediction.betPredictionType} @ ${prediction.value.toStringAsFixed(2)}',
//                           style: const TextStyle(fontSize: 15, color: Color(ColorConstants.my_green)),)
//                       ],
//                     ),
//
//                   ],)
//               ),
//             ),
//           ],
//         )
//
//
//     );
//   }
//
// }