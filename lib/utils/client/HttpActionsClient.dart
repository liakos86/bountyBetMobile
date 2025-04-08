import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserBet.dart';
import 'package:flutter_app/models/beans/PlaceBetResponseBean.dart';
import 'package:flutter_app/models/constants/UrlConstants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:async';

import '../../enums/BetPlacementStatus.dart';
import '../../helper/JsonHelper.dart';
import '../../models/League.dart';
import '../../models/LeagueWithData.dart';
import '../../models/MatchEventStatisticsWithIncidents.dart';
import '../../models/Season.dart';
import '../../models/Section.dart';
import '../../models/User.dart';
import '../../models/UserMonthlyBalance.dart';
import '../../models/constants/Constants.dart';
import '../../models/context/AppContext.dart';
import '../../models/match_event.dart';
import '../SecureUtils.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import '../encrypt/encryption.dart';


class HttpActionsClient {

  static bool connected = false;

  static String? access_token;

  static Future<bool> onlineCheck() async{
    if (!connected){
      // print('connected = '+connected.toString());
      connected = await checkInternetConnectivity();
    }

    return connected;
  }

  static Future<bool> verifyPurchase(PurchaseDetails purchaseDetails) async{
    if (!connected){
      connected = await checkInternetConnectivity();
      if (!connected){
        return false;
      }
    }

    try {

      if (access_token == null) {
        access_token = await SecureUtils().retrieveValue(
            Constants.accessToken);
        await authorizeAsync();
        if (access_token == null) {
          print('register COULD NOT AUTHORIZE ********************************************************************');
          return false;
        }
      }

      var body = {
        "mongoUserId": AppContext.user.mongoUserId,
        "purchaseToken": purchaseDetails.verificationData.serverVerificationData,
        "platform": purchaseDetails.verificationData.source,
        "productId": purchaseDetails.productID,
        "status" : purchaseDetails.status.toString()
      };

      Response verificationResponse = await post(Uri.parse(UrlConstants.POST_VERIFY_PURCHASE),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer $access_token'
          },
          body: jsonEncode(body),
          encoding: Encoding.getByName("utf-8")).timeout(
          const Duration(seconds: 30));

      var responseDec = jsonDecode(verificationResponse.body);

      return responseDec['verified'];

    }catch(e){
      print(e);
      return false;
    }
  }

  static Future<User?> loginUser(String emailOrUsername, String password) async{
    if (!connected){
      connected = await checkInternetConnectivity();
      if (!connected){
        return null;
      }
    }

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
          const Duration(seconds: 30));

      var responseDec = jsonDecode(loginResponse.body);
      User userFromServer = User.fromJson(responseDec);

      return userFromServer;

    }catch(e){
      print(e);
      return null;
    }
  }

  static Future<PlaceBetResponseBean> placeBet(UserBet newBet) async {

    if (!connected){
      connected = await checkInternetConnectivity();
      if (!connected){
        return PlaceBetResponseBean(betId: '', betPlacementStatus: BetPlacementStatus.FAIL_GENERIC.statusText);
        // return BetPlacementStatus.FAIL_GENERIC;
      }
    }


    try {
    var encodedBet = jsonEncode(newBet.toJson());

      if (access_token == null) {
        access_token = await SecureUtils().retrieveValue(
            Constants.accessToken);
        await authorizeAsync();
        if (access_token == null) {
          print('COULD NOT AUTHORIZE ********************************************************************');
          return PlaceBetResponseBean(betId: '', betPlacementStatus: BetPlacementStatus.FAIL_GENERIC.statusText);
          // return BetPlacementStatus.FAIL_GENERIC;
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

    var responseDec = jsonDecode(userResponse.body);

    PlaceBetResponseBean responseBean = PlaceBetResponseBean.fromJson(responseDec);

    return responseBean;

    }catch(e){
      // print(e);
      return PlaceBetResponseBean(betId: '', betPlacementStatus: BetPlacementStatus.FAIL_GENERIC.statusText);
    }
  }

  static Future<Season> getSeasonStandings(int leagueId, int seasonId) async {
    if (!connected){
      connected = await checkInternetConnectivity();
      if (!connected){
        return Season.defSeason();
      }
    }

    String getSeasonUrlFinal = UrlConstants.GET_SEASON_STANDINGS.replaceFirst("{1}", leagueId.toString()).replaceFirst("{2}", seasonId.toString());

    try {

      if (access_token == null) {
        access_token = await SecureUtils().retrieveValue(
            Constants.accessToken);
        await authorizeAsync();
        if (access_token == null) {
          print('STANDINGS COULD NOT AUTHORIZE ********************************************************************');
          return Season.defSeason();
        }
      }

      Response userResponse = await get(Uri.parse(getSeasonUrlFinal), headers:  {'Authorization': 'Bearer $access_token'}).timeout(const Duration(seconds: 5));
      var responseDec = await jsonDecode(userResponse.body);
      return  Season.seasonFromJson(responseDec);
    } catch (e) {
      print(e);
      return Season.defSeason();
    }
  }

  static Future<MatchEventStatisticsWithIncidents> getStatisticsAsync(int eventId) async{

    if (!connected){
      connected = await checkInternetConnectivity();
      if (!connected){
        return MatchEventStatisticsWithIncidents();
      }
    }

    String getStatsUrlFinal = UrlConstants.GET_EVENT_STATISTICS_URL + eventId.toString();
    try {

      if (access_token == null) {
        access_token = await SecureUtils().retrieveValue(
            Constants.accessToken);
        await authorizeAsync();
        if (access_token == null) {
          // print('LEDERS COULD NOT AUTHORIZE ********************************************************************');
          return MatchEventStatisticsWithIncidents();
        }
      }

      Response response = await get(Uri.parse(getStatsUrlFinal), headers:  {'Authorization': 'Bearer $access_token'}).timeout(const Duration(seconds: 3));
      var responseDec = await jsonDecode(response.body);
      if (responseDec == null){
        return MatchEventStatisticsWithIncidents();
      }
      return MatchEventStatisticsWithIncidents.fromJson(responseDec);

    } catch (e) {
      print('STATS ERRROR ' + e.toString());
      return MatchEventStatisticsWithIncidents();
    }
  }

  static Future<Map<String, List<User>>> getLeadingUsers() async{

    Map<String, List<User>> leadersMap = LinkedHashMap();
    if (!connected){
      connected = await checkInternetConnectivity();
      if (!connected){
        return leadersMap;
      }
    }

    try {

      if (access_token == null) {
        access_token = await SecureUtils().retrieveValue(
            Constants.accessToken);
        await authorizeAsync();
        if (access_token == null) {
          // print('LEDERS COULD NOT AUTHORIZE ********************************************************************');
          return leadersMap;
        }
      }

    String getLeadersUrl = UrlConstants.GET_LEADERS_URL;
      Response leadersResponse = await get(Uri.parse(getLeadersUrl), headers:  {'Authorization': 'Bearer $access_token'})
          .timeout(const Duration(seconds: 20));
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
      // List<User> mocks = <User>[];
      // mocks.add(MockUtils.mockUser());
      // leadersMap.putIfAbsent('0', () => mocks);
      // leadersMap.putIfAbsent('1', () => mocks);
      // print(e);
    }

    return leadersMap;

  }

  static Future<User?> register(String username, String email, String password) async {
    if (!connected){
      connected = await checkInternetConnectivity();
      if (!connected){
        return null;
      }
    }

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
          const Duration(seconds: 30));

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
    if (!connected){
      connected = await checkInternetConnectivity();
      if (!connected){
        return Map();
      }
    }

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

      Response liveMatchesResponse = await get(Uri.parse(UrlConstants.GET_LIVE_EVENTS), headers:  {'Authorization': 'Bearer $access_token'}).timeout(const Duration(seconds: 20));
      jsonMatchesData = await jsonDecode(liveMatchesResponse.body) as Map;
    } catch (e) {
      // print('ERROR REST ---- MOCKING............');
      Map<int, MatchEvent> validData = new Map();// MockUtils().mockLeaguesMap(AppContext.eventsPerDayMap, false);
      return validData;
    }


    return await convertJsonLiveMatchesToObjects(jsonMatchesData);
  }

  static Future<Map<String, List<LeagueWithData>>> getLeagueEventsAsync(Timer? timer) async {

    if (!connected){
      connected = await checkInternetConnectivity();
      if (!connected){
        return Map();
      }
    }

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
      // print('ERROR REST ---- MOCKING............');
      Map<String, List<LeagueWithData>> validData = Map();//  MockUtils().mockLeaguesMap(AppContext.eventsPerDayMap, false);
      return validData;
    }

    return await convertJsonLeaguesToObjects(jsonLeaguesData);
  }

  static Future<List<League>> getLeaguesAsync(Timer? timer) async {

    List<League> jsonLeaguesData = <League>[];
    if (!connected){
      connected = await checkInternetConnectivity();
      if (!connected){
        return jsonLeaguesData;
      }
    }

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
      jsonLeaguesData = await Future.wait(
        leaguesIterable.map((model) async => await League.fromJson(model)),
      );// List<League>.from(leaguesIterable.map((model) async => await League.fromJson(model)));
    } catch (e) {
      String msg = e.toString();

      const int lineLength = 30; // Define the line length

      StringBuffer result = StringBuffer(); // To efficiently build the result string
      for (int i = 0; i < msg.length; i += lineLength) {
        result.write(msg.substring(i, i + lineLength > msg.length ? msg.length : i + lineLength));
        result.write('\n'); // Add a newline after every 30 characters
      }

      showToastInChunks(e.toString());
      print('ERROR REST ---- LEAGUES MOCKING............');
    }

    return jsonLeaguesData;
  }

  static Future<void> showToastInChunks(String input) async {
    const int chunkSize = 28; // Define the chunk size (28 characters)

    // Split the input string into chunks of 28 characters
    List<String> chunks = [];
    for (int i = 0; i < input.length; i += chunkSize) {
      chunks.add(input.substring(i, i + chunkSize > input.length ? input.length : i + chunkSize));
    }

    // Show each chunk as a FlutterToast with a long duration, waiting between each
    for (int i = 0; i < chunks.length; i++) {
      await Fluttertoast.showToast(
        msg: chunks[i],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5, // Duration for iOS/web (long duration)
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Wait for the toast duration to finish before showing the next one
      await Future.delayed(Duration(seconds: 5));  // Adjust delay if needed to match the toast length
    }
  }


  static Future<List<Section>> getSectionsAsync(Timer? timer) async {

    List<Section> jsonSectionsData = <Section>[];
    if (!connected){
      connected = await checkInternetConnectivity();
      if (!connected){
        return jsonSectionsData;
      }
    }

    try {

      if (access_token == null) {
        access_token = await SecureUtils().retrieveValue(
            Constants.accessToken);

        if (access_token == null) {
          print('COULD NOT AUTHORIZE ********************************************************************');
          return jsonSectionsData;
        }
      }

      String url = UrlConstants.GET_SECTIONS;
      Response sectionsHttpResponse = await get(Uri.parse(url),
          headers:  {'Authorization': 'Bearer $access_token'}).timeout(const Duration(seconds: 10));
      Iterable sectionsIterable = json.decode(sectionsHttpResponse.body);
      jsonSectionsData = List<Section>.from(sectionsIterable.map((model)=> Section.fromJson(model)));
    } catch (e) {
      if (e is TimeoutException){
        connected = false;
      }
      print('ERROR REST ---- SECTIONS MOCKING............');

    }

    return jsonSectionsData;
  }


  static Future<void> authorizeAsync() async {
    if (!connected){
      connected = await checkInternetConnectivity();
      if (!connected){
        return ;
      }
    }

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

      // print(responseDec['access_token']);

      String? accessTkn = (responseDec['access_token']);
      if (accessTkn==null){
        return ;
      }

      SecureUtils().storeValue(Constants.accessToken, accessTkn);

      access_token = accessTkn;
      return ;
    } catch (e) {
      print('ERROR AUTH ---- ............');
    }


  }

  static Map<String, dynamic> toJsonLogin(emailOrUsername, password) {

    var encryptedWithAES_2 = encryptWithAES(emailOrUsername, createKey(UrlConstants.URL_ENC));
    var encryptedWithAES = encryptWithAES(password, createKey(encryptedWithAES_2.base64));

    // print('sending ' +encryptedWithAES_2.base64 + ' size ' + encryptedWithAES_2.base64.length.toString() );
    // print('sending ' +encryptedWithAES.base64+ ' size ' + encryptedWithAES.base64.length.toString() );

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


    // print('sending ' +encryptedWithAES_2.base64 + ' size ' + encryptedWithAES_2.base64.length.toString() );
    // print('sending ' +encryptedWithAES.base64+ ' size ' + encryptedWithAES.base64.length.toString() );

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


    // print('sending ' + encryptedWithAES_2.base64 + ' size ' +
    //     encryptedWithAES_2.base64.length.toString());
    // print('sending ' + encryptedWithAES.base64 + ' size ' +
    //     encryptedWithAES.base64.length.toString());

    return {
      "email": encryptedWithAES_2.base64,
      "password": encryptedWithAES.base64,
      "username": username
    };
  }

  static Future<User?> getUserAsync(String mongoId) async{
    if (!connected){
      connected = await checkInternetConnectivity();
      if (!connected){
        return null;
      }
    }


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
      Response userResponse = await get(Uri.parse(getUserUrlFinal), headers:  {'Authorization': 'Bearer $access_token'}).timeout(const Duration(seconds: 30));
      var responseDec = await jsonDecode(userResponse.body);
      return User.fromJson(responseDec);
    } catch (e) {
      return null;
    }
  }

  static Future<List<UserMonthlyBalance>> getUserBalancesAsync(String mongoId) async{
    if (!connected){
      connected = await checkInternetConnectivity();
      if (!connected){
        return <UserMonthlyBalance>[];
      }
    }


    try {
      if (access_token == null) {
        access_token = await SecureUtils().retrieveValue(
            Constants.accessToken);
        await authorizeAsync();
        if (access_token == null) {
          print('COULD NOT AUTHORIZE ********************************************************************');
          return <UserMonthlyBalance>[];
        }
      }

      String getUserUrlFinal = UrlConstants.GET_USER_BALANCES + mongoId;
      Response userResponse = await get(Uri.parse(getUserUrlFinal), headers:  {'Authorization': 'Bearer $access_token'}).timeout(const Duration(seconds: 30));

      Iterable balancesIterable = json.decode(userResponse.body);
      List<UserMonthlyBalance> balances = await Future.wait(
        balancesIterable.map((model) async => await UserMonthlyBalance.fromJson(model)),
      );

      // print('balances success');
      return balances;
    } catch (e) {
      print('Balance err');
      return <UserMonthlyBalance>[];
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

  static Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print("No network connection (WiFi or Mobile not available)");
      return false;
    } else {
      bool isConnected = await hasActiveInternet();
      if (isConnected) {
        print("Internet is available");
        return true;
      } else {
        print("Network connected (WiFi/Mobile), but no internet access");
        return false;
      }
    }
  }

  static Future<bool> hasActiveInternet() async {
    const List<String> testUrls = [
     // 'https://www.google.com',
      'https://1.1.1.1',
      //'https://www.amazon.com'
    ];

    for (String url in testUrls) {
      try {
        final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));
        if (response.statusCode == 200) {
          return true; // Internet is accessible
        }
      } catch (e) {
        print(e);
        // Ignore and try the next URL
      }
    }
    return false; // No accessible server found
  }

  static void listenConnChanges(Function(bool conn) updateConnState) {
    Connectivity().onConnectivityChanged.listen(
          (ConnectivityResult result) {
        print("Connectivity Result: $result");
        if (result == ConnectivityResult.mobile) {
          connected = true;
        } else if (result == ConnectivityResult.wifi) {
          connected = true;
        } else if (result == ConnectivityResult.none) {
          connected = false;
        }

        updateConnState.call(connected);
      },
      onError: (error) {
        print("Error: $error");
      },
    );
  }


}
