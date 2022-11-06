import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/LeagueExpandableTile.dart';
import 'package:http/http.dart';

import '../models/UserBet.dart';
import '../models/UserPrediction.dart';
import '../models/constants/UrlConstants.dart';
import '../models/league.dart';
import '../utils/BetUtils.dart';
import '../widgets/BetSlipBottom.dart';


class OddsPage extends StatefulWidget {

  HashMap eventsPerDayMap = HashMap();

  Function loadLeagues = ()=>{ };

  @override
  OddsPageState createState() => OddsPageState(loadLeagues, eventsPerDayMap);

  OddsPage({
    Key? key,
    required this.loadLeagues,
  required this.eventsPerDayMap,
    //setName('Today\'s Odds')

  } ) : super(key: key);

}

class OddsPageState extends State<OddsPage>{

  /*
  * Required because user can deleted selected odds from the betslip directly.
   */
  List<UserPrediction> selectedOdds = <UserPrediction>[];

  /*
   * Clicking on the floating button will show or hide the bottom BetSlipBottom.
   * Only if the selected odds are not empty.
   */
  bool showOdds = false;

  List<League> allLeagues = <League>[];

  HashMap eventsPerDayMap = HashMap();

  Function functionLoadLeagues = ()=>{};

  OddsPageState(loadLeagues, eventsPerDayMap) {
    functionLoadLeagues = loadLeagues;
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

    print('***********************BUILDING ODDS');

    return DefaultTabController(
      initialIndex: 7,
      length: 15,

      child:

      Scaffold(

          appBar: AppBar(
            toolbarHeight: 0,
            bottom:

              TabBar(

                isScrollable: true,
                indicatorColor: Colors.red,
                indicatorWeight: 6,
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

            ],),

        floatingActionButton: FloatingActionButton(
          onPressed: ()=> setState(() {
            if(!showOdds && selectedOdds.isNotEmpty) {
              showOdds = true;
            }else {
              showOdds = false;
            }
          }),

          backgroundColor: showOdds&&selectedOdds.isNotEmpty ? Colors.redAccent : Colors.blueAccent,

          child: showOdds&&selectedOdds.isNotEmpty ? Icon(Icons.remove) : Text(BetUtils.finalOddOf(selectedOdds).toStringAsFixed(2), style: TextStyle(fontSize: (BetUtils.finalOddOf(selectedOdds )  < 100) ? 16 : (BetUtils.finalOddOf(selectedOdds )  < 1000) ? 15 : 12)),
        ),

        bottomSheet:
            BetSlipBottom(key: UniqueKey(), showOdds: showOdds, selectedOdds: selectedOdds, callbackForBetPlacement: placeBetCallback, callbackForBetRemoval: removeOddCallback,)


      ),
    );
  }

  Widget _buildRow(League league) {
    // return LeagueRow(key: UniqueKey(), league: league);
   return LeagueMatchesRow(key: UniqueKey(), league: league, callbackForOdds: fixOddsCallback, selectedOdds: selectedOdds);
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

  void removeOddCallback(UserPrediction toRemove){

    setState(() {
      selectedOdds.remove(toRemove);
      print('REMOVED ' + toRemove.toString());
      if (selectedOdds.isEmpty){
        showOdds = false;
      }

    });

  }

  void fixOddsCallback(UserPrediction selectedOdd) {

    if (selectedOdds.contains(selectedOdd)){
      selectedOdds.remove(selectedOdd);
    }else{
      for (UserPrediction up in List.of(selectedOdds)){
        if (selectedOdd.eventId == up.eventId){
          selectedOdds.remove(up);
        }
      }

      selectedOdds.add(selectedOdd);
    }

    setState(() => {
        selectedOdds
    }

    );

  }

  void placeBetCallback(double bettingAmount) async {
    if (bettingAmount <= 0 || selectedOdds.isEmpty){
      return;
    }

    UserBet newBet = UserBet(userMongoId: '', predictions: selectedOdds, betAmount: bettingAmount);
    var encodedBet = jsonEncode(newBet.toJson());

    try {
      await post(Uri.parse(UrlConstants.POST_PLACE_BET),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json"

            // 'Accept': 'application/json',
            // 'Content-Type': 'application/json; charset=UTF-8',
          },
          body: encodedBet,
          encoding: Encoding.getByName("utf-8")).timeout(
          const Duration(seconds: 20));

    }catch(e){
      print(e);
    }
  }

  getEventsPerDay(){
    return eventsPerDayMap;
  }

}