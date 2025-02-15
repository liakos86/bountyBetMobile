// import 'dart:ui';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../models/Team.dart';
//
//
// class RowWithTeams extends StatelessWidget{
//
//   final Team homeTeam;
//
//   final Team awayTeam;
//
//   RowWithTeams({Key ?key, required this.homeTeam, required this.awayTeam}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return
//       Flex(
//
//       direction: Axis.horizontal,
//       children: [
//
//
//         Expanded(
//             flex: 5,
//             child:
//             Row(
//               children: [
//                       Image.network(
//                         homeTeam.logo,
//                         height: 24,
//                         width: 24,
//                       ),
//
//                         Flexible(
//                         child:Text(homeTeam.getLocalizedName(), overflow: TextOverflow.clip, maxLines: 1,  textAlign: TextAlign.left,  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),)),
//               ]
//         ),
//         ),
//
//         const Expanded(flex:1, child: Text('-')),
//
//         Expanded(
//           flex: 5,
//           child:
//           Row(
//               children: [
//                 Image.network(
//                   awayTeam.logo,
//                   height: 24,
//                   width: 24,
//                 ),
//
//                 Flexible(
//                     child:Text(awayTeam.getLocalizedName(), overflow: TextOverflow.clip, maxLines: 1,  textAlign: TextAlign.left,  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),)),
//               ]
//           ),
//         ),
//       ],
//
//
//     );
//   }
//
// }