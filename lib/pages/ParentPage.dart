import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserBet.dart';
import 'package:flutter_app/models/constants/Constants.dart';
import 'package:flutter_app/models/constants/UrlConstants.dart';
import 'package:flutter_app/models/league.dart';
import 'package:flutter_app/pages/LeaguesInfoPage.dart';
import 'package:flutter_app/pages/OddsPage.dart';
import 'package:flutter_app/widgets/DialogTabbedLoginOrRegister.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/ChangeEvent.dart';
import '../enums/MatchEventStatus.dart';
import '../helper/JsonHelper.dart';
import '../models/ChangeEventSoccer.dart';
import '../models/User.dart';
import '../models/match_event.dart';
import '../utils/MockUtils.dart';
import '../utils/client/MqttLiveEventsClient.dart';
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
class ParentPageState extends State<ParentPage> with WidgetsBindingObserver {

  /*
   * Client for live score topics' subscription.
   * We place it here to pass down changes to more than one page
   */
  MqttServerClient? mqttClient ;

  /*
   * Unique device id required to subscribe to topic.
   */
  String? deviceId;

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


  // final List<UserBet> userBets = <UserBet>[];

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

      pagesList.add(OddsPage(key: oddsPageKey, updateUserCallback: updateUserCallBack, eventsPerDayMap: eventsPerDayMap));
      pagesList.add(LivePage(key: livePageKey, liveLeagues: liveLeagues));
      pagesList.add(LeaderBoardPage());
      pagesList.add(MyBetsPage(key: betsPageKey, user: user, loginOrRegisterCallback: promptLoginOrRegister));
      pagesList.add(LeaguesInfoPage(key: leaguesPageKey, allLeagues: allLeagues));

      getLeaguesAsync().then((leaguesMap) => UpdateLeaguesAndLiveMatches(leaguesMap));

