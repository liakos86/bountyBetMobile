import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserBet.dart';
import 'package:flutter_app/models/constants/Constants.dart';
import 'package:flutter_app/models/constants/UrlConstants.dart';
import 'package:flutter_app/models/league.dart';
import 'package:flutter_app/pages/LeaguesInfoPage.dart';
import 'package:flutter_app/pages/OddsPage.dart';
import 'package:flutter_app/widgets/DialogTabbedLoginOrRegister.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/ChangeEvent.dart';
import '../enums/MatchEventStatus.dart';
import '../helper/JsonHelper.dart';
import '../models/ChangeEventSoccer.dart';
import '../models/User.dart';
import '../models/match_event.dart';
import '../utils/MockUtils.dart';
import '../widgets/DialogSuccessfulBet.dart';
import '../widgets/DialogUserRegistered.dart';
import 'LeaderBoardPage.dart';
import 'LivePage.dart';
import 'MyBetsPage.dart';


class ParentPage extends StatefulWidget {

  @override
  ParentPageState createState() => ParentPageState();
}

/*
 * This page holds a bottom page navigator which traverses an array of page widgets.
 * 1. Odds page
 * 2. Live page
 * 3. Leader board page
 * 4. My bets page
 * 5. Leagues' info page
 */
class ParentPageState extends State<ParentPage> {

  /*
   * Following keys provide access to the state of each page.
   */
  GlobalKey oddsPageKey = GlobalKey();
  GlobalKey livePageKey = GlobalKey();
  GlobalKey betsPageKey = GlobalKey();
  GlobalKey leaderboardPageKey = GlobalKey();
  GlobalKey leaguesPageKey = GlobalKey();

  /*
   * Shared prefs
   */
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  /*
   * User with bets etc.
   */
  static User user = User.defUser();

  /*
   * Map with keys the dates and values the List of leagues for each date.
   */
  static Map eventsPerDayMap = HashMap<String, List<League>>();

  /*
   * The leagues which contain live games, only with the live games.
   */
  final List<League> liveLeagues = <League>[];

  /*
   * All the leagues with standings etc.
   */
  List<League> allLeagues = <League>[];

  /*
   * The index of the page navigator.
   */
  int _selectedPage = 0;

  /*
   * The list of pages for the navigator.
   */
  List<Widget> pagesList = <Widget>[];

  /*
   * Fetch the leagues async
   * Fetch the user async
   * When the results are fetched the app will re-build and redraw.
   */
  @override
  void initState() {
    super.initState();

      pagesList.add(OddsPage(key: oddsPageKey, updateUserCallback: updateUserCallBack, eventsPerDayMap: eventsPerDayMap));
      pagesList.add(LivePage(key: livePageKey, liveLeagues: liveLeagues));
      pagesList.add(LeaderBoardPage());
      pagesList.add(MyBetsPage(key: betsPageKey, user: user, loginOrRegisterCallback: promptLoginOrRegister));
      pagesList.add(LeaguesInfoPage(key: leaguesPageKey, allLeagues: allLeagues));


      getLeaguesAsync(null).then((leaguesMap) => UpdateLeaguesAndLiveMatches(leaguesMap));

      Timer.periodic(const Duration(seconds: 20), (timer) { getLeaguesAsync(timer).then((leaguesMap) =>
            UpdateLeaguesAndLiveMatches(leaguesMap)
          );
        }
      );


      getUserAsync().then((value) =>
      {
        if (value != null){
          updateUser(value)
        }
      }
      );

     Timer.periodic(const Duration(seconds: 30), (timer) {

       getUserAsync().then((value) =>
       {
          if (value != null){
            updateUser(value)
          }
        }
        );

      });

      setupFirebaseListeners();

  }

