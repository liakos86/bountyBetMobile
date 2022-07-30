import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/match_event.dart';
import 'package:flutter_app/match_odds.dart';
import 'package:http/http.dart';

import 'league.dart';


class GetOdds extends StatefulWidget{
  @override
  GetOddsState createState() => GetOddsState();
}

class GetOddsState extends State<GetOdds>{

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

    return ListTile(title : Text(gameWithOdds.homeTeam + ' - ' + gameWithOdds.awayTeam, style : TextStyle(fontSize: 18.0)),
    leading: Text( ' 1: ' +gameWithOdds.odds.odd1 + '\r\n X: ' + gameWithOdds.odds.oddX + '\r\n 2: ' + gameWithOdds.odds.odd2),
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
                  },);
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
    try {

      if (_todayGamesList.isNotEmpty){
        return;
      }

      print(getLeaguesWithEventsUrl);
      final leaguesResponse = await get(Uri.parse(getLeaguesWithEventsUrl));

      final jsonLeaguesData = jsonDecode(leaguesResponse.body) as List;

      var validData = <League>[];

        for (var leagueElement in jsonLeaguesData) {
            print("SIZE " + jsonLeaguesData.length.toString());
            var league = League();
            league.setCountryId(leagueElement['country_id']);
            league.setCountryName(leagueElement['country_name']);
            league.setLeagueId(leagueElement['league_id']);

            List events = leagueElement['events'];
            for (var event in events){
              var match = MatchEvent();
              match.setAwayTeam(event["match_awayteam_name"]);
              match.setHomeTeam(event["match_hometeam_name"]);

              var eventOdds = event["odd"];
              MatchOdds odds = MatchOdds();
              odds.setOdd1(eventOdds["odd_1"]);
              odds.setOddX(eventOdds["odd_x"]);
              odds.setOdd2(eventOdds["odd_2"]);
              match.setMatchOdds(odds);

              league.getEvents().add(match);
            }

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
