// import 'dart:io';
//
// import 'package:flutter_background_service_platform_interface/src/configs.dart';
//
// import 'package:flutter_app/main.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
//
//
// class MyFlutterBackgroundService{
//
//    late final _service;
//
//   init() async {
//     if (_service == null) {
//       _service = await initializeBackgroundService();
//     }
//   }
//
//    Future<FlutterBackgroundService> initializeBackgroundService() async {
//     var service = FlutterBackgroundService();
//
//     /// OPTIONAL, using custom notification channel id
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'my_foreground', // id
//       'MY FOREGROUND SERVICE', // title
//       description:
//       'This channel is used for important notifications.', // description
//       importance: Importance.high, // importance must be at low or higher level
//     );
//
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
//
//     if (Platform.isIOS || Platform.isAndroid) {
//       await flutterLocalNotificationsPlugin.initialize(
//         const InitializationSettings(
//           iOS: DarwinInitializationSettings(),
//           android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//         ),
//       );
//     }
//
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//
//     await service.configure(
//       androidConfiguration: AndroidConfiguration(
//         // this will be executed when app is in foreground or background in separated isolate
//         onStart: onStart,
//
//         // auto start service
//         autoStart: true,
//         isForegroundMode: true,
//
//         notificationChannelId: 'my_foreground',
//         initialNotificationTitle: 'AWESOME SERVICE',
//         initialNotificationContent: 'Initializing',
//         foregroundServiceNotificationId: 888,                   // TODO: look this up
//       ),
//       iosConfiguration: IosConfiguration(
//         // auto start service
//         autoStart: true,
//         // this will be executed when app is in foreground in separated isolate
//         onForeground: onStart,
//         // you have to enable background fetch capability on xcode project
//         onBackground: onIosBackground,
//       ),
//     );
//
//     return service;
//   }
//
//    //get backgroundService => _service!;
//
//    bool isAndroidService(){
//     return _service is AndroidServiceInstance;
//    }
//
//    Future<bool> isForegroundService(){
//     return _service.isForegroundService();
//    }
//
//   void setForegroundNotificationInfo({required String title, required String content}) {
//     _service.setForegroundNotificationInfo(
//       title: title,
//       content: content,
//     );
//   }
//
// }
//
// final MyFlutterBackgroundService service = MyFlutterBackgroundService();