  void updateUser(User value){

    user.username = value.username;
    user.userBets.clear();
    user.userBets.addAll(value.userBets);
    user.validated = value.validated;

    user.email = value.email;
    user.balance = value.balance;
    user.mongoUserId = value.mongoUserId;
    user.errorMessage = value.errorMessage;

    setState(() {
      user;
    });

    betsPageKey.currentState?.setState(() {
      user;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

          title: user.mongoUserId == Constants.defMongoUserId ? Text('Football') : Text(user.username + '('+user.balance.toStringAsFixed(2)+')'),
        leading:

            Padding(
              padding: const EdgeInsets.all(8),
              child:
                user.mongoUserId == Constants.defMongoUserId ?
                  FloatingActionButton(
                      heroTag: 'btnParentLogin',
                      onPressed: promptLoginOrRegister,
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.black,
                      mini: true, child: const Icon(Icons.login, color: Colors.white))
                      :
                  FloatingActionButton(
                      heroTag: 'btnParentLogout',
                      onPressed: promptLogout,
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.black,
                      mini: true, child: const Icon(Icons.logout, color: Colors.white))

            )


      ),

      body:

      /**
       * The following widget guarantees that no reload will be performed between clicks of the bottom bar.
       */
      IndexedStack(
              index: _selectedPage,
              children: [pagesList[0], pagesList[1], pagesList[2], pagesList[3], pagesList[4]]),

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

  static MatchEvent findEvent(int eventId){

    for (MapEntry dayEntry in eventsPerDayMap.entries){
      for (League l in dayEntry.value){
        for (MatchEvent e in l.events){
          if (eventId == e.eventId){
            return e;
          }
        }
      }
    }

    return eventsPerDayMap.entries.first.value.events.first;

  }

  Future<User?> getUserAsync() async{
    SharedPreferences sh_prefs =  await prefs;
    String? mongoId = sh_prefs.getString('mongoId');
    if (mongoId == null){//638376a4d9419c54f54ec23f
      return null;
    }

    String getUserUrlFinal = UrlConstants.GET_USER_URL + mongoId;
    try {
      Response userResponse = await get(Uri.parse(getUserUrlFinal)).timeout(const Duration(seconds: 10));
      var responseDec = await jsonDecode(userResponse.body);
      return User.fromJson(responseDec);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map<String, List<League>>> getLeaguesAsync(Timer? timer) async {

      Map jsonLeaguesData = LinkedHashMap();

      try {
        Response leaguesResponse = await get(Uri.parse(UrlConstants.GET_LEAGUES)).timeout(const Duration(seconds: 10));
        jsonLeaguesData = await jsonDecode(leaguesResponse.body) as Map;
      } catch (e) {

        print('ERROR REST ---- MOCKING............');
        Map<String, List<League>> validData = MockUtils().mockLeaguesMap(eventsPerDayMap, false);
        return validData;
      }

      return await convertJsonLeaguesToObjects(jsonLeaguesData);
  }

  registedUserCallback(User user) {

      Navigator.pop(context);

      String content = Constants.empty;
      if (user.errorMessage != Constants.empty){
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

      updateUserMongoId(user);

  }

  loginUserCallback(User user) async{

    Navigator.pop(context);

    if (user.errorMessage == ''){
      await updateUserMongoId(user);
      return;
    }

    showDialog(context: context, builder: (context) =>

        AlertDialog(
          title: Text('Login Error'),
          content: DialogUserRegistered(text: user.errorMessage),
          elevation: 20,
        ));

  }

  Future<void> updateUserMongoId(User user) async {
    final SharedPreferences shprefs = await prefs;
    shprefs.setString('mongoId', user.mongoUserId);

    updateUser(user);
  }

  updateUserCallBack(User userUpdated, UserBet newBet) {

      updateUser(userUpdated);

      showDialog(context: context, builder: (context) =>

        AlertDialog(
          title: Text('Successful bet'),
          content: DialogSuccessfulBet(newBet: newBet),
          elevation: 20,
        ));
  }

  Future<Map<String, List<League>>> convertJsonLeaguesToObjects(Map jsonLeaguesData) async{
    Map<String, List<League>> newEventsPerDayMap = LinkedHashMap();
    for (MapEntry dailyLeagues in  jsonLeaguesData.entries) {
      String day = dailyLeagues.key;

      var leaguesJson = dailyLeagues.value;
      List<League> leagues = <League>[];
      for (var league in leaguesJson) {
        League leagueObj = JsonHelper.leagueFromJson(league);
        leagues.add(leagueObj);
      }

      newEventsPerDayMap.putIfAbsent(day, ()=> leagues);
    }

    return newEventsPerDayMap;
  }

  void UpdateLeaguesAndLiveMatches(Map<String, List<League>> incomingLeaguesMap) {

    if (incomingLeaguesMap.isEmpty) {
      return;//TODO maybe empty everything?
    }

    if (eventsPerDayMap.isEmpty){//first incoming matches
      eventsPerDayMap['-1'] = incomingLeaguesMap[Constants.todayLeaguesKey];
      eventsPerDayMap[Constants.todayLeaguesKey] = incomingLeaguesMap[Constants.todayLeaguesKey];
      eventsPerDayMap['1'] = incomingLeaguesMap[Constants.todayLeaguesKey];

      for(League league in eventsPerDayMap[Constants.todayLeaguesKey]){
        if (league.liveEvents.isEmpty){
          continue;
        }

        liveLeagues.add(league);
      }

      sortLeagues();
      updatePageStates();

      return;
    }


    List<League> existingTodayLeagues = eventsPerDayMap[Constants.todayLeaguesKey];
    List<League> incomingTodayLeagues = incomingLeaguesMap[Constants.todayLeaguesKey]!;

    for(League incomingLeague in incomingTodayLeagues){

      var existingLeague = existingTodayLeagues.firstWhere((element) => element == incomingLeague, orElse: () => League.defLeague());

      //missing league
      if (existingLeague == League.defLeague()){
          existingTodayLeagues.add(incomingLeague);
          continue;
      }

      List<MatchEvent> existingLiveEventsOfLeague = existingLeague.liveEvents;
      List<MatchEvent> incomingLiveEventsOfLeague = incomingLeague.liveEvents;

      for (MatchEvent existingEvent in List.of(existingLiveEventsOfLeague)){// remove it or copy the fields
        if (!incomingLiveEventsOfLeague.contains(existingEvent)){
          existingLiveEventsOfLeague.remove(existingEvent);
        }else{
          //copy fields
          MatchEvent incomingEvent = incomingLiveEventsOfLeague.firstWhere((element) => element == existingEvent);
          existingEvent.copyFrom(incomingEvent);
        }
      }

      for (MatchEvent incomingEvent in incomingLiveEventsOfLeague){//add if missing
        if (!existingLiveEventsOfLeague.contains(incomingEvent)){
          existingLiveEventsOfLeague.add(incomingEvent);
        }
      }

    }

    for(League existingLeague in List.of(existingTodayLeagues)) {//league has to be removed
      var incomingLeague = incomingTodayLeagues.firstWhere((
          element) => element == existingLeague,
          orElse: () => League.defLeague());

      if (incomingLeague == League.defLeague()) {
        existingTodayLeagues.remove(existingLeague);
        liveLeagues.remove(existingLeague);
      }
    }

    for(League league in eventsPerDayMap[Constants.todayLeaguesKey]){
      if (league.liveEvents.isEmpty){
        liveLeagues.remove(league);

      }else if (!liveLeagues.contains(league)) {
        liveLeagues.add(league);
      }
    }

    for (League league in liveLeagues){
      for (MatchEvent event in league.liveEvents){
        event.calculateLiveMinute();
      }
    }


    allLeagues.clear();
    allLeagues.addAll(existingTodayLeagues);

    sortLeagues();

    updatePageStates();



  }

  void promptLoginOrRegister() {
    showDialog(context: context, builder: (context) =>

        AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          title: const Text('Login'),
          content: DialogTabbedLoginOrRegister(registerCallback: registedUserCallback, loginCallback: loginUserCallback,),
          elevation: 20,


        ));
  }

  void promptLogout() {
    showDialog(context: context, builder: (context) =>

        const AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          elevation: 20,
        ));
  }

  void updateLiveMatches(eventsPerDayMap) {}

/**
 *
 * FIREBASE
 */

void setupFirebaseListeners() async{


  //handler for app in foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('FG Message data: ${message.messageId}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }

    handleFirebaseTopicMessage(message);
  });

  //now we can subscribe to topic
  await FirebaseMessaging.instance.subscribeToTopic("MatchEventsLiveSoccer");

}


  void handleFirebaseTopicMessage(RemoteMessage message) {

    final payload = message.data;
    final jsonValues = json.decode(payload['changeEvent']);
    ChangeEventSoccer changeEventSoccer = ChangeEventSoccer.fromJson(jsonValues);
    // print('Received message:$payload from topic: ${c[0].topic}>');

    if (!mounted){
      return;
    }

    for (League l in liveLeagues){

      List<MatchEvent> events = l.liveEvents;
      MatchEvent? relevantEvent;
      for(MatchEvent e in events){
        if (e.eventId == changeEventSoccer.eventId){
          relevantEvent = e;
          break;
        }
      }

      if (relevantEvent == null){
        continue;
      }

      if (ChangeEvent.MATCH_START == changeEventSoccer.changeEvent){
        l.liveEvents.add(relevantEvent);
        relevantEvent.status = MatchEventStatus.INPROGRESS.statusStr;
      }

      relevantEvent.changeEvent = changeEventSoccer.changeEvent;
      relevantEvent.homeTeamScore = changeEventSoccer.homeTeamScore;
      relevantEvent.awayTeamScore = changeEventSoccer.awayTeamScore;

      MatchEvent parentEvent = ParentPageState.findEvent(changeEventSoccer.eventId);
      parentEvent.changeEvent = changeEventSoccer.changeEvent;
      parentEvent.homeTeamScore = changeEventSoccer.homeTeamScore;
      parentEvent.awayTeamScore = changeEventSoccer.awayTeamScore;
    }

    oddsPageKey.currentState?.setState(() {
      eventsPerDayMap;
    });

    livePageKey.currentState?.setState(() {
      liveLeagues;
    });
  }

  void sortLeagues() {
    eventsPerDayMap.entries.forEach((element) {
      element.value.sort();
    });

    liveLeagues.sort();

    allLeagues.sort();
  }

  void updatePageStates() {
    oddsPageKey.currentState?.setState(() {
      eventsPerDayMap;
    });

    livePageKey.currentState?.setState(() {
      liveLeagues;
    });

    leaguesPageKey.currentState?.setState(() {
      allLeagues;
    });
  }


}


