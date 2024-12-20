import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:collection/collection.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserBet.dart';
import 'package:flutter_app/models/constants/Constants.dart';
import 'package:flutter_app/models/constants/JsonConstants.dart';
import 'package:flutter_app/models/LeagueWithData.dart';
import 'package:flutter_app/models/context/AppContext.dart';
import 'package:flutter_app/pages/LeaguesInfoPage.dart';
import 'package:flutter_app/pages/OddsPage.dart';
import 'package:flutter_app/utils/client/HttpActionsClient.dart';
import 'package:flutter_app/widgets/DialogTabbedLoginOrRegister.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/ChangeEvent.dart';
import '../enums/MatchEventStatus.dart';
import '../models/ChangeEventSoccer.dart';
import '../models/League.dart';
import '../models/Section.dart';
import '../models/User.dart';
import '../models/UserPrediction.dart';
import '../models/constants/MatchConstants.dart';
import '../models/match_event.dart';
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




  String appBarTitle = 'FantasyBet';

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
      pagesList.add(LivePage(key: livePageKey, liveLeagues: AppContext.eventsPerDayMap['0']));
      // pagesList.add(LivePage(key: livePageKey));
      pagesList.add(LeaderBoardPage());
      pagesList.add(MyBetsPage(key: betsPageKey, user: AppContext.user, loginOrRegisterCallback: promptLoginOrRegister));
      pagesList.add(LeaguesInfoPage(key: leaguesPageKey));


      // SecureUtils().deleteValue(Constants.accessToken);

      HttpActionsClient.authorizeAsync().then((a) =>

     //  updateUserFromServer();
     //
      HttpActionsClient.getSectionsAsync(null)
          .then((sections) => updateSections(sections))
          .then((updated) => HttpActionsClient.getLeaguesAsync(null))
          .then((leagues) => updateLeagues(leagues))
          .then((updated) => HttpActionsClient.getLeagueEventsAsync(null))
          .then((leagueEventsMap) => updateLeagueMatches(leagueEventsMap))
          .then((updated) => HttpActionsClient.getLeagueLiveEventsAsync(null))
          .then((leaguesMap) =>
          updateLiveLeagueMatches(leaguesMap))
      .then((value) => updateUserFromServer()));


     Timer.periodic(const Duration(seconds: 30), (timer) {
       HttpActionsClient.getSectionsAsync(null)
           .then((secMap) => updateSections(secMap)
       );
     }
     );


     Timer.periodic(const Duration(seconds: 20), (timer) {
       HttpActionsClient.getLeaguesAsync(null)
           .then((leaguesMap) => updateLeagues(leaguesMap)
       );
     }
     );


      Timer.periodic(const Duration(seconds: 20), (timer) {
        HttpActionsClient.getLeagueEventsAsync(timer).then((leaguesMap) =>
            updateLeagueMatches(leaguesMap)
          );
        }
      );


     Timer.periodic(const Duration(seconds: 10), (timer) {

       if (AppContext.eventsPerDayMap['0'].isEmpty){
         return;
       }
       HttpActionsClient.getLeagueLiveEventsAsync(timer).then((leaguesMap) =>
           updateLiveLeagueMatches(leaguesMap)
       );
     }
     );

     Timer.periodic(const Duration(seconds: 30), (timer) {
       updateUserFromServer();
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

    if (AppContext.user.userPosition > 0){
      appBarTitle = ' pos(${AppContext.user.userPosition})$appBarTitle'  ;
    }

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
        // toolbarHeight: 2,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(2.0),
            child: Container(
              color: Colors.grey.shade500,
             height: 1.0,
            )),
          title:RichText(
            text:  TextSpan(
              children: [
                const WidgetSpan(
                  child: ImageIcon(AssetImage('assets/images/money-bag-100.png'), color: Colors.green,)// Icon(Icons.attach_money_outlined, size: 24, color: Colors.green,),
                ),
                TextSpan(
                  text: appBarTitle,
                ),
              ],
            ),
          ),// Text(appBarTitle) ,
        titleTextStyle: const TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold),
        backgroundColor: Colors.black87,
        leading:

            Padding(
             padding: const EdgeInsets.all(4),
              child:

                  FloatingActionButton(
                      heroTag: 'btnParentLogin',
                      onPressed: promptLoginOrRegister,
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.black,
                      mini: true, child:
                        AppContext.user.mongoUserId == Constants.defMongoUserId ?

                          const Icon(Icons.login, color: Colors.white)
                            :
                          const Icon(Icons.settings_rounded, color: Colors.white))

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
        selectedFontSize: 18,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black87,
        fixedColor: Colors.white,
        unselectedItemColor: Colors.white60,
        currentIndex: selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/calendar-100.png')),//  Icon(Icons.home),
            label: 'Calendar'
          ),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/live-100.png')),
              label: 'Live'
          ),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/leaders-100.png')),//  Icon(Icons.home),
              label: 'Leaders'
          ),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/money-bag-100.png')),//  Icon(Icons.home),
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
    //
    //   drawer: Drawer( child: ListView(
    //   // Important: Remove any padding from the ListView.
    //   padding: EdgeInsets.zero,
    //   children: [
    //     const DrawerHeader(
    //       decoration: BoxDecoration(
    //         color: Colors.blue,
    //       ),
    //       child: Text('Drawer Header'),
    //     ),
    //     ListTile(
    //       title: const Text('Item 1'),
    //       onTap: () {
    //         // Update the state of the app.
    //         // ...
    //       },
    //     ),
    //     ListTile(
    //       title: const Text('Item 2'),
    //       onTap: () {
    //         // Update the state of the app.
    //         // ...
    //       },
    //     ),
    //   ],
    // )
    // )
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

    return await HttpActionsClient.getUserAsync(mongoId);
  }

  // Future<Map<int, MatchEvent>> getLeagueLiveEventsAsync(Timer? timer) async {
  //
  //   Map jsonMatchesData = LinkedHashMap();
  //
  //   try {
  //     if (access_token == null) {
  //       access_token = await SecureUtils().retrieveValue(
  //           Constants.accessToken);
  //       await authorizeAsync();
  //       if (access_token == null) {
  //         print('COULD NOT AUTHORIZE ********************************************************************');
  //         return new Map();
  //       }
  //     }
  //
  //     Response liveMatchesResponse = await get(Uri.parse(UrlConstants.GET_LIVE_EVENTS), headers:  {'Authorization': 'Bearer $access_token'}).timeout(const Duration(seconds: 10));
  //     jsonMatchesData = await jsonDecode(liveMatchesResponse.body) as Map;
  //   } catch (e) {
  //     // Fluttertoast.showToast(msg:  'LIVE   ' +e.toString());
  //     print('ERROR REST ---- MOCKING............');
  //     Map<int, MatchEvent> validData = new Map();// MockUtils().mockLeaguesMap(AppContext.eventsPerDayMap, false);
  //     return validData;
  //   }
  //
  //
  //   return await convertJsonLiveMatchesToObjects(jsonMatchesData);
  // }

  // Future<Map<String, List<LeagueWithData>>> getLeagueEventsAsync(Timer? timer) async {
  //
  //     Map jsonLeaguesData = LinkedHashMap();
  //
  //     try {
  //       if (access_token == null) {
  //         access_token = await SecureUtils().retrieveValue(
  //             Constants.accessToken);
  //         await authorizeAsync();
  //         if (access_token == null) {
  //           print('COULD NOT AUTHORIZE ********************************************************************');
  //           return new Map();
  //         }
  //       }
  //
  //       Response leaguesResponse = await get(Uri.parse(UrlConstants.GET_LEAGUE_EVENTS), headers:  {'Authorization': 'Bearer $access_token'}).timeout(const Duration(seconds: 10));
  //       jsonLeaguesData = await jsonDecode(leaguesResponse.body) as Map;
  //     } catch (e) {
  //       // Fluttertoast.showToast(msg: 'EVENTS   ' +e.toString());
  //       print('ERROR REST ---- MOCKING............');
  //       Map<String, List<LeagueWithData>> validData = Map();//  MockUtils().mockLeaguesMap(AppContext.eventsPerDayMap, false);
  //       return validData;
  //     }
  //
  //     return await convertJsonLeaguesToObjects(jsonLeaguesData);
  // }

  // Future<List<League>> getLeaguesAsync(Timer? timer) async {
  //
  //   List<League> jsonLeaguesData = <League>[];
  //
  //   try {
  //     if (access_token == null) {
  //       access_token = await SecureUtils().retrieveValue(
  //           Constants.accessToken);
  //       await authorizeAsync();
  //       if (access_token == null) {
  //         print('COULD NOT AUTHORIZE ********************************************************************');
  //         return jsonLeaguesData;
  //       }
  //     }
  //
  //     Response leaguesResponse = await get(Uri.parse(UrlConstants.GET_LEAGUES), headers:  {'Authorization': 'Bearer $access_token'}).timeout(const Duration(seconds: 10));
  //     Iterable leaguesIterable = json.decode(leaguesResponse.body);
  //     jsonLeaguesData = List<League>.from(leaguesIterable.map((model)=> League.fromJson(model)));
  //   } catch (e) {
  //     // Fluttertoast.showToast(msg:  'LEAGUES   ' +e.toString());
  //     print('ERROR REST ---- LEAGUES MOCKING............');
  //
  //   }
  //
  //   return jsonLeaguesData;
  // }

  // Future<List<Section>> getSectionsAsync(Timer? timer) async {
  //
  //   List<Section> jsonSectionsData = <Section>[];
  //
  //   try {
  //
  //     if (access_token == null) {
  //       access_token = await SecureUtils().retrieveValue(
  //           Constants.accessToken);
  //
  //       if (access_token == null) {
  //         print('COULD NOT AUTHORIZE ********************************************************************');
  //         return jsonSectionsData;
  //       }
  //     }
  //
  //         print('TOKEN ' + access_token!);
  //
  //
  //     String url = UrlConstants.GET_SECTIONS;
  //     Response sectionsHttpResponse = await get(Uri.parse(url),
  //         headers:  {'Authorization': 'Bearer $access_token'}).timeout(const Duration(seconds: 10));
  //     Iterable sectionsIterable = json.decode(sectionsHttpResponse.body);
  //     jsonSectionsData = List<Section>.from(sectionsIterable.map((model)=> Section.fromJson(model)));
  //   } catch (e) {
  //     // Fluttertoast.showToast(msg:  'SECTIONS   ' +e.toString());
  //     print('ERROR REST ---- SECTIONS MOCKING............');
  //
  //   }
  //
  //   return jsonSectionsData;
  // }




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

  // Future<Map<String, List<LeagueWithData>>> convertJsonLeaguesToObjects(Map jsonLeaguesData) async{
  //   Map<String, List<LeagueWithData>> newEventsPerDayMap = LinkedHashMap();
  //   for (MapEntry dailyLeagues in  jsonLeaguesData.entries) {
  //     String day = dailyLeagues.key;
  //
  //     var leaguesWithDataJson = dailyLeagues.value;
  //     List<LeagueWithData> leaguesWithData = <LeagueWithData>[];
  //     for (var leagueWithData in leaguesWithDataJson) {
  //       LeagueWithData? leagueObj = await JsonHelper.leagueWithDataFromJson(leagueWithData);
  //       if (leagueObj == null){
  //         continue;
  //       }
  //       leaguesWithData.add(leagueObj);
  //     }
  //
  //     newEventsPerDayMap.putIfAbsent(day, ()=> leaguesWithData);
  //   }
  //
  //   return newEventsPerDayMap;
  // }

  // Future<Map<int, MatchEvent>> convertJsonLiveMatchesToObjects(Map jsonLeaguesData) async{
  //   Map<int, MatchEvent> newEventsPerDayMap = LinkedHashMap();
  //   for (MapEntry dailyLeagues in  jsonLeaguesData.entries) {
  //     int day = int.parse(dailyLeagues.key);
  //
  //     var leaguesWithDataJson = dailyLeagues.value;
  //
  //     MatchEvent? leagueObj = await MatchEvent.eventFromJson(leaguesWithDataJson);
  //
  //     newEventsPerDayMap.putIfAbsent(day, ()=> leagueObj);
  //   }
  //
  //   return newEventsPerDayMap;
  // }

  /*
   * Every X seconds we receive Map which contains all the league matches per day.
   * Key 0 is the today's matches , 1 is tomorrow etc.
   * Since we already have some matches from the previous calls, we have to 
   * 1. Add the new matches we received.
   * 2. Delete the matches that are missing from the previous call.
   * 3. Update the data of the matches that were pre-existing.
   */
  void updateLeagueMatches(Map<String, List<LeagueWithData>> incomingLeaguesMap) {
    if (incomingLeaguesMap.isEmpty) {
      return; //TODO maybe empty everything?
    }

    AppContext.eventsPerDayMap['-1'] =
    incomingLeaguesMap[MatchConstants.KEY_TODAY];

    AppContext.eventsPerDayMap['1'] =
    incomingLeaguesMap[MatchConstants.KEY_TOMORROW];

    // if (AppContext.eventsPerDayMap.isEmpty) { //first incoming matches
    //   AppContext.eventsPerDayMap['-1'] =
    //   incomingLeaguesMap[MatchConstants.KEY_TODAY];
    //   AppContext.eventsPerDayMap[MatchConstants.KEY_TODAY] =
    //   incomingLeaguesMap[MatchConstants.KEY_TODAY];
    //   AppContext.eventsPerDayMap['1'] =
    //   incomingLeaguesMap[MatchConstants.KEY_TODAY];
    //
    //   for (LeagueWithData league in AppContext.eventsPerDayMap[MatchConstants
    //       .KEY_TODAY]) {
    //     if (league.liveEvents.isEmpty) {
    //       continue;
    //     }
    //
    //     AppContext.liveLeagues.add(league);
    //   }
    //
    //   sortLeagues();
    //   updatePageStates();
    //
    //   return;
    // }


    List<LeagueWithData> existingTodayLeagues = AppContext.eventsPerDayMap[MatchConstants.KEY_TODAY];
    List<LeagueWithData> incomingTodayLeagues = incomingLeaguesMap[MatchConstants.KEY_TODAY]!;

    // print("existing " + existingTodayLeagues.length.toString() + " incoming " + incomingTodayLeagues.length.toString() );

    updateExistingMatchDataFromIncoming(existingTodayLeagues, incomingTodayLeagues);
    // print("upd existing " + existingTodayLeagues.length.toString() + " incoming " + incomingTodayLeagues.length.toString() );

    updateExistingMatchDataFromIncomingMissing(existingTodayLeagues, incomingTodayLeagues);

    for (var element in existingTodayLeagues) {
      //for (var element in element.events) {element.calculateLiveMinute();}
      for (var element in element.events) {element.calculateDisplayStatus(context);}
    }

    sortLeagues();
    updatePageStates();
  }

    void updateLiveLeagueMatches(Map<int, MatchEvent> incomingLiveEventsMap) {

      if (incomingLiveEventsMap.isEmpty) {
        //AppContext.liveLeagues.clear();
      }else {

        Set<int> newAddedLeagueIds = Set();
        Set<int> incomingLiveLeagueIds = Set();

        for (MapEntry incomingLiveEventEntry in incomingLiveEventsMap.entries) {
          MatchEvent incomingLiveEvent = incomingLiveEventEntry.value;
          incomingLiveLeagueIds.add(incomingLiveEvent.leagueId);
          bool eventExistsInCache = false;

          for (LeagueWithData lwt in AppContext.eventsPerDayMap['0']) {//incoming exists then copy
            List<MatchEvent> liveEvents = lwt.events;//.where((element) => element.status == MatchEventStatus.INPROGRESS.statusStr).toList();
            if (liveEvents.contains(incomingLiveEventEntry.value)) {
              eventExistsInCache = true;
              MatchEvent existing = liveEvents.firstWhere((
                  element) => element.eventId == incomingLiveEventEntry.key);
              existing.copyFrom(incomingLiveEvent);
            }

            if (eventExistsInCache){
              break;
            }

          }

          // if (!eventExistsInCache && !newAddedLeagueIds.contains(incomingLiveEventEntry.value.leagueId)) {//means that the related league is also absent
          //
          //   LeagueWithData leagueWithLiveGameToBeAdded = AppContext.eventsPerDayMap[MatchConstants.KEY_TODAY]
          //       .firstWhere((element) =>
          //         element.league.league_id == incomingLiveEventEntry.value.leagueId);
          //
          //   leagueWithLiveGameToBeAdded.events.add(incomingLiveEvent);
          //   AppContext.allLeaguesMap['0'].add(leagueWithLiveGameToBeAdded);
          //   newAddedLeagueIds.add(incomingLiveEventEntry.value.leagueId);
          // }
        }

        // for (LeagueWithData lwt in List.of(AppContext.liveLeagues)) {
        //   if (!incomingLiveLeagueIds.contains(lwt.league.league_id)){
        //     AppContext.liveLeagues.remove(lwt);
        //   }
        // }

        for (var element in AppContext.eventsPerDayMap['0']) {
          for (var element in element.events) {
            element.calculateDisplayStatus(context);
          }
          // for (var element in element.liveEvents) {
          //   element.calculateLiveMinute();
          // }
        }
      }


      AppContext.eventsPerDayMap['0'].sort();
      updatePageStates();
  }

  void promptLoginOrRegister() {
    showDialog(context: context, builder: (context) =>

        AlertDialog(
          // title: const Text('Welcome'),
          backgroundColor: Colors.blueAccent,
          // titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
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
                return SizedBox(width: width, height: height,
                    child:

                    AppContext.user.mongoUserId == Constants.defMongoUserId ?

                    DialogTabbedLoginOrRegister(
                      registerCallback: registedUserCallback,
                      loginCallback: loginUserCallback,
                    )
                        :
                        Text('Hello ' + AppContext.user.username)

                );
              }
        )));
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
    if (message.notification != null) {//we sent only data messages for now
      print('Message also contained a notification: ${message.notification}');
    }

    handleFirebaseTopicMessage(message);
  });



  //now we can subscribe to topic
  await FirebaseMessaging.instance.subscribeToTopic("LiveSoccer").onError((error, stackTrace) => print(error.toString() + stackTrace.toString()));

}

