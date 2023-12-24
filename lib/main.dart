import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/helper/JsonHelper.dart';
import 'package:flutter_app/models/match_event.dart';
import 'package:flutter_app/pages/ParentPage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'dart:async';
import 'package:http/http.dart';

import 'enums/ChangeEvent.dart';
import 'enums/MatchEventStatus.dart';
import 'firebase_options.dart';
import 'helper/SharedPrefs.dart';
import 'models/ChangeEventSoccer.dart';
import 'models/constants/Constants.dart';
import 'models/constants/UrlConstants.dart';
import 'models/notification/NotificationInfo.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //init firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //ask permissions if not asked
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await sharedPrefs.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.green[900]),
      home: ParentPage(),
    );
  }
}

/*
 * This will run in the background, so it does not share the same shared prefs with the app.
 * We need to initialize the shared prefs to avoid null pointers.
 * Reloading is also required to update newly added favourites.
 */
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  sharedPrefs.init();
  sharedPrefs.reload();
  handleIncomingTopicMessageWhenInBackground(message);
}

void handleIncomingTopicMessageWhenInBackground(RemoteMessage message) async{

      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      // Set<MatchEvent> favEvents = await getLiveFavouritesAsync();

      var favEventIds = sharedPrefs.favEventIds;
      if (favEventIds.isEmpty){
        return;
      }

      final payload = message.data;
      final jsonValues = json.decode(payload['changeEvent']);
      ChangeEventSoccer changeEventSoccer = ChangeEventSoccer.fromJson(jsonValues);

      for (String fav in favEventIds){
        int favEventId = int.parse(fav);

        // NotificationInfo info = await checkForNotification(fav);
        if (favEventId == changeEventSoccer.eventId){
          flutterLocalNotificationsPlugin.show(
            888,
            changeEventSoccer.changeEvent.name,
            'Something happened!!!',
            const NotificationDetails(
              iOS: DarwinNotificationDetails(),

              android: AndroidNotificationDetails(
                'my_foreground',
                'MY FOREGROUND SERVICE',
                icon: '@mipmap/ic_launcher',
                ongoing: true,
              ),
            ),
          );
        }
      }
}

// Future<Set<MatchEvent>> getLiveFavouritesAsync() async {
//
//   if (sharedPrefs.favEventIds.isEmpty) {
//     return Set();
//   }
//
//   Set<MatchEvent> favMatches = {};
//
//   try {
//     Response favEventsResponse =
//     await get(Uri.parse(UrlConstants.GET_SPECIFIC_LIVE + sharedPrefs.favEventIds.join(Constants.comma)))
//         .timeout(const Duration(seconds: 20));
//     var matchesJson = await jsonDecode(favEventsResponse.body);
//     favMatches = JsonHelper.eventsSetFromJson(matchesJson);
//     return favMatches;
//   } catch (e) {
//     return favMatches;
//   }
// }

// Future<NotificationInfo> checkForNotification(MatchEvent existingEvent) async {
//
//   NotificationInfo notificationInfo = NotificationInfo();
//
//   if (ChangeEvent.isForNotification(existingEvent.changeEvent)) {
//     if (sharedPrefs.favEventIds.contains(existingEvent.eventId.toString())) {
//
//       notificationInfo.id = existingEvent.eventId;
//       notificationInfo.title = '${existingEvent.homeTeam.name} - ${existingEvent.awayTeam.name}';
//
//       if (ChangeEvent.isGoal(existingEvent.changeEvent)) {
//         notificationInfo.body = '${existingEvent.homeTeamScore!.current} - ${existingEvent.awayTeamScore!.current}';
//       } else if (ChangeEvent.RED_CARD == existingEvent.changeEvent) {
//         notificationInfo.body = 'RED CARD';
//       }
//
//       if (ChangeEvent.FULL_TIME == existingEvent.changeEvent) {
//         sharedPrefs.removeFavEvent(existingEvent.eventId.toString());
//       }
//     }
//   }
//
//   if (MatchEventStatus.FINISHED == existingEvent.status) {
//     sharedPrefs.removeFavEvent(existingEvent.eventId.toString());
//   }
//
//   return notificationInfo;
// }
