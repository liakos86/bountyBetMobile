import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserBet.dart';
import 'package:flutter_app/models/constants/Constants.dart';
import 'package:flutter_app/models/constants/JsonConstants.dart';
import 'package:flutter_app/models/constants/UrlConstants.dart';
import 'package:flutter_app/models/LeagueWithData.dart';
import 'package:flutter_app/models/context/AppContext.dart';
import 'package:flutter_app/pages/LeaguesInfoPage.dart';
import 'package:flutter_app/pages/OddsPage.dart';
import 'package:flutter_app/widgets/DialogTabbedLoginOrRegister.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/ChangeEvent.dart';
import '../enums/MatchEventStatus.dart';
import '../helper/JsonHelper.dart';
import '../models/ChangeEventSoccer.dart';
import '../models/League.dart';
import '../models/User.dart';
import '../models/UserPrediction.dart';
import '../models/constants/MatchConstants.dart';
import '../models/match_event.dart';
import '../utils/MockUtils.dart';
import '../widgets/DialogSuccessfulBet.dart';
import '../widgets/DialogUserRegistered.dart';
import 'LeaderBoardPage.dart';
import 'LivePage.dart';
import 'MyBetsPage.dart';

  /*
   * The current device locale. It can change at any time by user.
  */
 String? locale;

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
class ParentPageState extends State<ParentPage> with WidgetsBindingObserver {

  
  // AppContext appContext = AppContext();

  String appBarTitle = Constants.empty;

  /*
   * Shared prefs
   */
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  /*
   * The index of the page navigator.
   */
  static int selectedPageIndex = 0;

  /*
   * List of odds in the betslip.
   */
  final List<UserPrediction> selectedOdds = <UserPrediction>[];

  /*
   * The list of pages for the navigator.
   */
  List<Widget> pagesList = <Widget>[];

  /*
   * Following keys provide access to the state of each page.
   */
  static GlobalKey oddsPageKey = GlobalKey();
  static GlobalKey livePageKey = GlobalKey();
  static GlobalKey betsPageKey = GlobalKey();
  static GlobalKey leaderboardPageKey = GlobalKey();
  static GlobalKey leaguesPageKey = GlobalKey();

  /*
   * Fetch the leagues async
   * Fetch the user async
   * When the results are fetched the app will re-build and redraw.
   */
  @override
  void initState() {


     AppContext.eventsPerDayMap. putIfAbsent('-1', () => <LeagueWithData>[]);
     AppContext. eventsPerDayMap.putIfAbsent('0', () => <LeagueWithData>[]);
     AppContext. eventsPerDayMap.putIfAbsent('1', () => <LeagueWithData>[]);


    WidgetsBinding.instance.addObserver(this);
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => setLocale(context));

      pagesList.add(OddsPage(key: oddsPageKey, updateUserCallback: updateUserCallBack, selectedOdds: selectedOdds));
      // pagesList.add(OddsPage(key: oddsPageKey, updateUserCallback: updateUserCallBack, eventsPerDayMap: AppContext.eventsPerDayMap, selectedOdds: selectedOdds));
      pagesList.add(LivePage(key: livePageKey, liveLeagues: AppContext.liveLeagues));
      // pagesList.add(LivePage(key: livePageKey));
      pagesList.add(LeaderBoardPage());
      pagesList.add(MyBetsPage(key: betsPageKey, user: AppContext.user, loginOrRegisterCallback: promptLoginOrRegister));
      pagesList.add(LeaguesInfoPage(key: leaguesPageKey));


      getLeaguesAsync(null)
          .then((leaguesMap) => updateLeagues(leaguesMap))
          .then((updated) => getLeagueEventsAsync(null)
          .then((leagueEventsMap) => updateLeaguesAndLiveMatches(leagueEventsMap)));

