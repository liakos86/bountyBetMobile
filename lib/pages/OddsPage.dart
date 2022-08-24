import 'dart:collection';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/interfaces/StatefulWidgetWithName.dart';
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

  static final selectedGames = Set<String>();

  HashMap eventsPerDayMap = HashMap();

  var leagues = <League>[];

  Function(List<UserPrediction>) callback = (selectedOdds)=>{ };

  @override
  OddsPageState createState() => OddsPageState(leagues, eventsPerDayMap, callback);

  OddsPage(leagues, eventsPerDayMap, Function(List<UserPrediction>) callback) {
    this.leagues = leagues;
    this.callback = callback;
    this.eventsPerDayMap = eventsPerDayMap;
    setName('Today\'s Odds');
  }

}

class OddsPageState extends State<OddsPage>{

  var leagues = <League>[];

  HashMap eventsPerDayMap = HashMap();

  Function(List<UserPrediction>) ?callback;

  OddsPageState(leagues, eventsPerDayMap, Function(List<UserPrediction>) callback) {
    this.leagues = leagues;
    this.callback = callback;
    this.eventsPerDayMap = eventsPerDayMap;
  }

  var _todayGamesList = <MatchEvent>[];

  @override
  Widget build(BuildContext context) {

    print('LEagues: ' + leagues.length.toString());
    if (leagues.isEmpty){
      return Text('No games yet..');
    }

    _todayGamesList = leagues.first.getEvents();

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
                  itemCount: leagues.first.events.length,
                  itemBuilder: (context, item) {
                    return _buildRow(_todayGamesList[item]);
                  }),

              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: leagues.first.events.length,
                  itemBuilder: (context, item) {
                    return _buildRow(_todayGamesList[item]);
                  }),
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: leagues.first.events.length,
                  itemBuilder: (context, item) {
                    return _buildRow(_todayGamesList[item]);
                  }),
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: leagues.first.events.length,
                  itemBuilder: (context, item) {
                    return _buildRow(_todayGamesList[item]);
                  }),
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: leagues.first.events.length,
                  itemBuilder: (context, item) {
                    return _buildRow(_todayGamesList[item]);
                  }),
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: leagues.first.events.length,
                  itemBuilder: (context, item) {
                    return _buildRow(_todayGamesList[item]);
                  }),
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: leagues.first.events.length,
                  itemBuilder: (context, item) {
                    return _buildRow(_todayGamesList[item]);
                  }),
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: leagues.first.events.length,
                  itemBuilder: (context, item) {
                    return _buildRow(_todayGamesList[item]);
                  }),
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: leagues.first.events.length,
                  itemBuilder: (context, item) {
                    return _buildRow(_todayGamesList[item]);
                  }),
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: leagues.first.events.length,
                  itemBuilder: (context, item) {
                    return _buildRow(_todayGamesList[item]);
                  }),
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: leagues.first.events.length,
                  itemBuilder: (context, item) {
                    return _buildRow(_todayGamesList[item]);
                  }),

              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: leagues.first.events.length,
                  itemBuilder: (context, item) {
                    return _buildRow(_todayGamesList[item]);
                  }),
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: leagues.first.events.length,
                  itemBuilder: (context, item) {
                    return _buildRow(_todayGamesList[item]);
                  }),
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: leagues.first.events.length,
                  itemBuilder: (context, item) {
                    return _buildRow(_todayGamesList[item]);
                  }),
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: leagues.first.events.length,
                  itemBuilder: (context, item) {
                    return _buildRow(_todayGamesList[item]);
                  }),

            ],)

      ),
    );

    return Container(
        width: 700,
        height: 700,
        color: Colors.amber[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 1, child:
            Container(
              height: 20,
              width: 700,
              color: Colors.red[300],
              child:
              Row(children: [Text('This will be a list of the +-7 days in order to select')]),)),

            Expanded(
                flex: 6,
                child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _todayGamesList.length,
                    itemBuilder: (context, item) {
                      return _buildRow(_todayGamesList[item]);
                    })
            )
          ],
        )
    );

  }

  Widget _buildRow(MatchEvent gameWithOdds) {

    return UpcomingMatchRow(gameWithOdds: gameWithOdds, callback: callback);


  }

}