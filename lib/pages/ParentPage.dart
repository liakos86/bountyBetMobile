import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/constants/UrlConstants.dart';
import 'package:flutter_app/models/league.dart';
import 'package:flutter_app/pages/LeaguesInfoPage.dart';
import 'package:flutter_app/pages/OddsPage.dart';
import 'package:http/http.dart';

import '../helper/JsonHelper.dart';
import '../models/User.dart';
import '../models/match_event.dart';
import '../utils/MockUtils.dart';
import 'LeaderBoardPage.dart';
import 'LivePage.dart';
import 'MyBetsPage.dart';

class ParentPage extends StatefulWidget{

  @override
  ParentPageState createState() => ParentPageState();
}


List<League> liveMatchesPerLeague = <League>[];

List<League> _allLeagues = <League>[];

class ParentPageState extends State<ParentPage>{

  User user = User.defUser();

  static HashMap eventsPerIdMap = new HashMap<int, MatchEvent>();

  HashMap eventsPerDayMap = new HashMap<int, List<MatchEvent>>();

  int _selectedPage = 0;

  final List<Widget> pagesList = <Widget>[];

  @override
  void initState() {
   getLeagues();
    getUser();

    Timer.periodic(Duration(seconds: 5), (timer) {
      getLive();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

      pagesList.add(OddsPage(key: UniqueKey(), loadLeagues: getAllLeaguesCallBack, eventsPerDayMap: eventsPerDayMap));
      pagesList.add(LivePage(liveMatchesPerLeague, getLiveEventsCallBack));
      pagesList.add(LeaderBoardPage());
      pagesList.add(MyBetsPage(user.userBets, eventsPerIdMap));
      pagesList.add(LeaguesInfoPage(getAllLeaguesCallBack));
    // }

    return Scaffold(
      appBar: AppBar(
          title: _allLeagues.isEmpty ? Text('Loading...') : Text('FIX TITLE' + ' - ' + user.username + '('+user.balance.toStringAsFixed(2)+')'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.list), onPressed: null)]
      ),
      body:
            IndexedStack(
              index: _selectedPage,
              children: [pagesList[0], pagesList[1], pagesList[2], pagesList[3], pagesList[4]],),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: ()=> setState(() {
      //     if(!showOdds && selectedOdds.isNotEmpty) {
      //       showOdds = true;
      //     }else {
      //       showOdds = false;
      //     }
      //   }),
      //
      //   backgroundColor: showOdds&&selectedOdds.isNotEmpty ? Colors.redAccent : Colors.blueAccent,
      //
      //   child: showOdds&&selectedOdds.isNotEmpty ? Icon(Icons.remove) : Text(BetUtils.finalOddOf(selectedOdds).toStringAsFixed(2), style: TextStyle(fontSize: (BetUtils.finalOddOf(selectedOdds )  < 100) ? 16 : (BetUtils.finalOddOf(selectedOdds )  < 1000) ? 15 : 12)),
      // ),

      // bottomSheet:
      //     BetSlipBottom(key: UniqueKey(), showOdds: showOdds, selectedOdds: selectedOdds, callbackForBetPlacement: placeBetCallback, callbackForBetRemoval: removeOddCallback,)
      // ,

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
          BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard),
              label: 'Leagues'
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

  void getUser() async{
    String getUserUrlFinal = UrlConstants.GET_USER_URL.replaceAll('USER_ID', user.mongoUserId);
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

        League leagueObj = JsonHelper.leagueFromJson(league, context);
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

  //   void removeOddCallback(UserPrediction toRemove){
  //
  //     setState(() {
  //       selectedOdds.remove(toRemove);
  //       print('REMOVED ' + toRemove.toString());
  //       if (selectedOdds.isEmpty){
  //         showOdds = false;
  //       }
  //
  //     });
  //
  //   }
  //
  //   void fixOddsCallback(int eventId, UserPrediction? selectedOdd) {
  //
  //     setState(() => {
  //
  //           for (UserPrediction up in new List.of(selectedOdds)){
  //           if (eventId == up.eventId){
  //           selectedOdds.remove(up)
  //           }
  //           },
  //
  //           if (selectedOdd != null){
  //           selectedOdds.add(selectedOdd)
  //           }
  //
  //           }
  //
  //     );
  //
  //   }
  //
  //  void placeBetCallback(double bettingAmount) async {
  //   if (bettingAmount <= 0 || selectedOdds.isEmpty){
  //       return;
  //   }
  //
  //   UserBet newBet = UserBet(userMongoId: user.mongoUserId, predictions: selectedOdds, betAmount: bettingAmount);
  //   var encodedBet = jsonEncode(newBet.toJson());
  //
  //   try {
  //      await post(Uri.parse(UrlConstants.POST_PLACE_BET),
  //         headers: {
  //         "Accept": "application/json",
  //         "Content-Type": "application/json"
  //
  //           // 'Accept': 'application/json',
  //           // 'Content-Type': 'application/json; charset=UTF-8',
  //         },
  //         body: encodedBet,
  //         encoding: Encoding.getByName("utf-8")).timeout(
  //         const Duration(seconds: 20));
  //
  //   }catch(e){
  //     print(e);
  //   }
  // }

  void getLive() async {
    var validData = <League>[];

    try {

      List jsonLeaguesData = [];
      try {
        Response leaguesResponse = await get(Uri.parse(UrlConstants.GET_LIVE))
            .timeout(const Duration(seconds: 5));
        jsonLeaguesData = jsonDecode(leaguesResponse.body) as List;
      } catch (e) {
        print(e);
        List<League> leagues = MockUtils().mockLeagues(true);
      //  setState(() {
          liveMatchesPerLeague = leagues;
        //});
        return;
      }

      for (var league in jsonLeaguesData) {
        League liveLeague = JsonHelper.leagueFromJson(league, context);
        validData.add(liveLeague);
      }

  //    setState(() {
        liveMatchesPerLeague = validData;
    //  });
    } catch (err) {
      print(err);
    }
  }

  getLiveEventsCallBack() {
    return liveMatchesPerLeague;
  }

  getAllLeaguesCallBack(){
    return _allLeagues;
  }


}