      Timer.periodic(const Duration(seconds: 20), (timer) { getLeagueEventsAsync(timer).then((leaguesMap) =>
            updateLeaguesAndLiveMatches(leaguesMap)
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


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    //
    // setState(() {
    //   locale = locales?.first ?? locale;
    // });
  }

  setLocale(BuildContext context) {
    final String localeNew = Platform.localeName;//Localizations.localeOf(context);

    setState(() {
      locale = localeNew;
    });
  }

  static void favouritesUpdate(){
    //if (fromLive){
      oddsPageKey.currentState?.setState(() {
        AppContext.eventsPerDayMap;
      });
    //}

    //if (fromOdds){
      livePageKey.currentState?.setState(() {
        // AppContext.eventsPerDayMap[MatchConstants.KEY_TODAY];
        // AppContext.liveLeagues;
      });
    //}
  }


  void updateUser(User value){

    AppContext.updateUser(value);

    appBarTitle = '${AppContext.user.username}(${AppContext.user.balance.toStringAsFixed(2)})';

    setState(() {
      AppContext.user;
      appBarTitle;
    });

    betsPageKey.currentState?.setState(() {
      AppContext.user;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

          title: Text(appBarTitle) ,
        leading:

            Padding(
              padding: const EdgeInsets.all(8),
              child:
                AppContext.user.mongoUserId == Constants.defMongoUserId ?
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
              index: selectedPageIndex,
              children: [pagesList[0], pagesList[1], pagesList[2], pagesList[3], pagesList[4]]),

      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 20,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blueAccent,
        fixedColor: Colors.white,
        currentIndex: selectedPageIndex,
        items: const [
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
            selectedPageIndex = index;
          });

        },
      ),

    );
  }

  static MatchEvent findEvent(int eventId){

    for (MapEntry dayEntry in AppContext.eventsPerDayMap.entries){
      for (LeagueWithData l in dayEntry.value){
        for (MatchEvent e in l.events){
          if (eventId == e.eventId){
            return e;
          }
        }
      }
    }

    return AppContext.eventsPerDayMap.entries.first.value.events.first;

  }

