import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/Odd.dart';
import 'package:flutter_app/models/league.dart';
import 'package:flutter_app/pages/OddsPage.dart';
import 'package:http/http.dart';

import '../enums/BetPredictionType.dart';
import '../models/match_event.dart';
import '../models/match_odds.dart';
import '../utils/MockUtils.dart';
import '../models/interfaces/StatefulWidgetWithName.dart';
import 'LeaderBoardPage.dart';
import 'MyBetsPage.dart';

class ParentPage extends StatefulWidget{
  @override
  ParentPageState createState() => ParentPageState();
}

class ParentPageState extends State<ParentPage>{

  final getLeaguesWithEventsUrl = 'http://192.168.1.2:8080/betCoreServer/betServer/getLeagues';

  var _allLeagues = <League>[];

  bool showOdds = false;

  double finalOdd = 0;

  int _selectedPage = 0;

  final List<Widget> pagesList = <Widget>[];

  @override
  void initState() {
    getLeagues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    print ('ALL LEAGUES in build parent ' + _allLeagues.length.toString());
    pagesList.clear();
    if (_allLeagues.isEmpty) {
      pagesList.add(CircularProgressIndicator());
      pagesList.add(CircularProgressIndicator());
      pagesList.add(CircularProgressIndicator());
    }else {
      pagesList.add(OddsPage(_allLeagues, (finalOddValue) =>
          setState(
                  () => finalOdd = finalOddValue)));
      pagesList.add(LeaderBoardPage());
      pagesList.add(MyBetsPage());
    }

    return Scaffold(
      appBar: AppBar(
          title: _allLeagues.isEmpty ? Text('Loading...') : Text((pagesList[_selectedPage] as StatefulWidgetWithName).name),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.list), onPressed: null)]
      ),
      body: pagesList[_selectedPage],

      floatingActionButton: FloatingActionButton(
        onPressed: ()=> setState(() {
          if(!showOdds)
            showOdds = true;
          else
            showOdds = false;
        }),
        child: showOdds ? Icon(Icons.remove) : Text(finalOdd.toStringAsFixed(2), style: TextStyle(fontSize: 16),),
      ),

      bottomSheet:
          showOdds ?

          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 300,
              maxHeight: 300,
              minWidth: double.infinity,
              maxWidth: double.infinity
            ),

            child: Center(
              child : Text('Selected odds here')
            ),
          )
      : null
      ,

      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 20,
        unselectedFontSize: 15,
        backgroundColor: Colors.blueAccent,
        fixedColor: Colors.white,
        currentIndex: _selectedPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Odds'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Leaders'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.my_library_music),
              label: 'My bets'
          ),
        ],

        onTap: (index){
          setState(() {
            _selectedPage = index;
          });

        },
      ),

    );
  }


  void getLeagues() async {
    var validData = <League>[];

    try {
      if (_allLeagues.isNotEmpty) {
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
          _allLeagues = validData;
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
        _allLeagues = validData;
      });
    } catch (err) {
      print(err);
    }
  }


}
