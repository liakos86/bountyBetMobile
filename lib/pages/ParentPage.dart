import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserPrediction.dart';
import 'package:flutter_app/models/UserBet.dart';
import 'package:flutter_app/models/league.dart';
import 'package:flutter_app/pages/OddsPage.dart';
import 'package:flutter_app/widgets/SelectedOddRow.dart';
import 'package:http/http.dart';

import '../enums/BetPredictionType.dart';
import '../models/User.dart';
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

TextEditingController betAmountController = TextEditingController();

class ParentPageState extends State<ParentPage>{

  User user = User.defUser();

  final getLeaguesWithEventsUrl = 'http://192.168.43.17:8080/betCoreServer/betServer/getLeagues';

  final placeBetUrl = 'http://192.168.43.17:8080/betCoreServer/betServer/placeBet';

  final getUserUrl = 'http://192.168.43.17:8080/betCoreServer/betServer/getUser/USER_ID';

  HashMap eventsPerIdMap = new HashMap<String, MatchEvent>();

  var _allLeagues = <League>[];

  bool showOdds = false;

  List<UserPrediction> _selectedOdds = <UserPrediction>[];

  double _bettingAmount = 0;

  int _selectedPage = 0;

  final List<Widget> pagesList = <Widget>[];

  @override
  void initState() {
    getLeagues();
    getUser();
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
      pagesList.add(OddsPage(_allLeagues, (selectedOdds) =>
          setState(
                  () => _selectedOdds = selectedOdds)));
      pagesList.add(LeaderBoardPage());
      pagesList.add(MyBetsPage(user.userBets, eventsPerIdMap));
    }