/*

    TODO: Attention!!!!!!!!
    for virtual devices you need to uninstall and install again in order to receive notifications

 */
  void handleFirebaseTopicMessage(RemoteMessage message) {

    final payload = message.data;
    // print('Received message:$payload ');
    if (payload[JsonConstants.changeEvent] == null){
      return;
    }

    ChangeEventSoccer changeEventSoccer = ChangeEventSoccer.fromJson(payload);

    // for (LeagueWithData l in AppContext.liveLeagues){
    for (LeagueWithData l in AppContext.eventsPerDayMap[MatchConstants.KEY_TODAY]){

      List<MatchEvent> events = l.events.where((element) => element.status == MatchEventStatus.INPROGRESS.statusStr).toList();
      MatchEvent? relevantEvent = events.firstWhereOrNull((element) => element.eventId == changeEventSoccer.eventId);
      if (relevantEvent == null){
        continue;
      }

      if (ChangeEvent.MATCH_START == changeEventSoccer.changeEvent){
       // l.liveEvents.add(relevantEvent);
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
      AppContext.eventsPerDayMap['0'];
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
      AppContext.eventsPerDayMap['0'];
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

  bool updateSections(List<Section> sections) {
    // print('SEC:'+ sections.length.toString());

    for ( Section s in sections){
      AppContext.allSectionsMap.putIfAbsent(s.id, ()=>s);
    }

    return true;
  }

  void updateExistingMatchDataFromIncoming(List<LeagueWithData> existingTodayLeagues, List<LeagueWithData> incomingTodayLeagues) {

    for (LeagueWithData incomingLeague in List.of(incomingTodayLeagues)) {

      var existingLeague = existingTodayLeagues.firstWhere((
          element) => element == incomingLeague,
          orElse: () => LeagueWithData.defLeague());

      //missing league, add it to today leagues, also to live if it has live matches
      if (existingLeague.league.league_id == -1) {
       // Fluttertoast.showToast(msg: 'New league:' + incomingLeague.league.name);

        existingTodayLeagues.add(incomingLeague);

        // List<MatchEvent> liveIncoming = incomingLeague.events.where((element) => element.status == MatchEventStatus.INPROGRESS.statusStr).toList();
        // if (!AppContext.liveLeagues.contains(incomingLeague) && liveIncoming.isNotEmpty) {
        //   AppContext.liveLeagues.add(incomingLeague);
        // }

        continue;
      }


      // List<MatchEvent> existingLiveEventsOfLeague = existingLeague.events;


      // List<MatchEvent> existingLiveEventsOfLeague = existingLeague.events.where((element) => element.status == MatchEventStatus.INPROGRESS.statusStr).toList();
      // List<MatchEvent> incomingLiveEventsOfLeague = incomingLeague.events.where((element) => element.status == MatchEventStatus.INPROGRESS.statusStr).toList();

      // List<MatchEvent> incomingLiveEventsOfLeague = incomingLeague.events;


      for (MatchEvent existingEvent in List.of(existingLeague.events)) {

        // match was present, but now is not, remove it or copy the fields
        if (!incomingLeague.events.contains(existingEvent)) {
          existingLeague.events.remove(existingEvent);

          if(existingLeague.events.isEmpty){
            AppContext.eventsPerDayMap['0'].remove(existingLeague);
          }

          checkForOddsRemoval([existingEvent]);
          // Fluttertoast.showToast(msg: 'Event removed from live ' + existingEvent.homeTeam.name);
        } else {
          //match was present and is also now, copy fields
          MatchEvent incomingEvent = incomingLeague.events.firstWhere((
              element) => element == existingEvent);
          existingEvent.copyFrom(incomingEvent);
          incomingLeague.events.remove(incomingEvent);
        }
      }

      for (MatchEvent incomingLiveEvent in List.of(incomingLeague.events)) {
        // match was not existing, add it
        if (!existingLeague.events.contains(incomingLiveEvent)) {
          existingLeague.events.add(incomingLiveEvent);

          incomingLeague.events.remove(incomingLiveEvent);
        }else{
          //match was present and is also now, copy fields
          MatchEvent existingEvent  = existingLeague.events.firstWhere((
              element) => element == incomingLiveEvent);
          existingEvent.copyFrom(incomingLiveEvent);
        }
      }

    }
  }

  void updateExistingMatchDataFromIncomingMissing(List<LeagueWithData> existingTodayLeagues, List<LeagueWithData> incomingTodayLeagues) {
    //league has to be removed cause new leagues do not contain it
    for (LeagueWithData existingLeague in List.of(existingTodayLeagues)) {
      var incomingLeague = incomingTodayLeagues.firstWhere((
          element) => element == existingLeague,
          orElse: () => LeagueWithData.defLeague());

      if (incomingLeague.league.league_id == -1) {
        existingTodayLeagues.remove(existingLeague);

        // if (AppContext.eventsPerDayMap['0'].contains(existingLeague)) {
        //   AppContext.eventsPerDayMap['0'].remove(existingLeague);
        // }

        // Fluttertoast.showToast(msg: 'REMOVING LEAGUE ' + existingLeague.league.name);

        checkForOddsRemoval(existingLeague.events);
      }else{

      }
    }
  }

  void updateUserFromServer() {

    getUserAsync().then((value) =>
    {
      if (value != null){
        updateUser(value)
      }
    }
    );
  }


}




