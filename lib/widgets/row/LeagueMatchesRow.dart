// import 'dart:ui';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/helper/SharedPrefs.dart';
// import 'package:flutter_app/models/match_event.dart';
// import 'package:flutter_app/pages/LeagueGamesPage.dart';
// import 'package:flutter_app/pages/ParentPage.dart';
// import 'package:flutter_app/widgets/row/LiveMatchRow.dart';
//
// import '../../enums/MatchEventStatus.dart';
// import '../../models/UserPrediction.dart';
// import '../../models/league.dart';
// import '../UpcomingMatchRow.dart';
//
// class LeagueMatchesRow extends StatefulWidget {
//
//   League league;
//
//   List<MatchEvent> events;
//
//   final List<String> favourites;
//
//   List<UserPrediction> selectedOdds = <UserPrediction>[];
//
//   Function(UserPrediction) callbackForOdds;
//
//   LeagueMatchesRow(
//       {Key ?key, required this.league, required this.events, required this.selectedOdds, required this.callbackForOdds, required this.favourites})
//       : super(key: key);
//
//   @override
//   LeagueMatchesRowState createState() =>
//       LeagueMatchesRowState(league: league,
//           events: events,
//           selectedOdds: selectedOdds,
//           callbackForOdds: callbackForOdds);
//   }
//
//   class LeagueMatchesRowState extends State<LeagueMatchesRow>{
//
//     League league;
//
//     List<MatchEvent> events;
//
//     late List<String> favourites;
//
//     List<UserPrediction> selectedOdds = <UserPrediction>[];
//
//     Function(UserPrediction) callbackForOdds;
//
//     LeagueMatchesRowState({required this.league, required this.events, required this.selectedOdds, required this.callbackForOdds});
//
//     @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//       favourites = widget.favourites;
//
//       return
//
//       GestureDetector(
//
//           onTap: () {
//
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => LeagueGamesPage(league: league, callbackForOdds: callbackForOdds, selectedOdds: selectedOdds, favourites: favourites,)),
//             );
//           },
//
//       child:
//
//       SizedBox(
//             height: 48,
//             child:
//             Row(//top father
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//
//                 Expanded(//first column image
//                 flex: 2,
//                 child:
//                   Container(
//
//                     child: Image.network(
//                       league.logo ?? "https://tipsscore.com/resb/no-league.png",
//                       width: 36,
//                       height: 36,
//
//                     ),
//                   )),
//
//                   Expanded(//second column texts
//                       flex: 10,
//
//                       child:
//                       Column(
//                           children: [
//                             Container(
//                               alignment: Alignment.center,
//                               height: 48,
//                               //color: Colors.red,
//                               child:
//
//                                   Padding(
//                                     padding: EdgeInsets.only(left: 4),
//                                     child:
//                                   Wrap(
//
//                                     children: [
//
//                                       Column(
//
//                                         children: [
//                                   Align(
//                                   alignment: Alignment.bottomLeft,
//                                     child:
//                                           Container( child: Text(league.section?.name.toUpperCase() ?? 'No section', overflow: TextOverflow.ellipsis, textAlign: TextAlign.left,  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10),)),
//                                   ),
//
//                         SizedBox(height: 4),
//
//                         Align(
//                           alignment: Alignment.bottomLeft,
//                           child:
//                                           Container( child: Text(league.name, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left,  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),))
//                         )
//                                         ],
//                                       )
//
//
//                                     ],
//                                   ))
//                             ),
//
//                           ]
//                       )),
//
//                   Expanded(//third column match count
//                       flex: 2,
//                       child:
//
//                       Column(//second column
//                         children: [
//                           Container(
//                               height: 48,
//                               child:
//
//                             Align(alignment: Alignment.centerRight, child:
//                             Text('(${events.length})', style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.redAccent),))
//                           )
//                           ]
//                       )),//SECOND COLUMN END
//                 ])//parent column end
//         )
//       );
//   }
//
//
//   Widget _buildSelectedOddRow(MatchEvent event) {
//     MatchEventStatus? matchEventStatus =  MatchEventStatus.fromStatusText(event.status);
//     if (matchEventStatus == MatchEventStatus.INPROGRESS || matchEventStatus == MatchEventStatus.FINISHED
//         || matchEventStatus == MatchEventStatus.POSTPONED || matchEventStatus == MatchEventStatus.CANCELLED) {
//       return LiveMatchRow(key: UniqueKey(), gameWithOdds: event, isFavourite: favourites.contains(event.eventId.toString()),);
//     }
//
//     return UpcomingMatchRow(key: UniqueKey(), gameWithOdds: event, selectedOdds: selectedOdds, callbackForOdds: callbackForOdds);
//   }
//
// }