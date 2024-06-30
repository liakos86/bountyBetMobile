// import 'dart:async';
// import 'dart:collection';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
//
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/enums/MatchEventStatusMore.dart';
// import 'package:flutter_app/models/UserBet.dart';
// import 'package:flutter_app/models/constants/UrlConstants.dart';
// import 'package:flutter_app/models/LeagueWithData.dart';
// import 'package:flutter_app/pages/LeaguesInfoPage.dart';
// import 'package:flutter_app/pages/LivePageNoTopic.dart';
// import 'package:flutter_app/pages/OddsPage.dart';
// import 'package:flutter_app/widgets/DialogTabbedLoginOrRegister.dart';
// import 'package:http/http.dart';
// import 'package:intl/intl.dart';
// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../enums/ChangeEvent.dart';
// import '../enums/MatchEventStatus.dart';
// import '../helper/JsonHelper.dart';
// import '../models/ChangeEventSoccer.dart';
// import '../models/User.dart';
// import '../models/match_event.dart';
// import '../utils/MockUtils.dart';
// import '../utils/client/MqttLiveEventsClient.dart';
// import '../widgets/DialogSuccessfulBet.dart';
// import '../widgets/DialogUserRegistered.dart';
// import 'LeaderBoardPage.dart';
// import 'LivePage.dart';
// import 'MyBetsPage.dart';
//
// class ParentPageNoStack extends StatefulWidget{
//
//   @override
//   ParentPageState createState() => ParentPageState();
// }
//
// class ParentPageState extends State<ParentPageNoStack> with WidgetsBindingObserver {
//
//   late final OddsPage oddsPage;
//   late final LivePageNoTopic livePage;
//   late final LeaderBoardPage leaderBoardPage;
//   late final MyBetsPage myBetsPage;
//   late final LeaguesInfoPage leaguesInfoPage;
//
//   Future<SharedPreferences> prefs = SharedPreferences.getInstance();
//
//   static User user = User.defUser();
//
//   static Map eventsPerDayMap = new HashMap<String, List<League>>();
//
//   List<League> liveLeagues = <League>[];
//
//   List<League> allLeagues = <League>[];
//
//   int _selectedPage = 0;
//
//   MqttServerClient? mqttClient ;
//
//   String? deviceId;
//
//   final List<Widget> pagesList = <Widget>[];
//
//   static MatchEvent findEvent(int eventId){
//     for (MapEntry dayEntry in eventsPerDayMap.entries){
//       for (League l in dayEntry.value){
//         for (MatchEvent e in l.events){
//           if (eventId == e.eventId){
//             return e;
//           }
//         }
//       }
//     }
//
//     return eventsPerDayMap.entries.first.value.events.first;
//
//   }
//
//   /*
//    * Fetch the leagues async
//    * Fetch the user async
//    * When the results are fetched the app will re-build and redraw.
//    */
//   @override
//   void initState() {
//
//     getLeaguesAsync().then((leaguesMap) =>
//         UpdateLeaguesAndLiveMatches(leaguesMap)
//     );
//
//
//     Timer.periodic(const Duration(seconds: 10), (timer) { getLeaguesAsync().then((leaguesMap) =>
//           UpdateLeaguesAndLiveMatches(leaguesMap)
//         );
//       }
//     );
//
//     Timer.periodic(const Duration(seconds: 30), (timer) {
//       getUserAsync().then((value) => setState(() {
//
//         if (value == null){
//           return;
//         }
//
//         user = value;
//         pagesList.removeAt(3);
//         pagesList.insert(3, MyBetsPage(key: GlobalKey(), user: user));
//       }));
//     });
//
//
//     subscribeToLiveTopic();
//
//     WidgetsBinding.instance.addObserver(this);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     switch (state) {
//       case AppLifecycleState.resumed:
//       //print("app in resumed");
//         subscribeToLiveTopic();
//         break;
//       case AppLifecycleState.inactive:
//       //print("app in inactive");
//         unsubscribeToLiveTopic();
//         break;
//       case AppLifecycleState.paused:
//       //print("app in paused");
//         unsubscribeToLiveTopic();
//         break;
//       case AppLifecycleState.detached:
//       //print("app in detached");
//         unsubscribeToLiveTopic();
//         break;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     if  (pagesList.isEmpty) {
//       oddsPage = OddsPage(key: GlobalKey(), updateUserCallback: updateUserCallBack, eventsPerDayMap: eventsPerDayMap);
//       pagesList.add(oddsPage);
//       livePage = LivePageNoTopic(key: UniqueKey(), liveLeagues: liveLeagues);
//       pagesList.add(livePage);
//       leaderBoardPage = new LeaderBoardPage();
//       pagesList.add(leaderBoardPage);
//       myBetsPage = MyBetsPage(key: GlobalKey(), user: user);
//       pagesList.add(myBetsPage);
//       leaguesInfoPage = LeaguesInfoPage(key: GlobalKey(), allLeagues: allLeagues);
//       pagesList.add(leaguesInfoPage);
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//           title: user.mongoUserId == null ? Text('FOOTBALL') : Text(user.username + '('+user.balance.toStringAsFixed(2)+')'),
//         leading: user.mongoUserId != null ? Text('Logout') :
//           GestureDetector(
//           onTap: () {
//
//             showDialog(context: context, builder: (context) =>
//
//             AlertDialog(
//                 title: Text('Login'),
//               content: DialogTabbedLoginOrRegister(registerCallback: registedUserCallback, loginCallback: loginUserCallback,),
//               elevation: 20,
//
//
//             ));
//           },
//           child: Icon(
//             Icons.account_circle_outlined,  // add custom icons also
//           ),
//         ),
//       ),
//       body:
//
//        pagesList[_selectedPage],
//
//       bottomNavigationBar: BottomNavigationBar(
//         selectedFontSize: 20,
//         unselectedFontSize: 12,
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Colors.blueAccent,
//         fixedColor: Colors.white,
//         currentIndex: _selectedPage,
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Odds'
//           ),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.live_help),
//               label: 'Live'
//           ),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.favorite),
//               label: 'Leaders'
//           ),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.my_library_music),
//               label: 'My bets'
//           ),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.leaderboard),
//               label: 'Leagues'
//           ),
//         ],
//
//         onTap: (index){
//           setState(() {
//             _selectedPage = index;
//           });
//
//         },
//       ),
//
//     );
//   }
//
//   Future<void> unsubscribeToLiveTopic() async {
//     // if (mqttClient != null && mqttClient?.connectionStatus == MqttConnectionState.connected|| mqttClient?.connectionStatus == MqttConnectionState.connecting){
//     mqttClient?.disconnect();
//     // }
//   }
//
//   Future<void> subscribeToLiveTopic() async {
//
//     if (mqttClient != null && (mqttClient?.connectionStatus == MqttConnectionState.connected || mqttClient?.connectionStatus == MqttConnectionState.connecting)){
//       return;
//     }
//
//     if (deviceId == null || deviceId!.isEmpty){
//       deviceId = await getDeviceId();
//     }
//
//     MqttLiveEventsClient mqtt = new MqttLiveEventsClient();
//     MqttClient client = await mqtt.connect(deviceId);
//     mqtt.subscribeToLiveScores(client);
//     client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
//       final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
//       final payload = MqttPublishPayload.bytesToStringAsString(
//           message.payload.message);
//       final jsonValues = json.decode(payload);
//       ChangeEventSoccer changeEventSoccer = ChangeEventSoccer.fromJson(jsonValues);
//
//       if (this.mounted ) {
//         for (League l in liveLeagues){
//           List<MatchEvent> liveEvents = l.events;
//           MatchEvent? relevantEvent =  liveEvents.firstWhere((element) => element.eventId == changeEventSoccer.eventId);
//           if (relevantEvent == null){
//             continue;
//           }
//
//           if (ChangeEvent.MATCH_START == changeEventSoccer.changeEvent){
//             l.liveEvents.add(relevantEvent);
//             relevantEvent.status = MatchEventStatus.INPROGRESS.statusStr;
//           }
//
//           relevantEvent.changeEvent = changeEventSoccer.changeEvent;
//           relevantEvent.homeTeamScore = changeEventSoccer.homeTeamScore;
//           relevantEvent.awayTeamScore = changeEventSoccer.awayTeamScore;
//         }
//       }
//
//       // print('Received message:$payload from topic: ${c[0].topic}>');
//       setState(() {
//         this.liveLeagues = liveLeagues;
//       });
//
//     });
//
//   }
//
//   Future<User?> getUserAsync() async{
//     SharedPreferences sh_prefs =  await prefs;
//     String? mongoId = sh_prefs.getString('mongoId');
//     if (mongoId == null){
//       return null;
//     }
//
//     String getUserUrlFinal = UrlConstants.GET_USER_URL.replaceAll('USER_ID', mongoId);
//     try {
//       Response userResponse = await get(Uri.parse(getUserUrlFinal)).timeout(const Duration(seconds: 5));
//       var responseDec = await jsonDecode(userResponse.body);
//       return User.fromJson(responseDec);
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }
//
//   Future<Map<String, List<League>>> getLeaguesAsync() async {
//
//       Map jsonLeaguesData = new LinkedHashMap();
//
//       try {
//         Response leaguesResponse = await get(Uri.parse(UrlConstants.GET_LEAGUES)).timeout(const Duration(seconds: 5));
//         jsonLeaguesData = await jsonDecode(leaguesResponse.body) as Map;
//       } catch (e) {
//         print('ERROR REST ---- MOCKING............');
//         Map<String, List<League>> validData = MockUtils().mockLeaguesMap(false);
//         User mockUser = MockUtils().mockUser(validData);
//         setState(() {
//           user = mockUser;
//         });
//         return validData;
//       }
//
//       return await convertJsonLeaguesToObjects(jsonLeaguesData);
//   }
//
//   getLiveEventsCallBack() {
//     // if (liveLeagues.isNotEmpty) {
//     //   League league = League(events: <MatchEvent>[],  has_logo: true, name: "Mock country", league_id: 2);
//     //
//     //   MatchEvent mock = MockUtils().mockEvent(
//     //       Random().nextInt(200000),
//     //       1.5,
//     //       1.5,
//     //       1.5,
//     //       1.5,
//     //       1.5,
//     //       MatchEventStatus.INPROGRESS.statusStr,
//     //       MatchEventStatusMore.INPROGRESS_1ST_HALF.statusStr,
//     //       ChangeEvent.HOME_GOAL);
//     //   league.liveEvents.add(mock);
//     //   liveLeagues.add(league);
//     //
//     //   print('NEW EVENT ' + mock.eventId.toString());
//     //   liveLeagues.first.liveEvents.add(mock);
//     // }
//
//     return liveLeagues;
//   }
//
//   registedUserCallback(User user) {
//
//       Navigator.pop(context);
//
//       String content = '';
//       if (user.errorMessage != ''){
//         content = user.errorMessage;
//       }else{
//         content = 'A verification email has been sent to ' + user.email;
//       }
//
//       showDialog(context: context, builder: (context) =>
//
//           AlertDialog(
//             title: Text('Registration'),
//             content: DialogUserRegistered(text: content),
//             elevation: 20,
//           ));
//   }
//
//   loginUserCallback(User user) async{
//
//     Navigator.pop(context);
//
//     if (user.errorMessage == ''){
//       await updateUserMongoId(user.mongoUserId);
//       return;
//     }
//
//     showDialog(context: context, builder: (context) =>
//
//         AlertDialog(
//           title: Text('Login Error'),
//           content: DialogUserRegistered(text: user.errorMessage),
//           elevation: 20,
//         ));
//
//   }
//
//   Future<void> updateUserMongoId(String? mongoId) async {
//     final SharedPreferences shprefs = await prefs;
//     shprefs.setString('mongoId', mongoId!).then((value) => getUserAsync());
//   }
//
//
//   updateUserCallBack(User userUpdated, UserBet newBet) {
//     setState(() {
//       user = userUpdated;
//     });
//
//     showDialog(context: context, builder: (context) =>
//
//         AlertDialog(
//           title: Text('Successful bet'),
//           content: DialogSuccessfulBet(newBet: newBet),
//           elevation: 20,
//         ));
//   }
//
//   Future<Map<String, List<League>>> convertJsonLeaguesToObjects(Map jsonLeaguesData) async{
//     Map<String, List<League>> newEventsPerDayMap = new LinkedHashMap();
//     for (MapEntry dailyLeagues in  jsonLeaguesData.entries) {
//       String day = dailyLeagues.key;
//       var leaguesJson = dailyLeagues.value;
//       List<League> leagues = <League>[];
//       for (var league in leaguesJson) {
//         League leagueObj = JsonHelper.leagueFromJson(league);
//         leagues.add(leagueObj);
//       }
//
//       newEventsPerDayMap.putIfAbsent(day, ()=> leagues);
//     }
//
//     return newEventsPerDayMap;
//   }
//
//   UpdateLeaguesAndLiveMatches(Map<String, List<League>> leaguesMap) {
//
//     //timer.cancel();
//     final DateTime now = DateTime.now();
//     final DateFormat formatter = DateFormat('yyyy-MM-dd');
//     final String today = formatter.format(now);
//
//     List<League> liveLeaguesUpd = <League>[];
//     if (leaguesMap.isNotEmpty) {
//       List<League>? todayLeagues = leaguesMap[today];
//       liveLeaguesUpd = List.of(todayLeagues!);
//       for (League l in List.of(liveLeaguesUpd)) {
//         if (l.liveEvents.isEmpty) {
//           liveLeaguesUpd.remove(l);
//         }
//
//       }
//     }
//
//     setState(() {
//       eventsPerDayMap.clear();
//       liveLeagues.clear();
//       allLeagues.clear();
//       leaguesMap.entries.forEach((element) {
//         eventsPerDayMap.putIfAbsent(element.key, ()=> element.value);
//         List<League> leagues = element.value;
//         for (League l in leagues){
//           if (!allLeagues.contains(l)){
//             allLeagues.add(l);
//           }
//         }
//       });
//
//       liveLeagues.addAll(liveLeaguesUpd);
//     });
//
//     setState(() {
//       oddsPage = OddsPage(key: GlobalKey(), updateUserCallback: updateUserCallBack, eventsPerDayMap: eventsPerDayMap);
//       livePage = LivePageNoTopic(key: UniqueKey(), liveLeagues: liveLeagues);
//       leaderBoardPage = new LeaderBoardPage();
//       pagesList.add(leaderBoardPage);
//       myBetsPage = MyBetsPage(key: GlobalKey(), user: user);
//       pagesList.add(myBetsPage);
//       leaguesInfoPage = LeaguesInfoPage(key: GlobalKey(), allLeagues: allLeagues);
//       pagesList.add(leaguesInfoPage);
//     });
//
//   }
//
//   Future<String?> getDeviceId() async {
//     String deviceIdentifier = '';
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     if (kIsWeb) {
//       final WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
//       deviceIdentifier = webInfo.vendor! +
//           webInfo.userAgent! +
//           webInfo.hardwareConcurrency.toString();
//     } else {
//       if (Platform.isAndroid) {
//         try {
//           final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//           deviceIdentifier = androidInfo.id;
//         }catch(e){
//           print(e.toString());
//         }
//       } else if (Platform.isIOS) {
//         final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
//         deviceIdentifier = iosInfo.identifierForVendor!;
//       } else if (Platform.isLinux) {
//         final LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
//         deviceIdentifier = linuxInfo.machineId!;
//       }
//     }
//
//     return deviceIdentifier.replaceAll('.', '');
//   }
//
//   void updateLiveMinute(Timer timer) {
//
//     if (!this.mounted){
//       return;
//     }
//
//     for (League league in liveLeagues){
//       for (MatchEvent event in league.liveEvents){
//         event.calculateLiveMinute();
//       }
//     }
//
//     setState(() {
//       this.liveLeagues = liveLeagues;
//     });
//
//   }
//
// }
