import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserBet.dart';
import 'package:flutter_app/models/constants/Constants.dart';
import 'package:flutter_app/models/constants/JsonConstants.dart';
import 'package:flutter_app/models/LeagueWithData.dart';
import 'package:flutter_app/models/constants/PurchaseConstants.dart';
import 'package:flutter_app/models/context/AppContext.dart';
import 'package:flutter_app/pages/OddsPage.dart';
import 'package:flutter_app/utils/client/HttpActionsClient.dart';
import 'package:flutter_app/widgets/DialogTabbedLoginOrRegister.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../enums/ChangeEvent.dart';
import '../enums/MatchEventStatus.dart';
import '../helper/SharedPrefs.dart';
import '../models/FantasyLeague.dart';
import '../models/notification/ChangeEventSoccer.dart';
import '../models/League.dart';
import '../models/Section.dart';
import '../models/User.dart';
import '../models/UserPrediction.dart';
import '../models/constants/ColorConstants.dart';
import '../models/constants/MatchConstants.dart';
import '../models/match_event.dart';
import '../utils/DateUtils.dart';
import '../widgets/DialogUserRegistered.dart';
import '../widgets/custom/FantasyTipsDrawer.dart';
import '../widgets/dialog/DialogTextWithButtons.dart';
import '../widgets/row/DialogProgressBarWithText.dart';
import 'LeaderBoardPage.dart';
import 'LivePage.dart';
import 'MyBetsPage.dart';
import 'MyFantasyLeaguesPage.dart';

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

  // final InAppPurchase inAppPurchase = InAppPurchase.instance;
  // List<ProductDetails> products = [];
  // List<PurchaseDetails> purchases = [];
  // StreamSubscription<List<PurchaseDetails>>? subscription;
  // bool available = false;
  String appBarTitle = 'FantasyTips';
  User user = AppContext.user;

  /*
   * Shared prefs
   */
  // Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  /*
   * The index of the page navigator.
   */
  static int selectedPageIndex = 0;

  bool isMinimized = false;

  bool loadingAfterResume = false;

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
  static GlobalKey leaderBoardPageKey = GlobalKey();
  static GlobalKey fantasyLeaguesPageKey = GlobalKey();

  updateConnState(bool conn){

    if (!conn) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Network connection lost'), showCloseIcon: true, duration: Duration(seconds: 5),
      ));
    }

  }

  /*
   * Fetch the leagues async
   * Fetch the user async
   * When the results are fetched the app will re-build and redraw.
   */
  @override
  void initState() {

    retrieveUserFromPrefs();

    HttpActionsClient.listenConnChanges(updateConnState);


   AppContext.eventsPerDayMap. putIfAbsent(DateUtilsFt.formattedDateWithOffset(-2), () => <LeagueWithData>[]);
   AppContext.eventsPerDayMap. putIfAbsent(DateUtilsFt.formattedDateWithOffset(-1), () => <LeagueWithData>[]);
   AppContext.eventsPerDayMap.putIfAbsent(DateUtilsFt.formattedDateWithOffset(0), () => <LeagueWithData>[]);
   AppContext.eventsPerDayMap.putIfAbsent(DateUtilsFt.formattedDateWithOffset(1), () => <LeagueWithData>[]);
   AppContext.eventsPerDayMap.putIfAbsent(DateUtilsFt.formattedDateWithOffset(2), () => <LeagueWithData>[]);

   // print('Calling init state ' + AppContext.eventsPerDayMap.keys.toList().length.toString());
   // print('init state date ' + AppContext.eventsPerDayMap.keys.toList()[0] +' / '+ AppContext.eventsPerDayMap.keys.toList()[1] + ' / ' + AppContext.eventsPerDayMap.keys.toList()[2]);

  WidgetsBinding.instance.addObserver(this);

  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) => setLocale(context));

  pagesList.add(OddsPage(key: oddsPageKey, updateUserCallback: updateUserCallBack, loginUserCallback: loginUserCallback, registerUserCallback: registerUserCallback, selectedOdds: selectedOdds));
  pagesList.add(LivePage(key: livePageKey, liveLeagues: AppContext.liveLeagues));
  pagesList.add(LeaderBoardPage());
  pagesList.add(MyFantasyLeaguesPage(key: fantasyLeaguesPageKey, loginOrRegisterCallback: promptLoginOrRegister, fantasyLeague: AppContext.fantasyLeague));

  HttpActionsClient.authorizeAsync().then((a) =>

  HttpActionsClient.getSectionsAsync(null)
      .then((sections) => updateSections(sections))
      .then((updated) => HttpActionsClient.getLeaguesAsync(null))
      .then((leagues) => updateLeagues(leagues))
      .then((updated) => HttpActionsClient.getLeagueEventsAsync(null))
      .then((leagueEventsMap) => updateLeagueMatches(leagueEventsMap))
      .then((updated) => HttpActionsClient.getLeagueLiveEventsAsync(null))
      .then((leaguesMap) =>
      updateLiveLeagueMatches(leaguesMap)));

      schedulePeriodicUpdates();

      setupFirebaseListeners();

  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // subscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      // App is minimized or moved to the background
      setState(() {
        isMinimized = true;
      });
    } else if (state == AppLifecycleState.resumed) {
      // App is active again
      print('RESUMED!!!!!!!');
      setState(() {
        loadingAfterResume = true;
        isMinimized = false;
      });

      HttpActionsClient.getLeagueLiveEventsAsync(null).then((leaguesMap) =>
          updateLiveLeagueMatches(leaguesMap)
      );

      HttpActionsClient.getLeagueEventsAsync(null).then((leaguesMap) =>
          updateLeagueMatches(leaguesMap)
      );
    }
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
  }

  setLocale(BuildContext context) {
    final String localeNew = Platform.localeName;//Localizations.localeOf(context);

    setState(() {
      locale = localeNew;
    });
  }

  static void favouritesUpdate(){
      sortLeagues();

      oddsPageKey.currentState?.setState(() {
        AppContext.eventsPerDayMap;
        AppContext.allLeaguesMap;
      });

      livePageKey.currentState?.setState(() {
        // AppContext.eventsPerDayMap;
        // AppContext.allLeaguesMap;
        AppContext.liveLeagues;
      });
  }


  Future<void> updateUser(User value) async {

    user.deepCopyFrom(value);


    if (user.mongoUserId == Constants.defMongoId) {
      AppContext.fantasyLeague.copyFrom(FantasyLeague.defLeague());
    }

    if (user.mongoUserId == Constants.defMongoId ){
     // updateUserMongoId(value);
      appBarTitle = AppLocalizations.of(context)!.football;
    } else if (!user.validated){
      appBarTitle = '[${AppLocalizations.of(context)!.validation_pending}]';
    }else {// if (AppContext.user.balance.position > 0){
      appBarTitle = '${AppLocalizations.of(context)!.position}[${AppContext.user.globalPosition}${AppLocalizations.of(context)!.out_of}${AppContext.user.totalUsers.toString()}]'  ;
    }

    if (!mounted){
      return;
    }

    setState(() {
      user;
      appBarTitle;
    });

    betsPageKey.currentState?.setState(() {
      AppContext.user.userBets;
    });

    leaderBoardPageKey.currentState?.setState(() {
      AppContext.user;
    });

    fantasyLeaguesPageKey.currentState?.setState(() {
      AppContext.user;
      AppContext.fantasyLeague;
    });

  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 2,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(2.0),
            child:

          Container(
              color: Colors.grey.shade500,
             height: 0.0,
            )

      ),
          title:

          Row(
            children: [
          Expanded(
          child:

          RichText(
            text:  TextSpan(

              children: [

                TextSpan(
                  text: appBarTitle,
                ),

                const WidgetSpan(child: SizedBox(width: 8)),

                if (AppContext.user.mongoUserId != User.defUser().mongoUserId
                && AppContext.user.validated)
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle, // Align icon with text
                    child:
                    AppContext.user.fantasyBalance.positionDelta >= 0 ?
                    const Icon(
                      Icons.arrow_circle_up, // Replace with desired icon
                      size: 20,
                      color: Color(ColorConstants.my_blue),
                    )
                        :
                    const Icon(
                      Icons.arrow_circle_down, // Replace with desired icon
                      size: 20,
                      color: Colors.redAccent,
                    )
                  ),


                if (AppContext.user.mongoUserId != User.defUser().mongoUserId
                    && AppContext.user.validated)
                  TextSpan(
                    text: AppContext.user.fantasyBalance.positionDelta >= 0 ? ' +${AppContext.user.fantasyBalance.positionDelta}' : ' ${AppContext.user.fantasyBalance.positionDelta}',
                    style: TextStyle(color: AppContext.user.fantasyBalance.positionDelta >= 0 ? const Color(ColorConstants.my_blue) : Colors.redAccent)
                  ),

                const WidgetSpan(child: SizedBox(width: 8)),

               ]))),

                      ]
          ),
        titleTextStyle: const TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold),
        backgroundColor: Colors.black87,
        leading:

        Builder(
            builder: (BuildContext context) {

    return

    Padding(
    padding: const EdgeInsets.all(4),
    child:

    user.mongoUserId == Constants.defMongoId

        ?


    FloatingActionButton(
    heroTag: 'btnParentLogin',
    onPressed: promptLoginOrRegister,
    backgroundColor: const Color(ColorConstants.my_blue),
    foregroundColor: Colors.black,
    mini: true, child:
    AppContext.user.mongoUserId == Constants.defMongoId ?

    const Icon(Icons.login, color: Colors.white)
        :
    const Icon(Icons.settings_rounded, color: Colors.white))

        :

    IconButton(
    icon: const Icon(Icons.menu),
    color: Colors.white,// This is the burger icon
    onPressed: () {
    Scaffold.of(context).openDrawer(); // Opens the drawer
    },
    ),

    );
    }
        )

      ),

      body:

         (loadingAfterResume)?
       DialogProgressText(text:  AppLocalizations.of(context)!.loading)
    :

      /**
       * The following widget guarantees that no reload will be performed between clicks of the bottom bar.
       */
      IndexedStack(
              index: selectedPageIndex,
              children: [pagesList[0], pagesList[1], pagesList[2], pagesList[3]]),

      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 18,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black87,
        fixedColor: Colors.white,
        unselectedItemColor: Colors.white60,
        currentIndex: selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.date_range_outlined),//ImageIcon(AssetImage('assets/images/calendar-100.png')),//  Icon(Icons.home),
            label: AppLocalizations.of(context)!.matches
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.local_fire_department),// ImageIcon(AssetImage('assets/images/live-100.png')),
              label: AppLocalizations.of(context)!.live
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.leaderboard),// ImageIcon(AssetImage('assets/images/leaders-100.png')),//  Icon(Icons.home),
              label: AppLocalizations.of(context)!.leaders
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.currency_exchange),// ImageIcon(AssetImage('assets/images/money-bag-100.png')),//  Icon(Icons.home),
              label: 'Fantasy'
          ),

        ],

        onTap: (index){
          setState(() {
            selectedPageIndex = index;
          });

        },
      ),

      drawer: FantasyTipsDrawer(logoutCallback: logoutUser)


    );
  }

  Future<String?> mongoIdPrefs() async{
    SharedPreferences sh_prefs =  await SharedPreferences.getInstance();
    return  sh_prefs.getString(Constants.mongoId);
  }

  registerUserCallback(User user) {


      updatePrefsMongoUserId(user);
      updateUser(user);


      if (!mounted){
        return;
      }

      Navigator.pop(context);

      String content = Constants.empty;
      if (user.errorMessage != Constants.empty){
        content = user.errorMessage;
      }else{
        content = AppLocalizations.of(context)!.email_verification + user.email;
      }

      showDialog(context: context, builder: (context) =>

          DialogUserRegistered(text: content)
      );

  }

  loginUserCallback(User user) async{

    updatePrefsMongoUserId(user);
    updateUser(user);

    if (!mounted){
      return;
    }

    if (user.errorMessage != Constants.empty) {
      showDialog(context: context, builder: (context) =>

          AlertDialog(
            title: Text(AppLocalizations.of(context)!.login_error),
            content: DialogUserRegistered(text: user.errorMessage),
            elevation: 20,
          ));
    }

    Navigator.pop(context);
  }

  Future<void> updatePrefsMongoUserId(User user) async {
    final SharedPreferences shprefs = await SharedPreferences.getInstance();
    if (user.mongoUserId != Constants.defMongoId) {
      shprefs.setString(Constants.mongoId, user.mongoUserId);
      if (user.fantasyLeagueMongoId != null) {
        shprefs.setString(sp_fantasy_league_id, user.fantasyLeagueMongoId??'');
      }
    }else{
      shprefs.remove(Constants.mongoId);
      shprefs.remove(sp_fantasy_league_id);
    }
  }

  updateUserCallBack(UserBet newBet) {

    double balance = AppContext.user.fantasyBalance.balance;
    double balanceNew = balance - newBet.betAmount;

    setState((){
      AppContext.user.fantasyBalance.balance = balanceNew;
    });

  }

  /*
   * Every X seconds we receive Map which contains all the league matches per day.
   * Key 0 is the today's matches , 1 is tomorrow etc.
   * Since we already have some matches from the previous calls, we have to 
   * 1. Add the new matches we received.
   * 2. Delete the matches that are missing from the previous call.
   * 3. Update the data of the matches that were pre-existing.
   */
  void updateLeagueMatches(List<MatchEvent> incomingEvents) {

    setState((){
      loadingAfterResume = false;
    });

    /**
     * The day might have changed
     */
    updateDateKeys();

    if (incomingEvents.isEmpty) {
      return; //TODO maybe empty everything?
    }

    DateFormat matchTimeFormat = DateFormat(MatchConstants.MATCH_START_TIME_FORMAT);

    for (MatchEvent incomingEvent in incomingEvents) {

      String localStartString = matchTimeFormat.format(incomingEvent.startAtLocalDateTime());
      String eventDateKey = localStartString.split(' ')[0];

      if (eventDateKey == '2025-08-16'){
        print(eventDateKey);
      }

      if (!AppContext.eventsPerDayMap.containsKey(eventDateKey)){
        // print('SKIPPING GAME ' + incomingEvent.eventId.toString());
        continue;
        // AppContext.eventsPerDayMap. putIfAbsent(eventDateKey, () => <LeagueWithData>[]);
      }

      List<LeagueWithData> matchDayLeagues = AppContext.eventsPerDayMap[eventDateKey] ?? [];
      LeagueWithData leagueOfMatch = matchDayLeagues.firstWhere((
          element) => element.league.league_id == incomingEvent.leagueId && element.dateKey == eventDateKey ,
          orElse: () => LeagueWithData.defLeague());

      if (leagueOfMatch.league.league_id == -1){
        League l = AppContext.allLeaguesMap[incomingEvent.leagueId]!;
        leagueOfMatch = LeagueWithData(league: l, events: [], dateKey: eventDateKey);
        matchDayLeagues.add(leagueOfMatch);
      }

      MatchEvent? existingEvent;

      var matches = leagueOfMatch.events
          .where((element) => element.eventId == incomingEvent.eventId);

      if (matches.isEmpty) {
        incomingEvent.calculateDisplayStatus(context);
        leagueOfMatch.events.add(incomingEvent);
      }else{

        if (matches.length > 1){
          print('MATCH EEEEEEEEERRRRRRRRRRRRRRRRRRRRRRR');
        }

        existingEvent = matches.first;
        existingEvent.copyFrom(incomingEvent);
        existingEvent.calculateDisplayStatus(context);
      }

    }

    sortLeagues();
    updatePageStates();
  }

    void updateLiveLeagueMatches(List<MatchEvent> incomingLiveEvents) {

      setState((){
        loadingAfterResume = false;
      });

      if (incomingLiveEvents.isEmpty) {
        AppContext.liveLeagues.clear();
      }else {

        DateFormat matchTimeFormat = DateFormat(MatchConstants.MATCH_START_TIME_FORMAT);

        for (MatchEvent incomingLiveEvent in incomingLiveEvents) {
         // incomingLiveLeagueIds.add(incomingLiveEvent.leagueId);
          bool eventExistsInCache = false;

          String localStartString = matchTimeFormat.format(incomingLiveEvent.startAtLocalDateTime());
          String eventDateKey = localStartString.split(' ')[0];

          for (LeagueWithData lwt in AppContext.eventsPerDayMap[eventDateKey]!) {//incoming exists then copy
            List<MatchEvent> liveEvents = lwt.events;//.where((element) => element.status == MatchEventStatus.INPROGRESS.statusStr).toList();
            if (lwt.dateKey == eventDateKey && liveEvents.contains(incomingLiveEvent)) {
              eventExistsInCache = true;
              MatchEvent existing = liveEvents.firstWhere((
                  element) => element.eventId == incomingLiveEvent.eventId);
              existing.copyFrom(incomingLiveEvent);
              existing.calculateDisplayStatus(context);

              if (!AppContext.liveLeagues.contains(lwt)) {
                AppContext.liveLeagues.add(lwt);
              }

            }

            if (eventExistsInCache){
              break;
            }
          }
        }

        for (LeagueWithData lwd in List.of(AppContext.liveLeagues)){
          bool hasLiveGames = lwd.events.any((element) => element.status == MatchEventStatus.INPROGRESS.statusStr);
          if (!hasLiveGames){
            print('removed LIVE LEAGUE ' + lwd.league.league_id.toString());
            AppContext.liveLeagues.remove(lwd);
          }
        }


      }

      AppContext.liveLeagues.sort();

      //AppContext.eventsPerDayMap[MatchConstants.KEY_TODAY].sort();
      updatePageStates();
  }

  void promptLoginOrRegister() {
    showDialog(context: context, builder: (context) =>

                    DialogTabbedLoginOrRegister(
                      registerCallback: registerUserCallback,
                      loginCallback: loginUserCallback,
                    )

    );
  }

  void updateLiveMatches(eventsPerDayMap) {}

