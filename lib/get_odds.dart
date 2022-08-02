import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetPredictionType.dart';
import 'package:flutter_app/models/match_event.dart';
import 'package:flutter_app/models/match_odds.dart';
import 'package:flutter_app/utils/MockUtils.dart';
import 'package:http/http.dart';
import 'models/Odd.dart';
import 'models/league.dart';


class GetOdds extends StatefulWidget{
  @override
  GetOddsState createState() => GetOddsState();
}

class GetOddsState extends State<GetOdds>{

  final _selectedOdds = <Odd>[];
  final _selectedGames = Set<String>();

  var _todayGamesList = <MatchEvent>[];

  final Set<MatchEvent> _favouriteGamesSet = Set<MatchEvent>();

  final getLeaguesWithEventsUrl = 'http://192.168.1.2:8080/betCoreServer/betServer/getLeagues';

  Widget _buildList(){
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _todayGamesList.length,
        itemBuilder: (context, item) {
          //if (item.isOdd) return Divider();
         // final index = item ~/ 2;
          return _buildRow(_todayGamesList[item]);
        }

    );
  }

  Widget _buildRow(MatchEvent gameWithOdds) {
    var isInFavourites = _favouriteGamesSet.contains(gameWithOdds);

    return Container(padding: EdgeInsets.all(20), child: ListTile(title : Text(gameWithOdds.homeTeam + ' - ' + gameWithOdds.awayTeam, style : TextStyle(fontSize: 18.0)),
    leading: Column(

      children: [
        Expanded(flex: 1,  child: GestureDetector(onTap: () {
    if (_selectedOdds.contains(gameWithOdds.odds.odd1)){
          setState(() {
            _selectedGames.remove(gameWithOdds.eventId);
            _selectedOdds.remove(gameWithOdds.odds.odd1);
          });
    }else{
      setState(() {
        _selectedGames.add(gameWithOdds.eventId);
        _selectedOdds.add(gameWithOdds.odds.odd1);
        _selectedOdds.remove(gameWithOdds.odds.oddX);
        _selectedOdds.remove(gameWithOdds.odds.odd2);
      });
    }

    }, child :Container(color:  _selectedOdds.contains(gameWithOdds.odds.odd1) ? Colors.green : Colors.white, child : Text( '1: ' +gameWithOdds.odds.odd1.value)))),


    Expanded(flex: 1,  child: GestureDetector( onTap: () {
      if (_selectedOdds.contains(gameWithOdds.odds.oddX)){
        setState(() {
          _selectedGames.remove(gameWithOdds.eventId);
          _selectedOdds.remove(gameWithOdds.odds.oddX);
        });
      }else{
        setState(() {
          _selectedGames.add(gameWithOdds.eventId);
          _selectedOdds.add(gameWithOdds.odds.oddX);
          _selectedOdds.remove(gameWithOdds.odds.odd1);
          _selectedOdds.remove(gameWithOdds.odds.odd2);
        });
      }

    },

        child: Container(color:  _selectedOdds.contains(gameWithOdds.odds.oddX) ? Colors.green : Colors.white,child: Text( 'X: ' + gameWithOdds.odds.oddX.value)))),



        Expanded(flex: 1,  child: GestureDetector(
            onTap: () {
              if (_selectedOdds.contains(gameWithOdds.odds.odd2)){
                setState(() {
                  _selectedGames.remove(gameWithOdds.eventId);
                  _selectedOdds.remove(gameWithOdds.odds.odd2);
                });
              }else{
                setState(() {
                  _selectedGames.add(gameWithOdds.eventId);
                  _selectedOdds.add(gameWithOdds.odds.odd2);
                  _selectedOdds.remove(gameWithOdds.odds.oddX);
                  _selectedOdds.remove(gameWithOdds.odds.odd1);
                });
              }

            },


            child: Container(color:  _selectedOdds.contains(gameWithOdds.odds.odd2) ? Colors.green : Colors.white,child: Text( '2: ' + gameWithOdds.odds.odd2.value)))),
      ],

    ) ,
    trailing: Icon( isInFavourites ? Icons.favorite : Icons.favorite_border,
                  color: isInFavourites ?  Colors.red : null ),
                  onTap: (){
                      setState(() {

                        if (!isInFavourites) {
                          _favouriteGamesSet.add(gameWithOdds);
                        }else{
                          _favouriteGamesSet.remove(gameWithOdds);
                        }
                      });
                  },));
  }

  void _showFavourites(){
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)
      {
        final Iterable<ListTile> tiles = _favouriteGamesSet.map((MatchEvent game)
        {
          return ListTile(title: Text(game.homeTeam + ' - ' + game.awayTeam, style: TextStyle(fontSize: 18, color: Colors.green),));

        });

        final List<Widget> divided = ListTile.divideTiles(context: context, tiles: tiles).toList();

        return Scaffold(

          appBar: AppBar(title: Text('Favourites', style: TextStyle(fontSize: 18),),),
          body: ListView(children: divided),
        );

      }
      ));
  }

  @override
  Widget build(BuildContext context) {

    getTodaysOdds();

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: Text('Odds for today'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.list), onPressed: _showFavourites)]
      ),
      body: _buildList(),

    );
  }

  void getTodaysOdds() async{
    var validData = <League>[];

    try {

      if (_todayGamesList.isNotEmpty){
        return;
      }

      print(getLeaguesWithEventsUrl);
      List jsonLeaguesData = <String>[];
      try {
        Response leaguesResponse = await get(Uri.parse(getLeaguesWithEventsUrl)).timeout(const Duration(seconds: 3));
        jsonLeaguesData = jsonDecode(leaguesResponse.body) as List;
      }catch(e){
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
            for (var event in events){
              var eventOdds = event["odd"];
              MatchOdds odds = MatchOdds(odd1: Odd(matchId : event["match_id"], betPredictionType: BetPredictionType.homeWin,value: eventOdds["odd_1"]), oddX: Odd(matchId : event["match_id"], betPredictionType: BetPredictionType.draw, value: eventOdds["odd_x"]), odd2: Odd(matchId : event["match_id"], betPredictionType: BetPredictionType.awayWin, value: eventOdds["odd_2"]));
              var match = MatchEvent(eventId:  event["match_id"],homeTeam: event["match_hometeam_name"], awayTeam: event["match_awayteam_name"], odds: odds);
              leagueEvents.add(match);
            }

            var league = League(country_id: leagueElement['country_id'], country_name: leagueElement['country_name'],
                league_id: leagueElement['league_id'], league_name: leagueElement['league_name'], events: leagueEvents);
            validData.add(league);
      }

      setState(() {
        _todayGamesList = validData.first.getEvents();
      });

    }catch(err){
        print(err);
    }
  }

}
