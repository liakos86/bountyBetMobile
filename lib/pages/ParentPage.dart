import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserPrediction.dart';
import 'package:flutter_app/models/UserBet.dart';
import 'package:flutter_app/models/constants/MatchConstants.dart';
import 'package:flutter_app/models/constants/UrlConstants.dart';
import 'package:flutter_app/models/league.dart';
import 'package:flutter_app/pages/OddsPage.dart';
import 'package:flutter_app/widgets/SelectedOddRow.dart';
import 'package:http/http.dart';

import '../enums/BetPredictionType.dart';
import '../helper/JsonHelper.dart';
import '../models/Score.dart';
import '../models/Team.dart';
import '../models/User.dart';
import '../models/match_event.dart';
import '../models/match_odds.dart';
import '../utils/MockUtils.dart';
import '../models/interfaces/StatefulWidgetWithName.dart';
import 'LeaderBoardPage.dart';
import 'LivePage.dart';
import 'LivePage2.dart';
import 'MyBetsPage.dart';

class ParentPage extends StatefulWidget{
  @override
  ParentPageState createState() => ParentPageState();
}

TextEditingController betAmountController = TextEditingController();

class ParentPageState extends State<ParentPage>{

  User user = User.defUser();

  final placeBetUrl = 'http://192.168.1.2:8080/betCoreServer/betServer/placeBet';

  final getUserUrl = 'http://192.168.1.2:8080/betCoreServer/betServer/getUser/USER_ID';

  HashMap eventsPerIdMap = new HashMap<int, MatchEvent>();

  HashMap eventsPerDayMap = new HashMap<int, List<MatchEvent>>();

  List<League> _allLeagues = <League>[];

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


    pagesList.clear();
    if (_allLeagues.isEmpty) {
      pagesList.add(CircularProgressIndicator());
      pagesList.add(CircularProgressIndicator());
      pagesList.add(CircularProgressIndicator());
      pagesList.add(CircularProgressIndicator());
    }else {
      pagesList.add(OddsPage(_allLeagues, eventsPerDayMap, (selectedOdds) =>
          setState(
                  () => _selectedOdds = selectedOdds)));
      var liveMatches = <MatchEvent>[];
      liveMatches.addAll(liveMatches);

      // pagesList.add(LivePage(liveMatches, getLiveEvents));

      pagesList.add(LivePage2());
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
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blueAccent,
        fixedColor: Colors.white,
        currentIndex: _selectedPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Odds'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.live_help),
              label: 'Live'
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
          .timeout(const Duration(seconds: 2));
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

    List<League> validData = <League>[];

    try {
      if (_allLeagues.isNotEmpty) {
        return;
      }

      eventsPerIdMap.clear();
      eventsPerDayMap.clear();

      List jsonLeaguesData = <String>[];
      try {
        Response leaguesResponse = await get(Uri.parse(UrlConstants.GET_LEAGUES))
            .timeout(const Duration(seconds: 4));
        jsonLeaguesData = jsonDecode(leaguesResponse.body) as List;
      } catch (e) {
        print('ERROR REST');
        validData = MockUtils().mockLeagues(false);
        User mockUser = MockUtils().mockUser(validData);
        setState(() {
          user = mockUser;
          _allLeagues = validData;
         for (League league in _allLeagues){
            for (MatchEvent event in league.events){
              eventsPerIdMap.putIfAbsent(event.eventId, () => event);
              }
            }
        });
        return;
      }

      for (var league in jsonLeaguesData) {
        League leagueObj = JsonHelper.leagueFromJson(league);
          validData.add(leagueObj);
          for (MatchEvent match in leagueObj.events) {
            eventsPerIdMap.putIfAbsent(match.eventId, () => match); //TODO: If it is already there? we need to clear map.
          }
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

    }catch(e){
      print(e);
    }



  }

  int dayOfEvent(MatchEvent event) {
    return 1;

  }

  getLiveEvents() {
    var liveList = <MatchEvent>[];
    // liveList.addAll(_liveEvents);
    // print("SENDING LIVE");
    return liveList;
  }


}
