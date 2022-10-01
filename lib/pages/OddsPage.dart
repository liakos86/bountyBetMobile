import 'dart:collection';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/interfaces/StatefulWidgetWithName.dart';
import 'package:flutter_app/widgets/LeagueMatchesRow.dart';
import 'package:http/http.dart';

import '../enums/BetPredictionType.dart';
import '../utils/MockUtils.dart';
import '../models/UserPrediction.dart';
import '../models/league.dart';
import '../models/match_event.dart';
import '../models/match_odds.dart';
import '../widgets/UpcomingMatchRow.dart';


class OddsPage extends StatefulWidgetWithName {

  static final selectedOdds = <UserPrediction>[];

  static final selectedGames = Set<int>();

  HashMap eventsPerDayMap = HashMap();

  List<League> allLeagues = <League>[];

  Function(List<UserPrediction>) callback = (selectedOdds)=>{ };

  @override
  OddsPageState createState() => OddsPageState(allLeagues, eventsPerDayMap, callback);

  OddsPage(allMatches, eventsPerDayMap, Function(List<UserPrediction>) callback) {
    this.allLeagues = allMatches;
    this.callback = callback;
    this.eventsPerDayMap = eventsPerDayMap;
    setName('Today\'s Odds');
  }

}

class OddsPageState extends State<OddsPage>{

  List<League> allLeagues = <League>[];

  HashMap eventsPerDayMap = HashMap();

  Function(List<UserPrediction>) ?callback;

  OddsPageState(allMatches, eventsPerDayMap, Function(List<UserPrediction>) callback) {
    this.allLeagues = allMatches;
    this.callback = callback;
    this.eventsPerDayMap = eventsPerDayMap;
  }

  // var _todayGamesList = <MatchEvent>[];

  @override
  Widget build(BuildContext context) {

   // print('LEagues: ' + allMatches.length.toString());
    if (allLeagues.isEmpty){
      return Text('No games yet..');
    }

   // _todayGamesList.addAll(allLeagues);

    return DefaultTabController(
      initialIndex: 7,
      length: 15,

      child: Scaffold(

          appBar: AppBar(
            toolbarHeight: 10,

            bottom:

              TabBar(

                isScrollable: true,
              indicatorColor: Colors.red,
                unselectedLabelColor: Colors.white.withOpacity(0.3),

              tabs: [
                Tab(text: 'All'),
                Tab(text: 'All'),
                Tab(text: 'All'),
                Tab(text: 'All'),
                Tab(text: 'All'),
                Tab(text: 'All'),
                Tab(text: 'Yesterday'),
                Tab(text: 'Today'),
                Tab(text: 'Tomorrow'),
                Tab(text: 'All'),
                Tab(text: 'All'),
                Tab(text: 'All'),
                Tab(text: 'All'),
                Tab(text: 'All'),
                Tab(text: 'All'),
              ],
            ),


      ),

          body: TabBarView(
            children: [
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: allLeagues.length,
                  itemBuilder: (context, item) {
                    return _buildRow(allLeagues[item]);
                  }),

              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: allLeagues.length,
                  itemBuilder: (context, item) {
                    return _buildRow(allLeagues[item]);
                  }),
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: allLeagues.length,
                  itemBuilder: (context, item) {
                    return _buildRow(allLeagues[item]);
                  }),
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: allLeagues.length,
                  itemBuilder: (context, item) {
                    return _buildRow(allLeagues[item]);
                  }),
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: allLeagues.length,
                  itemBuilder: (context, item) {
                    return _buildRow(allLeagues[item]);
                  }),
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: allLeagues.length,
                  itemBuilder: (context, item) {
                    return _buildRow(allLeagues[item]);
                  }),
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: allLeagues.length,
                  itemBuilder: (context, item) {
                    return _buildRow(allLeagues[item]);
                  }),
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: allLeagues.length,
                  itemBuilder: (context, item) {
                    return _buildRow(allLeagues[item]);
                  }),
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: allLeagues.length,
                  itemBuilder: (context, item) {
                    return _buildRow(allLeagues[item]);
                  }),
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: allLeagues.length,
                  itemBuilder: (context, item) {
                    return _buildRow(allLeagues[item]);
                  }),
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: allLeagues.length,
                  itemBuilder: (context, item) {
                    return _buildRow(allLeagues[item]);
                  }),

              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: allLeagues.length,
                  itemBuilder: (context, item) {
                    return _buildRow(allLeagues[item]);
                  }),
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: allLeagues.length,
                  itemBuilder: (context, item) {
                    return _buildRow(allLeagues[item]);
                  }),
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: allLeagues.length,
                  itemBuilder: (context, item) {
                    return _buildRow(allLeagues[item]);
                  }),
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: allLeagues.length,
                  itemBuilder: (context, item) {
                    return _buildRow(allLeagues[item]);
                  }),

            ],)

      ),
    );
  }

  Widget _buildRow(League league) {
    return LeagueMatchesRow(key: UniqueKey(), league: league);
   // return UpcomingMatchRow(gameWithOdds: gameWithOdds, callback: callback);
  }

}