import 'dart:collection';
import 'dart:convert';

import 'package:flutter_app/models/UserBet.dart';
import 'package:flutter_app/models/constants/UrlConstants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'dart:async';

import '../../enums/BetPlacementStatus.dart';
import '../../examples/util/encryption.dart';
import '../../helper/JsonHelper.dart';
import '../../models/League.dart';
import '../../models/LeagueWithData.dart';
import '../../models/Section.dart';
import '../../models/User.dart';
import '../../models/constants/Constants.dart';
import '../../models/context/AppContext.dart';
import '../../models/match_event.dart';
import '../MockUtils.dart';
import '../SecureUtils.dart';



class HttpActionsClient {

  static String? access_token;

  static Future<User?> loginUser(String emailOrUsername, String password) async{
    try {

      if (access_token == null) {
        access_token = await SecureUtils().retrieveValue(
            Constants.accessToken);
        await authorizeAsync();
        if (access_token == null) {
          print('login COULD NOT AUTHORIZE ********************************************************************');
          return null;
        }
      }

      Response loginResponse = await post(Uri.parse(UrlConstants.POST_LOGIN_USER),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer $access_token'
          },
          body: jsonEncode(toJsonLogin(emailOrUsername, password)),
          encoding: Encoding.getByName("utf-8")).timeout(
          const Duration(seconds: 5));

      var responseDec = jsonDecode(loginResponse.body);
      User userFromServer = User.fromJson(responseDec);

      return userFromServer;

    }catch(e){

      print(e);
      return null;

    }
  }

  static Future<BetPlacementStatus> placeBet(UserBet newBet) async {



    try {
    var encodedBet = jsonEncode(newBet.toJson());

      if (access_token == null) {
        access_token = await SecureUtils().retrieveValue(
            Constants.accessToken);
        await authorizeAsync();
        if (access_token == null) {
          print('COULD NOT AUTHORIZE ********************************************************************');
          return BetPlacementStatus.FAIL_GENERIC;
        }
      }
      var userResponse = await post(Uri.parse(UrlConstants.POST_PLACE_BET),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer $access_token'
          },
          body: encodedBet,
          encoding: Encoding.getByName("utf-8")).timeout(
          const Duration(seconds: 20));


      BetPlacementStatus betPlacementStatus = BetPlacementStatus.ofStatusText(userResponse.body);


      return betPlacementStatus;

    }catch(e){
      print(e);
      return BetPlacementStatus.FAIL_GENERIC;
    }
  }

  static Future<List<League>> getStandingsWithoutTablesAsync() async{

    try {

    if (access_token == null) {
      access_token = await SecureUtils().retrieveValue(
          Constants.accessToken);
      await authorizeAsync();
      if (access_token == null) {
        print('LEGUUES COULD NOT AUTHORIZE ********************************************************************');
        return <League>[];
      }
    }

    String getStandingsWithoutTablesUrlFinal = UrlConstants.GET_STANDINGS_WITHOUT_TABLES;
      Response userResponse = await get(Uri.parse(getStandingsWithoutTablesUrlFinal), headers:  {'Authorization': 'Bearer $access_token'}).timeout(const Duration(seconds: 5));
      Iterable responseDec = await jsonDecode(userResponse.body);
      return  List<League>.from(responseDec.map((model) => League.fromJson(model)));
    } catch (e) {
      print(e);
      return <League>[];
    }
  }


  static Future<Map<String, List<User>>> getLeadingUsers() async{

    Map<String, List<User>> leadersMap = LinkedHashMap();

    try {

      if (access_token == null) {
        access_token = await SecureUtils().retrieveValue(
            Constants.accessToken);
        await authorizeAsync();
        if (access_token == null) {
          print('LEDERS COULD NOT AUTHORIZE ********************************************************************');
          return leadersMap;
        }
      }

    String getLeadersUrl = UrlConstants.GET_LEADERS_URL;
      Response leadersResponse = await get(Uri.parse(getLeadersUrl), headers:  {'Authorization': 'Bearer $access_token'})
          .timeout(const Duration(seconds: 5));
      Map leadersMapJson = await jsonDecode(leadersResponse.body) as Map<String, dynamic>;

      for (MapEntry leadersEntry in  leadersMapJson.entries) {
        List<User> currentMonthLeaders = <User>[];

        for (var leaderEntry in leadersEntry.value) {
          User userFromServer = User.fromJson(leaderEntry);
          currentMonthLeaders.add(userFromServer);
        }

        leadersMap.putIfAbsent(leadersEntry.key, () => currentMonthLeaders);
      }

      return leadersMap;

    } catch (e) {
      List<User> mocks = <User>[];
      mocks.add(MockUtils.mockUser());
      leadersMap.putIfAbsent('0', () => mocks);
      leadersMap.putIfAbsent('1', () => mocks);
      print(e);
    }

    return leadersMap;

  }

  static Future<void> registerWith(String email, String password) async{
    if (email.length<3 || password.length <= 8){
      return;
    }

    try {

      if (access_token == null) {
        access_token = await SecureUtils().retrieveValue(
            Constants.accessToken);
        await authorizeAsync();
        if (access_token == null) {
          print('register COULD NOT AUTHORIZE ********************************************************************');
          return;
        }
      }

      Response registerResponse = await post(Uri.parse(UrlConstants.POST_REGISTER_USER),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer $access_token'
          },
          body: jsonEncode(toJsonRegister(email, password)),
          encoding: Encoding.getByName("utf-8")).timeout(
          const Duration(seconds: 10));

      var responseDec = jsonDecode(registerResponse.body);
      User userFromServer = User.fromJson(responseDec);

      //TODO ?

    }catch(e){
      print(e);
    }
  }


  static Future<User?> register(String email, String password, String username) async {


    try {
      if (access_token == null) {
        access_token = await SecureUtils().retrieveValue(
            Constants.accessToken);
        await authorizeAsync();
        if (access_token == null) {
          print('reg COULD NOT AUTHORIZE ********************************************************************');
          return null;
        }
      }


      Response registerResponse = await post(
          Uri.parse(UrlConstants.POST_REGISTER_USER),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer $access_token'
          },
          body: jsonEncode(toJsonRegisterPlain(username, email, password)),
          encoding: Encoding.getByName("utf-8")).timeout(
          const Duration(seconds: 10));

      var responseDec = jsonDecode(registerResponse.body);
      User userFromServer = User.fromJson(responseDec);

      return userFromServer;

    } catch (e) {
      print(e);
    }

    return null;
  }

  static Future<Map<int, MatchEvent>> getLeagueLiveEventsAsync(Timer? timer) async {

    Map jsonMatchesData = LinkedHashMap();

    try {
      if (access_token == null) {
        access_token = await SecureUtils().retrieveValue(
            Constants.accessToken);
        await authorizeAsync();
        if (access_token == null) {
          print('COULD NOT AUTHORIZE ********************************************************************');
          return new Map();
        }
      }

      Response liveMatchesResponse = await get(Uri.parse(UrlConstants.GET_LIVE_EVENTS), headers:  {'Authorization': 'Bearer $access_token'}).timeout(const Duration(seconds: 10));
      jsonMatchesData = await jsonDecode(liveMatchesResponse.body) as Map;
    } catch (e) {
      // Fluttertoast.showToast(msg:  'LIVE   ' +e.toString());
      print('ERROR REST ---- MOCKING............');
      Map<int, MatchEvent> validData = new Map();// MockUtils().mockLeaguesMap(AppContext.eventsPerDayMap, false);
      return validData;
    }


    return await convertJsonLiveMatchesToObjects(jsonMatchesData);
  }

  static Future<Map<String, List<LeagueWithData>>> getLeagueEventsAsync(Timer? timer) async {

    Map jsonLeaguesData = LinkedHashMap();

    try {
      if (access_token == null) {
        access_token = await SecureUtils().retrieveValue(
            Constants.accessToken);
        await authorizeAsync();
        if (access_token == null) {
          print('COULD NOT AUTHORIZE ********************************************************************');
          return new Map();
        }
      }

      Response leaguesResponse = await get(Uri.parse(UrlConstants.GET_LEAGUE_EVENTS), headers:  {'Authorization': 'Bearer $access_token'}).timeout(const Duration(seconds: 10));
      jsonLeaguesData = await jsonDecode(leaguesResponse.body) as Map;
    } catch (e) {
      // Fluttertoast.showToast(msg: 'EVENTS   ' +e.toString());
      print('ERROR REST ---- MOCKING............');
      Map<String, List<LeagueWithData>> validData = Map();//  MockUtils().mockLeaguesMap(AppContext.eventsPerDayMap, false);
      return validData;
    }

    return await convertJsonLeaguesToObjects(jsonLeaguesData);
  }

  static Future<List<League>> getLeaguesAsync(Timer? timer) async {

    List<League> jsonLeaguesData = <League>[];

    try {
      if (access_token == null) {
        access_token = await SecureUtils().retrieveValue(
            Constants.accessToken);
        await authorizeAsync();
        if (access_token == null) {
          print('COULD NOT AUTHORIZE ********************************************************************');
          return jsonLeaguesData;
        }
      }

      Response leaguesResponse = await get(Uri.parse(UrlConstants.GET_LEAGUES), headers:  {'Authorization': 'Bearer $access_token'}).timeout(const Duration(seconds: 10));
      Iterable leaguesIterable = json.decode(leaguesResponse.body);
      jsonLeaguesData = List<League>.from(leaguesIterable.map((model)=> League.fromJson(model)));
    } catch (e) {
      // Fluttertoast.showToast(msg:  'LEAGUES   ' +e.toString());
      print('ERROR REST ---- LEAGUES MOCKING............');

    }

    return jsonLeaguesData;
  }


  static Future<List<Section>> getSectionsAsync(Timer? timer) async {

    List<Section> jsonSectionsData = <Section>[];

    try {

      if (access_token == null) {
        access_token = await SecureUtils().retrieveValue(
            Constants.accessToken);

        if (access_token == null) {
          print('COULD NOT AUTHORIZE ********************************************************************');
          return jsonSectionsData;
        }
      }

      print('TOKEN ' + access_token!);


      String url = UrlConstants.GET_SECTIONS;
      Response sectionsHttpResponse = await get(Uri.parse(url),
          headers:  {'Authorization': 'Bearer $access_token'}).timeout(const Duration(seconds: 10));
      Iterable sectionsIterable = json.decode(sectionsHttpResponse.body);
      jsonSectionsData = List<Section>.from(sectionsIterable.map((model)=> Section.fromJson(model)));
    } catch (e) {
      // Fluttertoast.showToast(msg:  'SECTIONS   ' +e.toString());
      print('ERROR REST ---- SECTIONS MOCKING............');

    }

    return jsonSectionsData;
  }


  static Future<void> authorizeAsync() async {

    if (access_token == null) {
      String? token = await SecureUtils().retrieveValue(Constants.accessToken);
      if (token != null) {
        access_token = token;
        return;
      }
    }

    try {

      String token = await getToken();
      Response authHttpResponse = await post(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          },
          Uri.parse(UrlConstants.AUTH),
          body: jsonEncode({'uniqueDeviceId' : '$token'}),
          encoding: Encoding.getByName("utf-8"))
          .timeout(const Duration(seconds: 10));
      var responseDec = await jsonDecode(authHttpResponse.body);

      // SecureUtils

      print(responseDec['access_token']);

      String? accessTkn = (responseDec['access_token']);
      if (accessTkn==null){
        return ;
      }

      SecureUtils().storeValue(Constants.accessToken, accessTkn);

      access_token = accessTkn;
      return ;
    } catch (e) {
      Fluttertoast.showToast(msg:  'AUTHORIZATION   ' +e.toString());
      print('ERROR AUTH ---- ............');
    }


  }

  static Map<String, dynamic> toJsonLogin(emailOrUsername, password) {

    var encryptedWithAES_2 = encryptWithAES(emailOrUsername, createKey(UrlConstants.URL_ENC));
    var encryptedWithAES = encryptWithAES(password, createKey(encryptedWithAES_2.base64));

    print('sending ' +encryptedWithAES_2.base64 + ' size ' + encryptedWithAES_2.base64.length.toString() );
    print('sending ' +encryptedWithAES.base64+ ' size ' + encryptedWithAES.base64.length.toString() );

    return {
      "email": encryptedWithAES_2.base64,
      "password": encryptedWithAES.base64,
      "username": emailOrUsername
    };
  }

  static Map<String, dynamic> toJsonRegister(email, password) {

    // var encryptedWithAES = encryptWithAES(password, email);
    var encryptedWithAES_2 = encryptWithAES(email, createKey(UrlConstants.URL_ENC));
    var encryptedWithAES = encryptWithAES(password, createKey(encryptedWithAES_2.base64));
    // var encryptedWithAES_2 = encryptWithAES(email, encryptedWithAES.base64);


    print('sending ' +encryptedWithAES_2.base64 + ' size ' + encryptedWithAES_2.base64.length.toString() );
    print('sending ' +encryptedWithAES.base64+ ' size ' + encryptedWithAES.base64.length.toString() );

    return {
      "email": encryptedWithAES_2.base64,
      "password": encryptedWithAES.base64
    };
  }

  static Map<String, dynamic> toJsonRegisterPlain(username, email, password) {
    // var encryptedWithAES = encryptWithAES(password, email);
    var encryptedWithAES_2 = encryptWithAES(
        email, createKey(UrlConstants.URL_ENC));
    var encryptedWithAES = encryptWithAES(
        password, createKey(encryptedWithAES_2.base64));
    // var encryptedWithAES_2 = encryptWithAES(email, encryptedWithAES.base64);


    print('sending ' + encryptedWithAES_2.base64 + ' size ' +
        encryptedWithAES_2.base64.length.toString());
    print('sending ' + encryptedWithAES.base64 + ' size ' +
        encryptedWithAES.base64.length.toString());

    return {
      "email": encryptedWithAES_2.base64,
      "password": encryptedWithAES.base64,
      "username": username
    };
  }

  static Future<User?> getUserAsync(String mongoId) async{


    try {
      if (access_token == null) {
        access_token = await SecureUtils().retrieveValue(
            Constants.accessToken);
        await authorizeAsync();
        if (access_token == null) {
          print('COULD NOT AUTHORIZE ********************************************************************');
          return null;
        }
      }

    String getUserUrlFinal = UrlConstants.GET_USER_URL + mongoId;
      Response userResponse = await get(Uri.parse(getUserUrlFinal), headers:  {'Authorization': 'Bearer $access_token'}).timeout(const Duration(seconds: 10));
      var responseDec = await jsonDecode(userResponse.body);
      return User.fromJson(responseDec);
    } catch (e) {
      //Fluttertoast.showToast(msg:  'USER   ' +e.toString());
      return null;
    }
  }


  static Future<Map<int, MatchEvent>> convertJsonLiveMatchesToObjects(Map jsonLeaguesData) async{
    Map<int, MatchEvent> newEventsPerDayMap = LinkedHashMap();
    for (MapEntry dailyLeagues in  jsonLeaguesData.entries) {
      int day = int.parse(dailyLeagues.key);

      var leaguesWithDataJson = dailyLeagues.value;

      MatchEvent? leagueObj = await MatchEvent.eventFromJson(leaguesWithDataJson);

      newEventsPerDayMap.putIfAbsent(day, ()=> leagueObj);
    }

    return newEventsPerDayMap;
  }

  static Future<Map<String, List<LeagueWithData>>> convertJsonLeaguesToObjects(Map jsonLeaguesData) async{
    Map<String, List<LeagueWithData>> newEventsPerDayMap = LinkedHashMap();
    for (MapEntry dailyLeagues in  jsonLeaguesData.entries) {
      String day = dailyLeagues.key;

      var leaguesWithDataJson = dailyLeagues.value;
      List<LeagueWithData> leaguesWithData = <LeagueWithData>[];
      for (var leagueWithData in leaguesWithDataJson) {
        LeagueWithData? leagueObj = await JsonHelper.leagueWithDataFromJson(leagueWithData);
        if (leagueObj == null){
          continue;
        }
        leaguesWithData.add(leagueObj);
      }

      newEventsPerDayMap.putIfAbsent(day, ()=> leaguesWithData);
    }

    return newEventsPerDayMap;
  }


}
