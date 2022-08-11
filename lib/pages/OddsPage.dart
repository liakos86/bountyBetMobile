import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/interfaces/StatefulWidgetWithName.dart';
import 'package:http/http.dart';

import '../enums/BetPredictionType.dart';
import '../utils/MockUtils.dart';
import '../models/Odd.dart';
import '../models/league.dart';
import '../models/match_event.dart';
import '../models/match_odds.dart';


class OddsPage extends StatefulWidgetWithName {

  Function(double) callback = (oddValue)=>{ };

  @override
  OddsPageState createState() => OddsPageState(callback);

  OddsPage(Function(double) callback) {
    this.callback = callback;
    setName('Today\'s Odds');
  }

}

class OddsPageState extends State<OddsPage>{

  Function(double) callback = (oddValue)=>{};

  OddsPageState(Function(double) callback) {
    this.callback = callback;
  }

  static final _selectedOdds = <Odd>[];
  static final _selectedGames = Set<String>();

  var _todayGamesList = <MatchEvent>[];

  final getLeaguesWithEventsUrl = 'http://192.168.1.2:8080/betCoreServer/betServer/getLeagues';

  @override
  Widget build(BuildContext context) {

    print("SELECTED GAMES: " + _selectedGames.length.toString());

    getTodaysOdds();

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
                      //if (item.isOdd) return Divider();
                      // final index = item ~/ 2;
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

                double oddValue = 0;
                for (Odd odd in _selectedOdds){
                  double oddCurrent = double.parse(odd.value);
                  if (oddValue == 0){
                    oddValue = oddCurrent;
                    continue;
                  }
                  oddValue = oddValue * oddCurrent;
                }

                callback.call(oddValue);
              },
                  child: Container(
                      color: _selectedOdds.contains(gameWithOdds.odds.odd1)
                          ? Colors.green
                          : Colors.white,
                      child: Text('1: ' + gameWithOdds.odds.odd1.value)))),


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

                double oddValue = 0;
                for (Odd odd in _selectedOdds){
                  double oddCurrent = double.parse(odd.value);
                  if (oddValue == 0){
                    oddValue = oddCurrent;
                    continue;
                  }
                  oddValue = oddValue * oddCurrent;
                }

                callback.call(oddValue);
              },

                  child: Container(
                      color: _selectedOdds.contains(gameWithOdds.odds.oddX)
                          ? Colors.green
                          : Colors.white,
                      child: Text('X: ' + gameWithOdds.odds.oddX.value)))),


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

                    double oddValue = 0;
                    for (Odd odd in _selectedOdds){
                      double oddCurrent = double.parse(odd.value);
                      if (oddValue == 0){
                        oddValue = oddCurrent;
                        continue;
                      }
                      oddValue = oddValue * oddCurrent;
                    }

                    callback.call(oddValue);
                  },


                  child: Container(
                      color: _selectedOdds.contains(gameWithOdds.odds.odd2)
                          ? Colors.green
                          : Colors.white,
                      child: Text('2: ' + gameWithOdds.odds.odd2.value)))),
            ],

          ),
          ));
  }


  void getTodaysOdds() async {
    var validData = <League>[];

    try {
      if (_todayGamesList.isNotEmpty) {
        return;
      }

      print(getLeaguesWithEventsUrl);
      List jsonLeaguesData = <String>[];
      try {
        Response leaguesResponse = await get(Uri.parse(getLeaguesWithEventsUrl))
            .timeout(const Duration(seconds: 3));
        jsonLeaguesData = jsonDecode(leaguesResponse.body) as List;
      } catch (e) {
        print('ERROR REST');
        validData = MockUtils().mockLeagues();
        setState(() {
          _todayGamesList = validData.first.getEvents();
        });
        return;
      }


      print("HELLO");


      for (var leagueElement in jsonLeaguesData) {
        print("SIZE " + jsonLeaguesData.length.toString());

        List events = leagueElement['events'];
        List<MatchEvent> leagueEvents = <MatchEvent>[];
        for (var event in events) {
          var eventOdds = event["odd"];
          MatchOdds odds = MatchOdds(odd1: Odd(matchId: event["match_id"],
              betPredictionType: BetPredictionType.homeWin,
              value: eventOdds["odd_1"]),
              oddX: Odd(matchId: event["match_id"],
                  betPredictionType: BetPredictionType.draw,
                  value: eventOdds["odd_x"]),
              odd2: Odd(matchId: event["match_id"],
                  betPredictionType: BetPredictionType.awayWin,
                  value: eventOdds["odd_2"]));
          var match = MatchEvent(eventId: event["match_id"],
              homeTeam: event["match_hometeam_name"],
              awayTeam: event["match_awayteam_name"],
              odds: odds);
          leagueEvents.add(match);
        }

        var league = League(country_id: leagueElement['country_id'],
            country_name: leagueElement['country_name'],
            league_id: leagueElement['league_id'],
            league_name: leagueElement['league_name'],
            events: leagueEvents);
        validData.add(league);
      }

      setState(() {
        _todayGamesList = validData.first.getEvents();
      });
    } catch (err) {
      print(err);
    }
  }

}