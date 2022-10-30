// import 'dart:async';
// import 'dart:collection';
// import 'dart:collection';
// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/models/constants/UrlConstants.dart';
// import 'package:flutter_app/models/interfaces/StatefulWidgetWithName.dart';
// import 'package:http/http.dart';
//
// import '../enums/BetPredictionType.dart';
// import '../helper/JsonHelper.dart';
// import '../models/constants/MatchConstants.dart';
// import '../utils/MockUtils.dart';
// import '../models/UserPrediction.dart';
// import '../models/league.dart';
// import '../models/match_event.dart';
// import '../models/match_odds.dart';
// import '../widgets/LeagueExpandableTile.dart';
// import '../widgets/LiveMatchRow.dart';
// import '../widgets/UpcomingMatchRow.dart';
//
//
// class LeagueGamesPage extends StatefulWidget{
//
//   @override
//   LeagueGamesPageState createState() => LeagueGamesPageState(league);
//
//   League league;
//
//   LeagueGamesPage({required this.league});
//
// }
//
// class LeagueGamesPageState extends State<LeagueGamesPage>{
//
//   League league = League.defLeague();
//
//   LeagueGamesPageState(_league) {
//     this.league = _league;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return
//       Scaffold(
//         appBar: AppBar(title: Text(league.name)),
//     body:
//       ListView.builder(
//                   padding: const EdgeInsets.all(8),
//                   itemCount: league.events.length,
//                   itemBuilder: (context, item) {
//                     return _buildRow(league.events[item]);
//                   }),
//
//       );
//   }
//
//   Widget _buildRow(MatchEvent event) {
//     if (event.status == "inprogress" || event.status == "finished") {
//       return LiveMatchRow(key: UniqueKey(), gameWithOdds: event);
//     }
//
//     return UpcomingMatchRow(key: UniqueKey(), gameWithOdds: event);
//   }
//
// }