/**
 *
 * FIREBASE
 */

void setupFirebaseListeners() async{


  //handler for app in foreground
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   if (!mounted){
  //     return;
  //   }
  //   if (message.notification != null) {//we sent only data messages for now
  //     //print('Message also contained a notification: ${message.notification}');
  //   }
  //
  //   //handleFirebaseTopicMessage(message);
  // });

  //now we can subscribe to topic

  // await _subscribeToTopicOnce();
   await FirebaseMessaging.instance.subscribeToTopic("LiveSoccer").onError((error, stackTrace) => print(error.toString() + stackTrace.toString()));

}

  Future<void> _subscribeToTopicOnce() async {
    final prefs = await SharedPreferences.getInstance();
    bool alreadySubscribed = prefs.getBool('subscribedToLiveSoccer') ?? false;

    if (!alreadySubscribed) {
      try {
        await FirebaseMessaging.instance.subscribeToTopic("LiveSoccer");
        await prefs.setBool('subscribedToLiveSoccer', true);
        //await Fluttertoast.showToast(msg: " Subscribed to LiveSoccer topic.");
      } catch (e, st) {
        print("❌ Error subscribing to topic: $e\n$st");
      }
    }else{
      //await Fluttertoast.showToast(msg: "Already  Subscribed to LiveSoccer topic.");
    }
  }

/*

    TODO: Attention!!!!!!!!
    for virtual devices you need to uninstall and install again in order to receive notifications

 */
  void handleFirebaseTopicMessage(RemoteMessage message) {

    final payload = message.data;
    if (payload[JsonConstants.changeEvent] == null){
      return;
    }

    ChangeEventSoccer changeEventSoccer = ChangeEventSoccer.fromJson(payload);

    // for (LeagueWithData l in AppContext.liveLeagues){
    for (LeagueWithData l in AppContext.eventsPerDayMap[DateUtilsFt.formattedDateWithOffset(0)]!){

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
      MatchEvent? parentEvent = AppContext.findEvent(changeEventSoccer.eventId);
      if (parentEvent == null){
        return;
      }
      parentEvent.changeEvent = changeEventSoccer.changeEvent;
      parentEvent.homeTeamScore?.current = changeEventSoccer.homeTeamScore;
      parentEvent.awayTeamScore?.current = changeEventSoccer.awayTeamScore;
    }

    if (!mounted){
      return;
    }


    oddsPageKey.currentState?.setState(() {
      AppContext.eventsPerDayMap;
    });

    livePageKey.currentState?.setState(() {
      AppContext.liveLeagues;
    });
  }

  static void sortLeagues() {
    for (var element in AppContext.eventsPerDayMap.entries) {
      element.value.sort();
      for (var lwt in element.value){
        lwt.events.sort();
      }
    }

  }

  void updatePageStates() {
    if (!mounted){
      return;
    }


    oddsPageKey.currentState?.setState(() {
      AppContext.eventsPerDayMap;
    });

    livePageKey.currentState?.setState(() {
      AppContext.liveLeagues;
    });

    // myFantasyLeaguesKey.currentState?.setState(() {
    //   AppContext.user;
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
      if (AppContext.allLeaguesMap.containsKey(l.league_id)){
        AppContext.allLeaguesMap[l.league_id]?.copyFrom(l);
      }else {
        AppContext.allLeaguesMap.putIfAbsent(l.league_id, () => l);
      }

    }

    updatePageStates();

    return true;
  }

  bool updateSections(List<Section> sections) {

    for ( Section s in sections){
      AppContext.allSectionsMap.putIfAbsent(s.id, ()=>s);
    }

    updatePageStates();

    return true;
  }

  void updateExistingMatchDataFromIncoming(List<LeagueWithData> existingTodayLeagues, List<LeagueWithData> incomingTodayLeagues) {

    for (LeagueWithData incomingLeague in List.of(incomingTodayLeagues)) {

      var existingLeague = existingTodayLeagues.firstWhere((
          element) => element == incomingLeague,
          orElse: () => LeagueWithData.defLeague());

      //missing league, add it to today leagues, also to live if it has live matches
      if (existingLeague.league.league_id == -1) {
        existingTodayLeagues.add(incomingLeague);
        continue;
      }

      for (MatchEvent existingEvent in List.of(existingLeague.events)) {

        // match was present, but now is not, remove it or copy the fields
        if (!incomingLeague.events.contains(existingEvent)) {
          existingLeague.events.remove(existingEvent);

          if(existingLeague.events.isEmpty){
            existingTodayLeagues.remove(existingLeague);
          }

          checkForOddsRemoval([existingEvent]);
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


        checkForOddsRemoval(existingLeague.events);
      }else{

      }
    }
  }

  Future<void> updateUserFromServer(String mongoUserId) async {
    User userNew = await HttpActionsClient.getUserAsync(mongoUserId);
    if (userNew.mongoUserId == Constants.defMongoId){
      return;
    }

    updatePrefsMongoUserId(userNew);
    updateUser(userNew);
  }

  void logoutUser() async{

    updatePrefsMongoUserId(User.defUser());

    updateUser(User.defUser());

    if(!mounted){
      return;
    }

    Navigator.pop(context);
  }


  /*
   * If shared prefs have a value , make a call to retrieve user
   */
  void retrieveUserFromPrefs() async{
    String? mongoIdFromPrefs = await mongoIdPrefs();
    if (mongoIdFromPrefs == null){
      return;
    }

    if(Constants.defMongoId == user.mongoUserId){
      user.mongoUserId = mongoIdFromPrefs;
    }

    User userNew = await HttpActionsClient.getUserAsync(mongoIdFromPrefs);
    if (Constants.defMongoId != userNew.mongoUserId){
      updateUser(userNew);
    }
  }

  void schedulePeriodicUpdates() {
    Timer.periodic(const Duration(seconds: 60*60*8), (timer) {
      if (!isMinimized) {
        HttpActionsClient.getSectionsAsync(null).then((secMap) => updateSections(secMap)
        );
      }
    }
    );

    Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!isMinimized) {
        HttpActionsClient.getLeaguesAsync(null)
            .then((leaguesMap) => updateLeagues(leaguesMap)
        );
      }
    }
    );

    Timer.periodic(const Duration(seconds: 15), (timer) {
      if (!isMinimized) {
        HttpActionsClient.getLeagueEventsAsync(timer).then((leaguesMap) =>
            updateLeagueMatches(leaguesMap)
        );
      }
    }
    );

    Timer.periodic(const Duration(seconds: 5), (timer) {

      if (!AppContext.eventsPerDayMap.containsKey(DateUtilsFt.formattedDateWithOffset(0))){
        return;
      }

      if (!isMinimized) {
        HttpActionsClient.getLeagueLiveEventsAsync(timer).then((leaguesMap) =>
            updateLiveLeagueMatches(leaguesMap)
        );
      }
    }
    );

    Timer.periodic(const Duration(seconds: 10), (timer) {
      if(isMinimized){
        return;
      }

      if (!isMinimized && User.defUser().mongoUserId != user.mongoUserId) {
        updateUserFromServer(user.mongoUserId);
        return;
      }

      retrieveUserFromPrefs();

    });
  }

  void updateDateKeys() {
    List<String> dateKeysNew = <String>[];
    dateKeysNew.add(DateUtilsFt.formattedDateWithOffset(-2));
    dateKeysNew.add(DateUtilsFt.formattedDateWithOffset(-1));
    dateKeysNew.add(DateUtilsFt.formattedDateWithOffset(0));
    dateKeysNew.add(DateUtilsFt.formattedDateWithOffset(1));
    dateKeysNew.add(DateUtilsFt.formattedDateWithOffset(2));
    //
    // print('Dates new are ' + dateKeysNew.first);
    // print('Dates new are ' + dateKeysNew[1]);
    // print('Dates new are ' + dateKeysNew[2]);

    List<String> dateKeysOld  = AppContext.eventsPerDayMap.keys.toList();
    for (String keyOld in dateKeysOld){
      if (!dateKeysNew.contains(keyOld)){
        AppContext.eventsPerDayMap.remove(keyOld);
      }
    }

    for (String keyNew in dateKeysNew){
      if (!dateKeysOld.contains(keyNew)){
        AppContext.eventsPerDayMap.putIfAbsent(keyNew, () => <LeagueWithData>[]);
      }
    }
  }


}
