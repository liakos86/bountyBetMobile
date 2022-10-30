import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/interfaces/StatefulWidgetWithName.dart';
import 'package:flutter_app/widgets/LeagueExpandableTile.dart';

import '../models/UserPrediction.dart';
import '../models/league.dart';


class OddsPage extends StatefulWidgetWithName {

  //List<UserPrediction> selectedOdds = <UserPrediction>[];

  HashMap eventsPerDayMap = HashMap();

  Function loadLeagues = ()=>{ };

  Function(int, UserPrediction?) callbackForOdds = (eventId, selectedOdd)=>{ };

  @override
  OddsPageState createState() => OddsPageState(loadLeagues, eventsPerDayMap, callbackForOdds);

  OddsPage(loadLeagues, eventsPerDayMap, Function(int, UserPrediction?) callback) {
    this.loadLeagues = loadLeagues;
    this.callbackForOdds = callback;
    this.eventsPerDayMap = eventsPerDayMap;
    setName('Today\'s Odds');
  }

}

class OddsPageState extends State<OddsPage>{

  //List<UserPrediction> selectedOdds = <UserPrediction>[];

  List<League> allLeagues = <League>[];

  HashMap eventsPerDayMap = HashMap();

  Function functionLoadLeagues = ()=>{};

  Function(int, UserPrediction?) ?callbackForOdds;

  OddsPageState(loadLeagues, eventsPerDayMap, Function(int, UserPrediction?) callback) {
    functionLoadLeagues = loadLeagues;
    // this.selectedOdds = selectedOdds;
    this.callbackForOdds = callback;
    this.eventsPerDayMap = eventsPerDayMap;
  }

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      updateLeaguesFromParent(timer);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

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
    // return LeagueRow(key: UniqueKey(), league: league);
   return LeagueMatchesRow(key: UniqueKey(), league: league, callbackForOdds: callbackForOdds);
  }

  void updateLeaguesFromParent(Timer timer) {
    List<League> leagues = functionLoadLeagues.call();
    if (mounted && leagues.isNotEmpty){
      timer.cancel();
      setState(() {
        allLeagues = leagues;
      });
    }
  }

  getEventsPerDay(){
    return eventsPerDayMap;
  }

}