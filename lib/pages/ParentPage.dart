import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserBet.dart';
import 'package:flutter_app/models/constants/UrlConstants.dart';
import 'package:flutter_app/models/league.dart';
import 'package:flutter_app/pages/LeaguesInfoPage.dart';
import 'package:flutter_app/pages/OddsPage.dart';
import 'package:flutter_app/widgets/DialogTabbedLoginOrRegister.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/JsonHelper.dart';
import '../models/User.dart';
import '../models/match_event.dart';
import '../utils/MockUtils.dart';
import '../widgets/DialogSuccessfulBet.dart';
import '../widgets/DialogUserRegistered.dart';
import 'LeaderBoardPage.dart';
import 'LivePage.dart';
import 'MyBetsPage.dart';

class ParentPage extends StatefulWidget{

  @override
  ParentPageState createState() => ParentPageState();
}


List<League> liveMatchesPerLeague = <League>[];

//List<League> _allLeagues = <League>[];

class ParentPageState extends State<ParentPage>{

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  static User user = User.defUser();

  static HashMap eventsPerIdMap = new HashMap<int, MatchEvent>();

  Map eventsPerDayMap = new HashMap<String, List<League>>();

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

      pagesList.add(OddsPage(key: UniqueKey(), loadLeagues: getAllLeaguesCallBack, updateUserCallback: updateUserCallBack, eventsPerDayMap: eventsPerDayMap));
      pagesList.add(LivePage(liveMatchesPerLeague, getLiveEventsCallBack));
      pagesList.add(LeaderBoardPage());
      pagesList.add(MyBetsPage(key: GlobalKey(), user: user));
      pagesList.add(LeaguesInfoPage(getAllLeaguesCallBack));
    // }

    return Scaffold(
      appBar: AppBar(
          title: user.mongoUserId == null ? Text('FOOTBALL') : Text(user.username + '('+user.balance.toStringAsFixed(2)+')'),
        leading: user.mongoUserId != null ? Text('Logout') :
          GestureDetector(
          onTap: () {
            
            showDialog(context: context, builder: (context) =>
            
            AlertDialog(
                title: Text('Login'),
              content: DialogTabbedLoginOrRegister(registerCallback: registedUserCallback, loginCallback: loginUserCallback,),
              elevation: 20,


            ));
          },
          child: Icon(
            Icons.account_circle_outlined,  // add custom icons also
          ),
        ),
      ),
      body:

      /**
       * The following widget guarantees that no reload will be performed between clicks of the bottom bar.
       */
      IndexedStack(
              index: _selectedPage,
              children: [pagesList[0], pagesList[1], pagesList[2], pagesList[3], pagesList[4]],),

      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 20,
        unselectedFontSize: 12,
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

    SharedPreferences sh_prefs =  await prefs;
    //sh_prefs.remove('mongoId');

    String? mongoId = sh_prefs.getString('mongoId');
    if (mongoId == null){
      return;
    }

    String getUserUrlFinal = UrlConstants.GET_USER_URL.replaceAll('USER_ID', mongoId);
    try {
      Response userResponse = await get(Uri.parse(getUserUrlFinal))
          .timeout(const Duration(seconds: 5));
      var responseDec = jsonDecode(userResponse.body);
      User userFromServer = User.fromJson(responseDec);
      setState(() {
        user = userFromServer;

        pagesList.removeAt(3);
        pagesList.insert(3, MyBetsPage(key: GlobalKey(), user: user));

      });

    } catch (e) {
      print(e);
    }
  }

  void getLeagues() async {

    try {
      if (eventsPerDayMap.isNotEmpty) {
        return;
      }

      eventsPerIdMap.clear();
      //eventsPerDayMap.clear();

      // List jsonLeaguesData = <String>[];

      Map jsonLeaguesData = new LinkedHashMap();

      try {
        Response leaguesResponse = await get(Uri.parse(UrlConstants.GET_LEAGUES)).timeout(const Duration(seconds: 5));
        jsonLeaguesData = jsonDecode(leaguesResponse.body) as Map;
      } catch (e) {
        print('ERROR REST ---- MOCKING............');
        Map<String, List<League>> validData = MockUtils().mockLeaguesMap(false);
        User mockUser = MockUtils().mockUser(validData);
        setState(() {
          user = mockUser;
          eventsPerDayMap = validData;
         for (MapEntry entry in eventsPerDayMap.entries) {
           List<League> leagues = entry.value;
           for (League league in leagues) {
             for (MatchEvent event in league.events) {
               eventsPerIdMap.putIfAbsent(event.eventId, () => event);
             }
           }
         }
        });
        return;
      }

     // var league;
      Map<String, List<League>> newEventsPerDayMap = new LinkedHashMap();
      for (MapEntry dailyLeagues in  jsonLeaguesData.entries) {
        String day = dailyLeagues.key;
        var leaguesJson = dailyLeagues.value;
        List<League> leagues = <League>[];
        for (var league in leaguesJson) {
          League leagueObj = JsonHelper.leagueFromJson(league);
          leagues.add(leagueObj);
          for (MatchEvent match in leagueObj.events) {
            eventsPerIdMap.putIfAbsent(match
                .eventId, () => match); //TODO: If it is already there? we need to clear map.
          }
        }

        newEventsPerDayMap.putIfAbsent(day, ()=> leagues);
      }

      setState(() {
        eventsPerDayMap = newEventsPerDayMap;
      });
    } catch (err) {
      print(err);
    }
  }

  void getLive() async {
    var validData = <League>[];

    try {

      List jsonLeaguesData = [];
      try {
        Response leaguesResponse = await get(Uri.parse(UrlConstants.GET_LIVE))
            .timeout(const Duration(seconds: 10));
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
        League liveLeague = JsonHelper.leagueFromJson(league);
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
    return eventsPerDayMap;
  }

  registedUserCallback(User user) {

      Navigator.pop(context);

      String content = '';
      if (user.errorMessage != ''){
        content = user.errorMessage;
      }else{
        content = 'A verification email has been sent to ' + user.email;
      }

      showDialog(context: context, builder: (context) =>

          AlertDialog(
            title: Text('Registration'),
            content: DialogUserRegistered(text: content),
            elevation: 20,
          ));
  }

  loginUserCallback(User user) {

    Navigator.pop(context);

    if (user.errorMessage == ''){
      updateUserMongoId(user.mongoUserId);
      return;
    }

    showDialog(context: context, builder: (context) =>

        AlertDialog(
          title: Text('Login Error'),
          content: DialogUserRegistered(text: user.errorMessage),
          elevation: 20,
        ));

  }

  Future<void> updateUserMongoId(String? mongoId) async {
    final SharedPreferences shprefs = await prefs;
    shprefs.setString('mongoId', mongoId!).then((value) => getUser());
  }


  updateUserCallBack(User userUpdated, UserBet newBet) {
    setState(() {
      user = userUpdated;
    });

    showDialog(context: context, builder: (context) =>

        AlertDialog(
          title: Text('Successful bet'),
          content: DialogSuccessfulBet(newBet: newBet),
          elevation: 20,
        ));


  }
}