    return Scaffold(
      appBar: AppBar(
          title: _allLeagues.isEmpty ? Text('Loading...') : Text((pagesList[_selectedPage] as StatefulWidgetWithName).name + ' - ' + user.username + '('+user.balance.toStringAsFixed(2)+')'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.list), onPressed: null)]
      ),
      body: pagesList[_selectedPage],

      floatingActionButton: FloatingActionButton(
        onPressed: ()=> setState(() {
          if(!showOdds && _selectedOdds.isNotEmpty)
            showOdds = true;
          else
            showOdds = false;
        }),

        backgroundColor: showOdds&&_selectedOdds.isNotEmpty ? Colors.redAccent : Colors.blueAccent,

        child: showOdds&&_selectedOdds.isNotEmpty ? Icon(Icons.remove) : Text(finalOddValue().toStringAsFixed(2), style: TextStyle(fontSize: 16),),
      ),

      bottomSheet:
          showOdds&&_selectedOdds.isNotEmpty ?

          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 300,
              maxHeight: 300,
              minWidth: double.infinity,
              maxWidth: double.infinity
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children : [
                Expanded( flex:10 , child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _selectedOdds.length,
                  itemBuilder: (context, item) {
                    return _buildBettingOddRow(_selectedOdds[item]);
                  })
              ),

                Expanded( flex:2 ,
                    child: Container(margin: EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [

                            Text('To return: ' + (_bettingAmount * finalOddValue()).toStringAsFixed(2)),

                            Flexible(

                              child: TextField(

                                controller: betAmountController,

                                onChanged:
                                    (text) {
                                      setState(() {
                                        try{
                                          double.parse(text);
                                        }catch(e){
                                          _bettingAmount = 0;
                                          return;
                                        }

                                        _bettingAmount = double.parse(text);
                                      });
                                },
                              decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'enter betting amount',
                                ),
                              ),
                            ),

                            TextButton(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent)
                              ),
                              onPressed: () {
                                placeBet();
                              },
                              child: Text('Place Bet'),
                          )
                  ],
                ))
                )

              ]
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


  Widget _buildBettingOddRow(UserPrediction bettingOdd) {

    MatchEvent eventOfOdd = eventsPerIdMap[bettingOdd.eventId];

    return SelectedOddRow(event: eventOfOdd, odd: bettingOdd, callback: (odd) =>
        setState(
                () { _selectedOdds.remove(odd);
                  if (_selectedOdds.isEmpty){
                    showOdds = false;
                  }
                }
        ));

  }

  void getUser() async{
    String getUserUrlFinal = getUserUrl.replaceAll('USER_ID', user.mongoUserId);
    try {
      Response userResponse = await get(Uri.parse(getUserUrlFinal))
          .timeout(const Duration(seconds: 10));
      var responseDec = jsonDecode(userResponse.body);
      User userFromServer = User.fromJson(responseDec);
      setState(() {
        user = userFromServer;
      });

    } catch (e) {
      print(e);
    }
  }

  void getLeagues() async {
    var validData = <League>[];

    try {
      if (_allLeagues.isNotEmpty) {
        return;
      }

      eventsPerIdMap.clear();

      print(getLeaguesWithEventsUrl);
      List jsonLeaguesData = <String>[];
      try {
        Response leaguesResponse = await get(Uri.parse(getLeaguesWithEventsUrl))
            .timeout(const Duration(seconds: 20));
        jsonLeaguesData = jsonDecode(leaguesResponse.body) as List;
      } catch (e) {
        print('ERROR REST');
        validData = MockUtils().mockLeagues();
        setState(() {
          _allLeagues = validData;
          for (League league in _allLeagues){
            for (MatchEvent event in league.getEvents()){
              eventsPerIdMap.putIfAbsent(event.eventId, () => event);
            }
          }
        });
        return;
      }

      for (var leagueElement in jsonLeaguesData) {
        List events = leagueElement['events'];
        List<MatchEvent> leagueEvents = <MatchEvent>[];
        for (var event in events) {
          var eventOdds = event["odd"];
          MatchOdds odds = MatchOdds(odd1: UserPrediction(eventId: event["match_id"],
              betPredictionType: BetPredictionType.homeWin,
              value: double.parse(eventOdds["odd_1"].replaceAll(',', '.'))),//.toString().replaceAll(',', '.')),
              oddX: UserPrediction(eventId: event["match_id"],
                  betPredictionType: BetPredictionType.draw,
                  value:  double.parse(eventOdds["odd_x"].replaceAll(',', '.'))),//.toString().replaceAll(',', '.')),
              odd2: UserPrediction(eventId: event["match_id"],
                  betPredictionType: BetPredictionType.awayWin,
                  value: double.parse(eventOdds["odd_2"].replaceAll(',', '.'))));//.toString().replaceAll(',', '.')));
          var match = MatchEvent(eventId: event["match_id"],
              homeTeam: event["match_hometeam_name"],
              awayTeam: event["match_awayteam_name"],
              odds: odds);
          leagueEvents.add(match);

          eventsPerIdMap.putIfAbsent(match.eventId, () => match);//TODO: If it is already there? we need to clear map.
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

  double finalOddValue() {
    double oddValue = 0;
    for (UserPrediction odd in _selectedOdds){
      double oddCurrent = odd.value;
      if (oddValue == 0){
        oddValue = oddCurrent;
        continue;
      }
      oddValue = oddValue * oddCurrent;
    }

    return oddValue;
  }

   void placeBet() async {
    if (_bettingAmount <= 0 || _selectedOdds.isEmpty){
        return;
    }

    UserBet newBet = UserBet(userMongoId: user.mongoUserId, predictions: _selectedOdds, betAmount: _bettingAmount);
    var encodedBet = jsonEncode(newBet.toJson());

    try {
      var response = await post(Uri.parse(placeBetUrl),
          headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"

            // 'Accept': 'application/json',
            // 'Content-Type': 'application/json; charset=UTF-8',
          },
          body: encodedBet,
          encoding: Encoding.getByName("utf-8")).timeout(
          const Duration(seconds: 20));

      print(response.body.toString());
    }catch(e){
      print(e);
    }



  }


}
