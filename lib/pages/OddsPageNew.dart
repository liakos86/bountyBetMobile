// import 'dart:async';
// import 'dart:collection';
// import 'dart:collection';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/models/interfaces/StatefulWidgetWithName.dart';
// import 'package:flutter_app/widgets/LeagueExpandableTile.dart';
// import 'package:http/http.dart';
//
// import '../enums/BetPredictionType.dart';
// import '../utils/MockUtils.dart';
// import '../models/UserPrediction.dart';
// import '../models/league.dart';
// import '../models/match_event.dart';
// import '../models/match_odds.dart';
// import '../widgets/UpcomingMatchRow.dart';
//
//
// class OddsPageNew extends StatefulWidgetWithName {
//
//   static final selectedOdds = <UserPrediction>[];
//
//   static final selectedGames = Set<int>();
//
//   HashMap eventsPerDayMap = HashMap();
//
//   //List<League> allLeagues = <League>[];
//
//   Function loadLeagues = ()=>{ };
//
//   Function(List<UserPrediction>) callback = (selectedOdds)=>{ };
//
//   @override
//   OddsPageNewState createState() => OddsPageNewState(loadLeagues, eventsPerDayMap, callback);
//
//   OddsPageNew(loadLeagues, eventsPerDayMap, Function(List<UserPrediction>) callback) {
//     this.loadLeagues = loadLeagues;
//     this.callback = callback;
//     this.eventsPerDayMap = eventsPerDayMap;
//     setName('Today\'s Odds');
//   }
//
// }
//
// class OddsPageNewState extends State<OddsPageNew>{
//
//   List<League> allLeagues = <League>[];
//
//   HashMap eventsPerDayMap = HashMap();
//
//   Function functionLoadLeagues = ()=>{};
//
//   Function(List<UserPrediction>) ?callback;
//
//   OddsPageNewState(loadLeagues, eventsPerDayMap, Function(List<UserPrediction>) callback) {
//     this.functionLoadLeagues = loadLeagues;
//     this.callback = callback;
//     this.eventsPerDayMap = eventsPerDayMap;
//   }
//
//   @override
//   void initState() {
//     print('BUILDING STATE ODDS');
//     Timer.periodic(Duration(seconds: 5), (timer) {
//       updateLeaguesFromParent(timer);
//     });
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     print('BUILDING ODDS');
//
//     return DefaultTabController(
//       initialIndex: 7,
//       length: 15,
//
//       child: Scaffold(
//
//           appBar: AppBar(
//             toolbarHeight: 10,
//
//             bottom:
//
//               TabBar(
//
//                 isScrollable: true,
//               indicatorColor: Colors.red,
//                 unselectedLabelColor: Colors.white.withOpacity(0.3),
//
//               tabs: [
//                 Tab(text: 'All'),
//                 Tab(text: 'All'),
//                 Tab(text: 'All'),
//                 Tab(text: 'All'),
//                 Tab(text: 'All'),
//                 Tab(text: 'All'),
//                 Tab(text: 'Yesterday'),
//                 Tab(text: 'Today'),
//                 Tab(text: 'Tomorrow'),
//                 Tab(text: 'All'),
//                 Tab(text: 'All'),
//                 Tab(text: 'All'),
//                 Tab(text: 'All'),
//                 Tab(text: 'All'),
//                 Tab(text: 'All'),
//               ],
//             ),
//
//
//       ),
//
//           body: TabBarView(
//             children: [
//               ListView.builder(
//                   padding: const EdgeInsets.all(8),
//                   itemCount: allLeagues.length,
//                   itemBuilder: (context, item) {
//                     return _buildRow(allLeagues[item]);
//                   }),
//
//               ListView.builder(
//                   padding: const EdgeInsets.all(8),
//                   itemCount: allLeagues.length,
//                   itemBuilder: (context, item) {
//                     return _buildRow(allLeagues[item]);
//                   }),
//               ListView.builder(
//                   padding: const EdgeInsets.all(8),
//                   itemCount: allLeagues.length,
//                   itemBuilder: (context, item) {
//                     return _buildRow(allLeagues[item]);
//                   }),
//               ListView.builder(
//                   padding: const EdgeInsets.all(8),
//                   itemCount: allLeagues.length,
//                   itemBuilder: (context, item) {
//                     return _buildRow(allLeagues[item]);
//                   }),
//               ListView.builder(
//                   padding: const EdgeInsets.all(8),
//                   itemCount: allLeagues.length,
//                   itemBuilder: (context, item) {
//                     return _buildRow(allLeagues[item]);
//                   }),
//               ListView.builder(
//                   padding: const EdgeInsets.all(8),
//                   itemCount: allLeagues.length,
//                   itemBuilder: (context, item) {
//                     return _buildRow(allLeagues[item]);
//                   }),
//               ListView.builder(
//                   padding: const EdgeInsets.all(8),
//                   itemCount: allLeagues.length,
//                   itemBuilder: (context, item) {
//                     return _buildRow(allLeagues[item]);
//                   }),
//               ListView.builder(
//                   padding: const EdgeInsets.all(8),
//                   itemCount: allLeagues.length,
//                   itemBuilder: (context, item) {
//                     return _buildRow(allLeagues[item]);
//                   }),
//               ListView.builder(
//                   padding: const EdgeInsets.all(8),
//                   itemCount: allLeagues.length,
//                   itemBuilder: (context, item) {
//                     return _buildRow(allLeagues[item]);
//                   }),
//               ListView.builder(
//                   padding: const EdgeInsets.all(8),
//                   itemCount: allLeagues.length,
//                   itemBuilder: (context, item) {
//                     return _buildRow(allLeagues[item]);
//                   }),
//               ListView.builder(
//                   padding: const EdgeInsets.all(8),
//                   itemCount: allLeagues.length,
//                   itemBuilder: (context, item) {
//                     return _buildRow(allLeagues[item]);
//                   }),
//
//               ListView.builder(
//                   padding: const EdgeInsets.all(8),
//                   itemCount: allLeagues.length,
//                   itemBuilder: (context, item) {
//                     return _buildRow(allLeagues[item]);
//                   }),
//               ListView.builder(
//                   padding: const EdgeInsets.all(8),
//                   itemCount: allLeagues.length,
//                   itemBuilder: (context, item) {
//                     return _buildRow(allLeagues[item]);
//                   }),
//               ListView.builder(
//                   padding: const EdgeInsets.all(8),
//                   itemCount: allLeagues.length,
//                   itemBuilder: (context, item) {
//                     return _buildRow(allLeagues[item]);
//                   }),
//               ListView.builder(
//                   padding: const EdgeInsets.all(8),
//                   itemCount: allLeagues.length,
//                   itemBuilder: (context, item) {
//                     return _buildRow(allLeagues[item]);
//                   }),
//
//             ],)
//
//       ),
//     );
//   }
//
//   Widget _buildRow(League league) {
//     return LeagueMatchesRow(key: UniqueKey(), league: league);
//    // return UpcomingMatchRow(gameWithOdds: gameWithOdds, callback: callback);
//   }
//
//   void updateLeaguesFromParent(Timer timer) {
//     print('LOD LEAGUES');
//
//     List<League> leagues = functionLoadLeagues.call();
//     if (mounted && leagues.isNotEmpty){
//       print('CANCELING LE ' + timer.toString());
//       timer.cancel();
//       setState(() {
//         allLeagues = leagues;
//       });
//
//
//
//     }
//
//
//   }
//
// }