  Future<User?> getUserAsync() async{
    SharedPreferences sh_prefs =  await prefs;
    String? mongoId = sh_prefs.getString('mongoId');
    if (mongoId == null){//638376a4d9419c54f54ec23f
      setState(() {
        appBarTitle = 'Football';
      });
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

  Future<Map<String, List<LeagueWithData>>> getLeagueEventsAsync(Timer? timer) async {

      Map jsonLeaguesData = LinkedHashMap();

      try {
        Response leaguesResponse = await get(Uri.parse(UrlConstants.GET_LEAGUE_EVENTS)).timeout(const Duration(seconds: 10));
        jsonLeaguesData = await jsonDecode(leaguesResponse.body) as Map;
      } catch (e) {

        print('ERROR REST ---- MOCKING............');
        Map<String, List<LeagueWithData>> validData = MockUtils().mockLeaguesMap(AppContext.eventsPerDayMap, false);
        return validData;
      }

      return await convertJsonLeaguesToObjects(jsonLeaguesData);
  }

  Future<List<League>> getLeaguesAsync(Timer? timer) async {

    List<League> jsonLeaguesData = <League>[];

    try {
      Response leaguesResponse = await get(Uri.parse(UrlConstants.GET_LEAGUES)).timeout(const Duration(seconds: 10));
      Iterable leaguesIterable = json.decode(leaguesResponse.body);
      jsonLeaguesData = List<League>.from(leaguesIterable.map((model)=> JsonHelper.leagueFromJson(model)));
    } catch (e) {

      print('ERROR REST ---- LEAGUES MOCKING............');

    }

    return jsonLeaguesData;
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

    if (user.errorMessage == Constants.empty){
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

  updateUserCallBack(UserBet newBet) {

    getUserAsync().then((value) =>
    {
      if (value != null){
        updateUser(value)
      }
    }
    );

      // showDialog(context: context, builder: (context) =>
      //
      //   AlertDialog(
      //     title: Text('Successful bet'),
      //     content: DialogSuccessfulBet(newBet: newBet),
      //     elevation: 20,
      //   ));
  }

  Future<Map<String, List<LeagueWithData>>> convertJsonLeaguesToObjects(Map jsonLeaguesData) async{
    Map<String, List<LeagueWithData>> newEventsPerDayMap = LinkedHashMap();
    for (MapEntry dailyLeagues in  jsonLeaguesData.entries) {
      String day = dailyLeagues.key;

      var leaguesWithDataJson = dailyLeagues.value;
      List<LeagueWithData> leaguesWithData = <LeagueWithData>[];
      for (var leagueWithData in leaguesWithDataJson) {
        LeagueWithData leagueObj = await JsonHelper.leagueWithDataFromJson(leagueWithData);
        leaguesWithData.add(leagueObj);
      }

      newEventsPerDayMap.putIfAbsent(day, ()=> leaguesWithData);
    }

    return newEventsPerDayMap;
  }

  /*
   * Every X seconds we receive Map which contains all the league matches per day.
   * Key 0 is the today's matches , 1 is tomorrow etc.
   * Since we already have some matches from the previous calls, we have to 
   * 1. Add the new matches we received.
   * 2. Delete the matches that are missing from the previous call.
   * 3. Update the data of the matches that were pre-existing.
   */
  void updateLeaguesAndLiveMatches(Map<String, List<LeagueWithData>> incomingLeaguesMap) {

    if (incomingLeaguesMap.isEmpty) {
      return;//TODO maybe empty everything?
    }

    if (AppContext.eventsPerDayMap.isEmpty){//first incoming matches
      AppContext.eventsPerDayMap['-1'] = incomingLeaguesMap[MatchConstants.KEY_TODAY];
      AppContext.eventsPerDayMap[MatchConstants.KEY_TODAY] = incomingLeaguesMap[MatchConstants.KEY_TODAY];
      AppContext.eventsPerDayMap['1'] = incomingLeaguesMap[MatchConstants.KEY_TODAY];

      for(LeagueWithData league in AppContext.eventsPerDayMap[MatchConstants.KEY_TODAY]){
        if (league.liveEvents.isEmpty){
          continue;
        }

        AppContext.liveLeagues.add(league);
      }

      sortLeagues();
      updatePageStates();

      return;
    }


    List<LeagueWithData> existingTodayLeagues = AppContext.eventsPerDayMap[MatchConstants.KEY_TODAY];
    List<LeagueWithData> incomingTodayLeagues = incomingLeaguesMap[MatchConstants.KEY_TODAY]!;

    for(LeagueWithData incomingLeague in incomingTodayLeagues){

      var existingLeague = existingTodayLeagues.firstWhere((element) => element == incomingLeague, orElse: () => LeagueWithData.defLeague());

      //missing league
      if (existingLeague == LeagueWithData.defLeague()){
          existingTodayLeagues.add(incomingLeague);

          if(incomingLeague.liveEvents.isNotEmpty){
            AppContext.liveLeagues.add(incomingLeague);
          }

          continue;
      }

      List<MatchEvent> existingLiveEventsOfLeague = existingLeague.liveEvents;
      List<MatchEvent> incomingLiveEventsOfLeague = incomingLeague.liveEvents;

      for (MatchEvent existingEvent in List.of(existingLiveEventsOfLeague)){// remove it or copy the fields
        if (!incomingLiveEventsOfLeague.contains(existingEvent)){
          existingLiveEventsOfLeague.remove(existingEvent);
          checkForOddsRemoval([existingEvent]);
        }else{
          //copy fields
          MatchEvent incomingEvent = incomingLiveEventsOfLeague.firstWhere((element) => element == existingEvent);
          existingEvent.copyFrom(incomingEvent);
          existingEvent.calculateLiveMinute();//TODO: do it with timer in live page
        }
      }

      for (MatchEvent incomingEvent in incomingLiveEventsOfLeague){//add if missing
        if (!existingLiveEventsOfLeague.contains(incomingEvent)){
          existingLiveEventsOfLeague.add(incomingEvent);
          incomingEvent.calculateLiveMinute();//TODO: do it with timer in live page
        }
      }
    }

    for(LeagueWithData existingLeague in List.of(existingTodayLeagues)) {//league has to be removed cause new leagues do not contain it
      var incomingLeague = incomingTodayLeagues.firstWhere((
          element) => element == existingLeague,
          orElse: () => LeagueWithData.defLeague());

      if (incomingLeague == LeagueWithData.defLeague()) {
        existingTodayLeagues.remove(existingLeague);

        if (AppContext.liveLeagues.contains(existingLeague)) {
          AppContext.liveLeagues.remove(existingLeague);
        }

        checkForOddsRemoval(existingLeague.events);
      }
    }

    // for(LeagueWithData league in AppContext.eventsPerDayMap[MatchConstants.KEY_TODAY]){//TODO: do in live page
    //   if (league.liveEvents.isEmpty){
    //     AppContext.liveLeagues.remove(league);
    //
    //   }else if (!AppContext.liveLeagues.contains(league)) {
    //     AppContext.liveLeagues.add(league);
    //   }
    // }

    // for (LeagueWithData league in AppContext.liveLeagues){
    //   for (MatchEvent event in league.liveEvents){
    //     event.calculateLiveMinute();
    //   }
    // }


    // AppContext.allLeaguesWithData.clear();
    // AppContext.allLeaguesWithData.addAll(existingTodayLeagues);

    sortLeagues();

    updatePageStates();

  }

  void promptLoginOrRegister() {
    showDialog(context: context, builder: (context) =>

        AlertDialog(
          title: const Text('Welcome'),
          backgroundColor: Colors.blueAccent,
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
          insetPadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.all(2.0),
          buttonPadding: EdgeInsets.zero,
          alignment: Alignment.bottomCenter,
          elevation: 20,
          shape: const RoundedRectangleBorder(
              borderRadius:
              BorderRadius.only(topLeft:
              Radius.circular(10.0), topRight: Radius.circular(10.0))),
          content:

          Builder(
              builder: (context) {
                // Get available height and width of the build area of this widget. Make a choice depending on the size.
                var height = MediaQuery
                    .of(context)
                    .size
                    .height * (2 / 3);
                var width = MediaQuery
                    .of(context)
                    .size
                    .width;
                return SizedBox(width: width, height: height, child: DialogTabbedLoginOrRegister(
                  registerCallback: registedUserCallback,
                  loginCallback: loginUserCallback,)
                );
              }
        )));
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
    if (!mounted){
      return;
    }
    // print('FG Message data: ${message.messageId}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }

    handleFirebaseTopicMessage(message);
  });



  //now we can subscribe to topic
  await FirebaseMessaging.instance.subscribeToTopic("LiveSoccer");

}

  void handleFirebaseTopicMessage(RemoteMessage message) {

    final payload = message.data;
    // print('Received message:$payload ');
    if (payload[JsonConstants.changeEvent] == null){
      return;
    }

    ChangeEventSoccer changeEventSoccer = ChangeEventSoccer.fromJson(payload);

    // for (LeagueWithData l in AppContext.liveLeagues){
    for (LeagueWithData l in AppContext.eventsPerDayMap[MatchConstants.KEY_TODAY]){

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
      relevantEvent.homeTeamScore?.current = changeEventSoccer.homeTeamScore;
      relevantEvent.awayTeamScore?.current = changeEventSoccer.awayTeamScore;

      //TODO should update only one event!
      MatchEvent parentEvent = ParentPageState.findEvent(changeEventSoccer.eventId);
      parentEvent.changeEvent = changeEventSoccer.changeEvent;
      parentEvent.homeTeamScore?.current = changeEventSoccer.homeTeamScore;
      parentEvent.awayTeamScore?.current = changeEventSoccer.awayTeamScore;
    }

    oddsPageKey.currentState?.setState(() {
      AppContext.eventsPerDayMap;
    });

    livePageKey.currentState?.setState(() {
      // AppContext.eventsPerDayMap[MatchConstants.KEY_TODAY];
      AppContext.liveLeagues;
    });
  }

  void sortLeagues() {
    AppContext.eventsPerDayMap.entries.forEach((element) {
      element.value.sort();
    });

    // AppContext.liveLeagues.sort();

//    AppContext.allLeaguesWithData.sort();
  }

  void updatePageStates() {
    oddsPageKey.currentState?.setState(() {
      AppContext.eventsPerDayMap;
    });

    livePageKey.currentState?.setState(() {
      //AppContext.eventsPerDayMap[MatchConstants.KEY_TODAY];
      AppContext.liveLeagues;
    });

    // leaguesPageKey.currentState?.setState(() {
    //   allLeagues;
    // });
  }

  void checkForOddsRemoval(List<MatchEvent> events) {
    if (selectedOdds.isEmpty){
      return;
    }

    int initialSize = selectedOdds.length;

    for(MatchEvent event in events){
      for (UserPrediction prediction in List.of(selectedOdds)){
        if (event.eventId == prediction.eventId){
          selectedOdds.remove(prediction);
        }
      }
    }

    if (initialSize == selectedOdds.length){
      return;
    }

    oddsPageKey.currentState?.setState(() {
      selectedOdds;
    });

  }

  bool updateLeagues(List<League> leagues) {
    for ( League l in leagues){
      AppContext.allLeaguesMap.putIfAbsent(l.league_id, ()=>l);
    }

    return true;
  }


}


