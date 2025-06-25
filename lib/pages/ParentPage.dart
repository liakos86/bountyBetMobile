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

import 'package:shared_preferences/shared_preferences.dart';

import '../enums/ChangeEvent.dart';
import '../enums/MatchEventStatus.dart';
import '../models/ChangeEventSoccer.dart';
import '../models/League.dart';
import '../models/Section.dart';
import '../models/User.dart';
import '../models/UserPrediction.dart';
import '../models/constants/ColorConstants.dart';
import '../models/constants/MatchConstants.dart';
import '../models/match_event.dart';
import '../widgets/DialogUserRegistered.dart';
import '../widgets/custom/FantasyTipsDrawer.dart';
import '../widgets/dialog/DialogTextWithButtons.dart';
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

  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  List<ProductDetails> products = [];
  List<PurchaseDetails> purchases = [];
  bool available = false;
  StreamSubscription<List<PurchaseDetails>>? subscription;
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

    _initializeInAppPurchases();

    subscription = inAppPurchase.purchaseStream.listen((purchaseDetailsList) {
      handlePurchaseUpdates(purchaseDetailsList);
    },onDone: () => subscription?.cancel(), onError: (error) {
      if (mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.purchase_error), showCloseIcon: true, duration: const Duration(seconds: 5),
        ));
      }
      // Handle errors during the purchase flow.
    });

    HttpActionsClient.listenConnChanges(updateConnState);


   AppContext.eventsPerDayMap. putIfAbsent(MatchConstants.KEY_YESTERDAY, () => <LeagueWithData>[]);
   AppContext.eventsPerDayMap.putIfAbsent(MatchConstants.KEY_TODAY, () => <LeagueWithData>[]);
   AppContext.eventsPerDayMap.putIfAbsent(MatchConstants.KEY_TOMORROW, () => <LeagueWithData>[]);


  WidgetsBinding.instance.addObserver(this);

  super.initState();

  WidgetsBinding.instance
      .addPostFrameCallback((_) => setLocale(context));

  pagesList.add(OddsPage(key: oddsPageKey, updateUserCallback: updateUserCallBack, loginUserCallback: loginUserCallback, registerUserCallback: registerUserCallback, selectedOdds: selectedOdds, topUpCallback: promptDialogTopup));
  pagesList.add(LivePage(key: livePageKey, allLeagues: AppContext.eventsPerDayMap[MatchConstants.KEY_TODAY]));
  pagesList.add(LeaderBoardPage());
  pagesList.add(MyBetsPage(key: betsPageKey, loginOrRegisterCallback: promptLoginOrRegister));
  // pagesList.add(MyFantasyLeaguesPage(key: myFantasyLeaguesKey, loginOrRegisterCallback: promptLoginOrRegister));


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
    subscription?.cancel();
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
        isMinimized = false;
      });
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
        AppContext.eventsPerDayMap;
        AppContext.allLeaguesMap;
      });
  }


  Future<void> updateUser(User value) async {

    user.deepCopyFrom(value);


    if (user.mongoUserId != Constants.defMongoId) {
      restorePurchases();
    }

    if (user.mongoUserId == Constants.defMongoId ){
     // updateUserMongoId(value);
      appBarTitle = AppLocalizations.of(context)!.football;
    } else if (!user.validated){
      appBarTitle = '[${AppLocalizations.of(context)!.validation_pending}]';
    }else {// if (AppContext.user.balance.position > 0){
      appBarTitle = '${AppLocalizations.of(context)!.position}[${AppContext.user.balance.position}${AppLocalizations.of(context)!.out_of}${AppContext.user.balance.totalUsers}]'  ;
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
                    AppContext.user.balance.positionDelta >= 0 ?
                    const Icon(
                      Icons.arrow_circle_up, // Replace with desired icon
                      size: 20,
                      color: Color(ColorConstants.my_green),
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
                    text: AppContext.user.balance.positionDelta >= 0 ? ' +${AppContext.user.balance.positionDelta}' : ' ${AppContext.user.balance.positionDelta}',
                    style: TextStyle(color: AppContext.user.balance.positionDelta >= 0 ? const Color(ColorConstants.my_green) : Colors.redAccent)
                  ),

                const WidgetSpan(child: SizedBox(width: 8)),

                if (AppContext.user.balance.balance > 0)
                const WidgetSpan(
                  alignment: PlaceholderAlignment.middle, // Align icon with text
                  child: Icon(
                    Icons.currency_exchange, // Replace with desired icon
                    size: 20,
                    color: Colors.amber,
                  ),
                ),


                TextSpan(
                  text: AppContext.user.balance.balance > 0 ? AppContext.user.balance.balance.toStringAsFixed(2) : Constants.empty,
                ),
               ]))),

              if (available && products.isNotEmpty && AppContext.user.mongoUserId != Constants.defMongoId && AppContext.user.validated && AppContext.user.balance.balance < 100000 )
                  ElevatedButton(
                    key: UniqueKey(),
                    onPressed: () {
                      alertDialogTopUp();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.red,  // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded radius
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                      minimumSize: const Size(0, 30), // Button size
                    ),
                    child:  Text(
                      AppLocalizations.of(context)!.topup_button_text,
                      style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic
                      ),
                    ),
                  )
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
    backgroundColor: const Color(ColorConstants.my_green),
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
              label: AppLocalizations.of(context)!.bets
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
    }else{
      shprefs.remove(Constants.mongoId);
    }
  }

  updateUserCallBack(UserBet newBet) {

    double balance = AppContext.user.balance.balance;
    double balanceNew = balance - newBet.betAmount;

    setState((){
      AppContext.user.balance.balance = balanceNew;
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
  void updateLeagueMatches(Map<String, List<LeagueWithData>> incomingLeaguesMap) {
    if (incomingLeaguesMap.isEmpty) {
      return; //TODO maybe empty everything?
    }


    for (var dailyEntry in incomingLeaguesMap.entries) {
      List<LeagueWithData> existingTodayLeagues = AppContext
          .eventsPerDayMap[dailyEntry.key];
      List<
          LeagueWithData> incomingTodayLeagues = incomingLeaguesMap[dailyEntry.key]!;


      updateExistingMatchDataFromIncoming(
          existingTodayLeagues, incomingTodayLeagues);

      updateExistingMatchDataFromIncomingMissing(
          existingTodayLeagues, incomingTodayLeagues);

      for (var element in existingTodayLeagues) {
        for (var element in element.events) {
          element.calculateDisplayStatus(context);
        }
      }
    }

    sortLeagues();
    updatePageStates();
  }

    void updateLiveLeagueMatches(Map<int, MatchEvent> incomingLiveEventsMap) {

      if (incomingLiveEventsMap.isEmpty) {
        //AppContext.liveLeagues.clear();
      }else {

        //Set<int> newAddedLeagueIds = Set();
        Set<int> incomingLiveLeagueIds = Set();

        for (MapEntry incomingLiveEventEntry in incomingLiveEventsMap.entries) {
          MatchEvent incomingLiveEvent = incomingLiveEventEntry.value;
          incomingLiveLeagueIds.add(incomingLiveEvent.leagueId);
          bool eventExistsInCache = false;

          for (LeagueWithData lwt in AppContext.eventsPerDayMap[MatchConstants.KEY_TODAY]) {//incoming exists then copy
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


        }


        for (var element in AppContext.eventsPerDayMap[MatchConstants.KEY_TODAY]) {
          for (var element in element.events) {
            element.calculateDisplayStatus(context);
          }

        }
      }


      AppContext.eventsPerDayMap[MatchConstants.KEY_TODAY].sort();
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
      AppContext.eventsPerDayMap[MatchConstants.KEY_TODAY];
    });
  }

  static void sortLeagues() {
    for (var element in AppContext.eventsPerDayMap.entries) {
      element.value.sort();
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
      AppContext.eventsPerDayMap[MatchConstants.KEY_TODAY];
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

  void alertDialogTopUp() {
    showDialog(context: context, builder: (context) =>
        DialogTextWithButtons(topUpCallback: promptDialogTopup)
    );
  }


  void promptDialogTopup(String productId) {
    if (products.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No products available'), showCloseIcon: true, duration: Duration(seconds: 5),
      ));

      return;
    }

    ProductDetails? selected;
    for(ProductDetails product in products) {
      if (productId == product.id) {
        selected = product;
      }
    }

    if (selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Product not found $productId'), showCloseIcon: true, duration: const Duration(seconds: 5),
      ));

      return;
    }

    buyProduct(selected);
  }

  Future<void> _initializeInAppPurchases() async {
    final bool isAvailable = await inAppPurchase.isAvailable();


    setState(() {
      available = isAvailable;
    });

    if (isAvailable) {

      final ProductDetailsResponse response = await inAppPurchase.queryProductDetails(PurchaseConstants.productIds);
      if (response.error == null) {
        setState(() {
          products = response.productDetails;
        });
      }
    }
  }

  Future<void> handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async{
    setState(() {
      purchases.addAll(purchaseDetailsList);
    });

    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {

      if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored) {
        //bool isValid = true; // TODO: server await verifyPurchaseOnServer(purchaseDetails);
        if (purchaseDetails.pendingCompletePurchase) {
          deliverProduct(purchaseDetails);
        }else{
          final InAppPurchaseAndroidPlatformAddition  androidAddition =
          inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();

          await androidAddition.consumePurchase(purchaseDetails);

        }
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text( '${AppLocalizations.of(context)!.purchase_error} ${purchaseDetails.error}'), showCloseIcon: true, duration: const Duration(seconds: 5),
        ));
      }
    }
  }

  /*
   * A purchase is sent here in order to be validated on server and then completed.
   * If server validation fails, we keep the purchase in the shared prefs in order to be retried in 30 seconds.
   */
  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async{

    try {
      bool success = await sendPurchaseToServer(purchaseDetails);
      if (success) {

        inAppPurchase.completePurchase(purchaseDetails);

        final InAppPurchaseAndroidPlatformAddition  androidAddition =
        inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();

        await androidAddition.consumePurchase(purchaseDetails);

      } else {

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar( SnackBar(
            content: Text(AppLocalizations.of(context)!.purchase_handling),
            showCloseIcon: true,
            duration:  const Duration(seconds: 5),
          ));
        }

      }
    } catch (e) {
    }

  }

  Future<void> restorePurchases() async {

    await inAppPurchase.restorePurchases();
  }

  void buyProduct(ProductDetails productDetails) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
    inAppPurchase.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
  }

  Future<bool> sendPurchaseToServer(PurchaseDetails purchase) async {
    // For Google Play
    if (purchase.verificationData.source == 'google_play') {
      bool verified = await _verifyWithGoogle(purchase);
      return verified;
    }
    // For Apple App Store
    else if (purchase.verificationData.source == 'app_store') {
      return await _verifyWithApple(purchase);
    }
    return false;
  }

