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


class OddsPage extends StatefulWidgetWithName {

  var leagues = <League>[];

  Function(List<UserPrediction>) callback = (selectedOdds)=>{ };

  @override
  OddsPageState createState() => OddsPageState(leagues, callback);

  OddsPage(leagues, Function(List<UserPrediction>) callback) {
    this.leagues = leagues;
    this.callback = callback;
    setName('Today\'s Odds');
  }

}

class OddsPageState extends State<OddsPage>{

  var leagues = <League>[];

  Function(List<UserPrediction>) callback = (selectedOdds)=>{};

  OddsPageState(leagues, Function(List<UserPrediction>) callback) {
    this.leagues = leagues;
    this.callback = callback;
  }

  static final _selectedOdds = <UserPrediction>[];
  static final _selectedGames = Set<String>();

  var _todayGamesList = <MatchEvent>[];

  @override
  Widget build(BuildContext context) {

    print("SELECTED GAMES: " + _selectedGames.length.toString());

    print('LEagues: ' + leagues.length.toString());
    if (leagues.isEmpty){
      return Text('No games yet..');
    }

    _todayGamesList = leagues.first.getEvents();

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

    return Container(padding: EdgeInsets.all(20),
        child: ListTile(title: Text(
            gameWithOdds.homeTeam + ' - ' + gameWithOdds.awayTeam,
            style: TextStyle(fontSize: 18.0)),
          leading: Column(

            children: [
              Expanded(flex: 1, child: GestureDetector(onTap: () {
                if (_selectedOdds.contains(gameWithOdds.odds.odd1)) {
                  setState(() {
                    _selectedGames.remove(gameWithOdds.eventId);
                    _selectedOdds.remove(gameWithOdds.odds.odd1);
                  });
                } else {
                  setState(() {
                    _selectedGames.add(gameWithOdds.eventId);
                    _selectedOdds.add(gameWithOdds.odds.odd1);
                    _selectedOdds.remove(gameWithOdds.odds.oddX);
                    _selectedOdds.remove(gameWithOdds.odds.odd2);
                  });
                }

                callback.call(_selectedOdds);
              },
                  child: Container(
                      color: _selectedOdds.contains(gameWithOdds.odds.odd1)
                          ? Colors.green
                          : Colors.white,
                      child: Text('1: ' + gameWithOdds.odds.odd1.value.toStringAsFixed(2))))),


              Expanded(flex: 1, child: GestureDetector(onTap: () {
                if (_selectedOdds.contains(gameWithOdds.odds.oddX)) {
                  setState(() {
                    _selectedGames.remove(gameWithOdds.eventId);
                    _selectedOdds.remove(gameWithOdds.odds.oddX);
                  });
                } else {
                  setState(() {
                    _selectedGames.add(gameWithOdds.eventId);
                    _selectedOdds.add(gameWithOdds.odds.oddX);
                    _selectedOdds.remove(gameWithOdds.odds.odd1);
                    _selectedOdds.remove(gameWithOdds.odds.odd2);
                  });
                }

                callback.call(_selectedOdds);
              },

                  child: Container(
                      color: _selectedOdds.contains(gameWithOdds.odds.oddX)
                          ? Colors.green
                          : Colors.white,
                      child: Text('X: ' + gameWithOdds.odds.oddX.value.toStringAsFixed(2))))),


              Expanded(flex: 1, child: GestureDetector(
                  onTap: () {
                    if (_selectedOdds.contains(gameWithOdds.odds.odd2)) {
                      setState(() {
                        _selectedGames.remove(gameWithOdds.eventId);
                        _selectedOdds.remove(gameWithOdds.odds.odd2);
                      });
                    } else {
                      setState(() {
                        _selectedGames.add(gameWithOdds.eventId);
                        _selectedOdds.add(gameWithOdds.odds.odd2);
                        _selectedOdds.remove(gameWithOdds.odds.oddX);
                        _selectedOdds.remove(gameWithOdds.odds.odd1);
                      });
                    }

                    callback.call(_selectedOdds);
                  },


                  child: Container(
                      color: _selectedOdds.contains(gameWithOdds.odds.odd2)
                          ? Colors.green
                          : Colors.white,
                      child: Text('2: ' + gameWithOdds.odds.odd2.value.toStringAsFixed(2))))),
            ],

          ),
          ));
  }

}