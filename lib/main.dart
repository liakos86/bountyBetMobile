
import 'package:flutter_app/models/constants/ColorConstants.dart';
import 'package:flutter_app/utils/ImageUtils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/ParentPage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';
import 'package:uuid/uuid.dart';



import 'dart:async';
import 'enums/ChangeEvent.dart';
import 'helper/SharedPrefs.dart';
import 'models/ChangeEventSoccer.dart';


/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;


/// Initialize the [FlutterLocalNotificationsPlugin] package.
 FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// final Set<String> _processedUuids = {};
// final _lock = Lock();


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  //init firebase
  await Firebase.initializeApp(
    name: 'fantasy-tips',
    // options: DefaultFirebaseOptions.currentPlatform,
    options: const FirebaseOptions(//google-services file
      apiKey: 'AIzaSyBwFEXTcO7S2NZ4a-HTgR99rctc2H9-bTQ',
      appId: '1:485157773987:android:209bdff1f47600ce0b5516',
      messagingSenderId: '485157773987', // firebase console ->Cloud messaging
      projectId: 'bountybet-firebase',
    ),
  );

  FirebaseMessaging.onBackgroundMessage( _firebaseMessagingBackgroundHandler );

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }

  await sharedPrefs.init();

  runApp(MyApp());
}

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);


  // Initialize FlutterLocalNotificationsPlugin
  var initializationSettingsAndroid = AndroidInitializationSettings('notification_icon');
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: false,
    badge: false,
    sound: false,
  );
  isFlutterLocalNotificationsInitialized = true;
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      localizationsDelegates: AppLocalizations.localizationsDelegates, // <--- add this
      supportedLocales: AppLocalizations.supportedLocales, // <--- add this

      theme: ThemeData(
          textTheme: GoogleFonts.kanitTextTheme(),// GoogleFonts.poppinsTextTheme(),
          primaryColor: const Color(ColorConstants.my_green)),
      home: ParentPage(),
    );
  }
}



  /*
 * This will run in the background, so it does not share the same shared prefs with the app.
 * We need to initialize the shared prefs to avoid null pointers.
 * Reloading is also required to update newly added favourites.
 */
@pragma('vm:entry-point') // avoid discarding during tree shake
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    //await setupFlutterNotifications();


    handleIncomingTopicMessageWhenInBackground(message);
  }

  void handleIncomingTopicMessageWhenInBackground(RemoteMessage message) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.reload();
    var favEventIds = prefs.getStringList(sp_fav_event_ids) ?? <String>[];
    if (favEventIds.isEmpty){
      return;
    }

    final payload = message.data;
    final String msgId = message.messageId.toString();
    try {
      // final jsonValues = json.decode(payload['changeEvent']);
      if (payload['changeEvent'] == null){
        return;
      }

      ChangeEventSoccer changeEventSoccer = ChangeEventSoccer.fromJson(payload);
      // if (_processedUuids.contains(changeEventSoccer.uniqueId)) {
      //   //print('Duplicate message ignored: $uuid');
      //   return;
      // }
      //
      // _processedUuids.add(changeEventSoccer.uniqueId);


      for (String fav in favEventIds){
       int favEventId = int.parse(fav);

      if (favEventId == changeEventSoccer.eventId){

        String name = changeEventSoccer.changeEvent == ChangeEvent.HOME_GOAL ? changeEventSoccer.homeTeam : changeEventSoccer.awayTeam;
        String file = await ImageUtils.downloadAndSaveFile(changeEventSoccer.imgUrl, name);

      flutterLocalNotificationsPlugin.show(
        generateUniqueNotificationId(),
        notificationBodyFrom(changeEventSoccer),
        changeEventSoccer.uniqueId,
        // changeEventSoccer.changeEvent.displayName,
        NotificationDetails(
          iOS: const DarwinNotificationDetails(),//TODO: needs setup for IOS
          android: AndroidNotificationDetails(
            'high_importance_channel_fantasy_tips', // id
            'High Importance Notifications ft',
            // groupKey: null,
            groupKey: 'unique_key_${changeEventSoccer.uniqueId}',
            // 'MY FOREGROUND SERVICE',
            largeIcon: FilePathAndroidBitmap(file),
           // largeIcon: icon,//  '@mipmap/ic_launcher',
            priority: Priority.high,
            ongoing: false,
          ),
        ),
      );
      }
      }
    }catch(e){
      // print('Invalid message: $payload - $msgId');
    }
  }

String notificationBodyFrom(ChangeEventSoccer changeEventSoccer) {
  switch (changeEventSoccer.changeEvent){
    // case ChangeEvent.FULL_TIME:
    //   return '${changeEventSoccer.homeTeam.name} ${changeEventSoccer.homeTeamScore.current} - ${changeEventSoccer.awayTeamScore.current} ${changeEventSoccer.awayTeam.name}';
    case ChangeEvent.HOME_GOAL:
      return 'Goal for ${changeEventSoccer.homeTeam}: ${changeEventSoccer.homeTeamScore} - ${changeEventSoccer.awayTeamScore}';
    case ChangeEvent.AWAY_GOAL:
      return 'Goal for ${changeEventSoccer.awayTeam}: ${changeEventSoccer.homeTeamScore} - ${changeEventSoccer.awayTeamScore}';
    case ChangeEvent.FULL_TIME:
      return 'Match ended ${changeEventSoccer.homeTeam}: ${changeEventSoccer.homeTeamScore} - ${changeEventSoccer.awayTeamScore} ${changeEventSoccer.awayTeam}';
    case ChangeEvent.AWAITING_ET:
      return 'Awaiting extra time ${changeEventSoccer.homeTeam}: ${changeEventSoccer.homeTeamScore} - ${changeEventSoccer.awayTeamScore} ${changeEventSoccer.awayTeam}';


  // case ChangeEvent.HALF_TIME:
    //   return 'Half time ${changeEventSoccer.homeTeamScore.current} - ${changeEventSoccer.awayTeamScore.current}';
    // case ChangeEvent.HOME_RED_CARD:
    //   return 'Home red ${changeEventSoccer.homeTeamScore.current} - ${changeEventSoccer.awayTeamScore.current}';
    // case ChangeEvent.AWAY_RED_CARD:
    //   return 'Away red ${changeEventSoccer.homeTeamScore.current} - ${changeEventSoccer.awayTeamScore.current}';
    default:
      return 'Nothing';
  }

}

int generateUniqueNotificationId() {
  return const Uuid().v4().hashCode & 0x7fffffff;
}
