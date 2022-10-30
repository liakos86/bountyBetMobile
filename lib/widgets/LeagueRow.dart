// import 'dart:ui';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/models/constants/MatchConstants.dart';
// import 'package:flutter_app/models/match_event.dart';
// import 'package:flutter_app/widgets/LiveMatchRow.dart';
//
// import '../models/league.dart';
// import '../pages/LeagueGamesPage.dart';
// import 'UpcomingMatchRow.dart';
//
// class LeagueRow extends StatelessWidget{
//
//   League league;
//
//   LeagueRow({Key ?key, required this.league}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return
//
//     GestureDetector(
//    onTap: (){ showLeagueGames(context);},
//
//     child:
//       Row(
//
//       children: [
//         Expanded(
//             flex: 2,
//             child: Container(
//
//                 child: Image.network(
//                   league.logo ?? "https://tipsscore.com/resb/no-league.png",
//                   height: 48,
//                   width: 48,
//                 ),
//         )),
//
//         Expanded(
//             flex: 6,
//             child: Padding(
//               padding: EdgeInsets.all(10),
//
//               child: Column(
//               children:  [Align(
//                   alignment: Alignment.centerLeft,
//                   child: Container( child: Text(league.name, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left,  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),))),
//                 SizedBox(height: 5,),
//                 Align(
//                       alignment: Alignment.centerLeft,
//                       child:       Container(child: Text(league.section!.name, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),)))
//               ]))),
//
//
//         Expanded(
//             flex: 2,
//             child: Column(
//               children: [Text( (league.events.length.toString() + liveCountFor(league.events)), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)
//               ],
//             ))
//
//       ],
//
//     ));
//   }
//
//   String liveCountFor(List<MatchEvent> events) {
//     int live = 0;
//     for (MatchEvent ev in events){
//       if (MatchConstants.IN_PROGRESS == ev.status){
//         ++live;
//       }
//     }
//
//     if (live == 0){
//       return '';
//     }
//
//     return ' (' + live.toString() + ')';
//
//   }
//
//   showLeagueGames(BuildContext context) {
//     if (league.events.isEmpty){
//       return;
//     }
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => LeagueGamesPage(league: league)),
//     );
//
//   }
// }