// Mock Google Play verification (Replace with your backend logic)
  Future<bool> _verifyWithGoogle(PurchaseDetails purchase) async {
    // final String purchaseToken = purchase.verificationData.serverVerificationData;

    // Send token to your backend for validation
    return await verifyPurchaseWithServer(purchase);
  }

// Mock Apple verification (Replace with your backend logic)
  Future<bool> _verifyWithApple(PurchaseDetails purchase) async {
    // final String receiptData = purchase.verificationData.serverVerificationData;
    return await verifyPurchaseWithServer(purchase);
  }

  Future<bool> verifyPurchaseWithServer(PurchaseDetails purchaseDetails) async {
    return await HttpActionsClient.verifyPurchase(purchaseDetails); // Simulating network delay
  }

  /*
   * If shared prefs have a value , make a call to retrieve user
   */
  void retrieveUserFromPrefs() async{
    String? mongoIdFromPrefs = await mongoIdPrefs();
    if (mongoIdFromPrefs == null){
      return;
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

    Timer.periodic(const Duration(seconds: 60*60*4), (timer) {
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

      if (AppContext.eventsPerDayMap[MatchConstants.KEY_TODAY].isEmpty){
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
      if (!isMinimized && User.defUser().mongoUserId != user.mongoUserId) {
        updateUserFromServer(user.mongoUserId);
      }
    });
  }


}