      Timer.periodic(const Duration(seconds: 5), (timer) { getLeaguesAsync().then((leaguesMap) =>
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

      subscribeToLiveTopic();

      super.initState();
      WidgetsBinding.instance.addObserver(this);
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
                  FloatingActionButton(onPressed: promptLoginOrRegister,
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.black,
                      mini: true, child: Icon(Icons.login, color: Colors.white))
                      :
                  FloatingActionButton(onPressed: promptLogout,
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.black,
                      mini: true, child: Icon(Icons.logout, color: Colors.white))

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

  @override
  void dispose(){
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
      //print("app in resumed");
        subscribeToLiveTopic();
        break;
      case AppLifecycleState.inactive:
      //print("app in inactive");
        unsubscribeToLiveTopic();
        break;
      case AppLifecycleState.paused:
      //print("app in paused");
        unsubscribeToLiveTopic();
        break;
      case AppLifecycleState.detached:
      //print("app in detached");
        unsubscribeToLiveTopic();
        break;
    }
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

  Future<Map<String, List<League>>> getLeaguesAsync() async {

      Map jsonLeaguesData = LinkedHashMap();

      try {
        Response leaguesResponse = await get(Uri.parse(UrlConstants.GET_LEAGUES)).timeout(const Duration(seconds: 15));
        jsonLeaguesData = await jsonDecode(leaguesResponse.body) as Map;
      } catch (e) {



        print('ERROR REST ---- MOCKING............');
        Map<String, List<League>> validData = MockUtils().mockLeaguesMap(false);
        User mockUser = MockUtils().mockUser(validData);
        setState(() {
          user.username = mockUser.username;
          // user.userBets.addAll(mockUser.userBets);
          user.userBets.clear();
          user.userBets.addAll(mockUser.userBets);
        });
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
      return;
    }

    List<League> liveLeaguesUpd = <League>[];

    // List<League> incomingTodayLeagues = List.of(incomingLeaguesMap["0"] as Iterable<League>);
    //
    // for(League incomingLeague in incomingTodayLeagues){
    //   if (incomingLeague.liveEvents.isEmpty){
    //     continue;
    //   }
    //
    //   if (!liveLeagues.contains(incomingLeague)){
    //     liveLeagues.add(incomingLeague);
    //     continue;
    //   }
    //
    //   for(League existingLeague in liveLeagues){
    //     if (existingLeague.league_id == incomingLeague.league_id){
    //
    //       List<MatchEvent> existingEvents = existingLeague.liveEvents;
    //       List<MatchEvent> incomingEvents = incomingLeague.liveEvents;
    //
    //       for (MatchEvent existingEvent in List.of(existingEvents)){
    //         if (!incomingEvents.contains(existingEvent)){
    //           existingEvents.remove(existingEvent);
    //         }else{
    //           //copy fields
    //           MatchEvent incomingEvent = incomingEvents.firstWhere((element) => element.eventId == existingEvent.eventId);
    //           existingEvent.copyFrom(incomingEvent);
    //         }
    //       }
    //
    //       for (MatchEvent incomingEvent in incomingEvents){
    //         if (!existingEvents.contains(incomingEvent)){
    //           existingEvents.add(incomingEvent);
    //         }
    //       }
    //
    //     }
    //   }
    // }

    List<League>? todayLeagues = incomingLeaguesMap["0"];
    liveLeaguesUpd = List.of(todayLeagues!);
    for (League l in List.of(liveLeaguesUpd)) {
      if (l.liveEvents.isEmpty) {
        liveLeaguesUpd.remove(l);
      }
    }

    for (League league in liveLeagues){
      for (MatchEvent event in league.liveEvents){
        event.calculateLiveMinute();
      }
    }

    liveLeagues.clear();
    liveLeagues.addAll(liveLeaguesUpd);





    eventsPerDayMap.clear();
    List<League> allLeaguesNew = <League>[];
    incomingLeaguesMap.entries.forEach((element) {
      eventsPerDayMap.putIfAbsent(element.key, ()=> element.value);
      List<League> leagues = element.value;
      for (League l in leagues){
        if (!allLeaguesNew.contains(l)){
          allLeaguesNew.add(l);
        }
      }
    });

    allLeagues.clear();
    allLeagues.addAll(allLeaguesNew);

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

  Future<void> unsubscribeToLiveTopic() async {
    // if (mqttClient != null && mqttClient?.connectionStatus == MqttConnectionState.connected|| mqttClient?.connectionStatus == MqttConnectionState.connecting){
    mqttClient?.disconnect();
    // }
  }

  Future<void> subscribeToLiveTopic() async {

    if (mqttClient != null && (mqttClient?.connectionStatus == MqttConnectionState.connected || mqttClient?.connectionStatus == MqttConnectionState.connecting)){
      return;
    }

    if (deviceId == null || deviceId!.isEmpty){
      deviceId = await getDeviceId();
    }

    MqttLiveEventsClient mqtt = new MqttLiveEventsClient();
    MqttClient client = await mqtt.connect(deviceId);
    mqtt.subscribeToLiveScores(client);
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {

      handleLiveScoreTopicMessage(c);

    });

  }

  Future<String?> getDeviceId() async {
    String deviceIdentifier = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (kIsWeb) {
      final WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
      deviceIdentifier = webInfo.vendor! +
          webInfo.userAgent! +
          webInfo.hardwareConcurrency.toString();
    } else {
      if (Platform.isAndroid) {
        try {
          final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          deviceIdentifier = androidInfo.id;
        }catch(e){
          print(e.toString());
        }
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceIdentifier = iosInfo.identifierForVendor!;
      } else if (Platform.isLinux) {
        final LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
        deviceIdentifier = linuxInfo.machineId!;
      }
    }

    return deviceIdentifier.replaceAll('.', '');
  }

  void handleLiveScoreTopicMessage(List<MqttReceivedMessage<MqttMessage>> c) {

    final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
    final payload = MqttPublishPayload.bytesToStringAsString(
        message.payload.message);
    final jsonValues = json.decode(payload);
    ChangeEventSoccer changeEventSoccer = ChangeEventSoccer.fromJson(jsonValues);
    print('Received message:$payload from topic: ${c[0].topic}>');

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

  void promptLoginOrRegister() {
    showDialog(context: context, builder: (context) =>

        AlertDialog(
          title: Text('Login'),
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

}
