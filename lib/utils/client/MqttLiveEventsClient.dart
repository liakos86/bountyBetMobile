// import 'package:flutter_app/models/constants/UrlConstants.dart';
// import 'package:mqtt_client/mqtt_client.dart';
// import 'dart:async';
//
// import 'package:mqtt_client/mqtt_server_client.dart';
//
//TODO if we go back to mqtt we need to implement WidgetsBindingObserver in parentPage and subscribe to topic
//
// class MqttLiveEventsClient {
//
// // connection succeeded
//   void onConnected() {
//     print('Connected');
//   }
//
// // unconnected
//   void onDisconnected() {
//     print('Disconnected');
//   }
//
// // subscribe to topic succeeded
//   void onSubscribed(String topic) {
//     print('Subscribed topic: $topic');
//   }
//
// // subscribe to topic failed
//   void onSubscribeFail(String topic) {
//     print('Failed to subscribe $topic');
//   }
//
// // unsubscribe succeeded
//   void onUnsubscribed(String? topic) {
//     print('Unsubscribed topic: $topic');
//   }
//
// // PING response received
//   void pong() {
//     print('Ping response client callback invoked');
//   }
//
//
//   Future<MqttClient> connect(String? deviceId) async {
//     MqttClient client = MqttServerClient.withPort(UrlConstants.SERVER_IP_PLAIN, 'fl_$deviceId', 1883);
//     client.logging(on: true);
//     client.onConnected = onConnected;
//     client.onDisconnected = onDisconnected;
//     client.onUnsubscribed = onUnsubscribed;
//     client.onSubscribed = onSubscribed;
//     client.onSubscribeFail = onSubscribeFail;
//     client.pongCallback = pong;
//
//     final connMessage = MqttConnectMessage()
//         .withClientIdentifier('fl_$deviceId')
//     //.authenticateAs('username', 'password')
//     //  .withProtocolName('mqtt')
//     // .withWillTopic('TestTopic')
//     //.withWillMessage('Will message')
//         .startClean()
//         .withWillQos(MqttQos.atLeastOnce);
//
//     client.logging(on: false);
//     client.setProtocolV311();
//     client.keepAlivePeriod = 200;
//     client.connectionMessage = connMessage;
//     try {
//       await client.connect();
//     } catch (e) {
//       print('**************************** Exception: $e');
//       client.disconnect();
//     }
//
//     return client;
//   }
//
//   void subscribeToLiveScores(MqttClient client){
//
//
//     client.subscribe("Soccer.MatchEventsLive", MqttQos.atMostOnce);
//   }
//
// }


//TODO parent page stuff

// Future<void> unsubscribeToLiveTopic() async {
//   // if (mqttClient != null && mqttClient?.connectionStatus == MqttConnectionState.connected|| mqttClient?.connectionStatus == MqttConnectionState.connecting){
//   mqttClient?.disconnect();
//   // }
// }

// Future<void> subscribeToLiveTopic() async {
//
//   if (mqttClient != null && (mqttClient?.connectionStatus == MqttConnectionState.connected || mqttClient?.connectionStatus == MqttConnectionState.connecting)){
//     return;
//   }
//
//   if (deviceId == null || deviceId!.isEmpty){
//     deviceId = await getDeviceId();
//   }
//
//   MqttLiveEventsClient mqtt = new MqttLiveEventsClient();
//   MqttClient client = await mqtt.connect(deviceId);
//   mqtt.subscribeToLiveScores(client);
//   client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
//
//     handleLiveScoreTopicMessage(c);
//
//   });
//
// }

// Future<String?> getDeviceId() async {
//   String deviceIdentifier = '';
//   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//   if (kIsWeb) {
//     final WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
//     deviceIdentifier = webInfo.vendor! +
//         webInfo.userAgent! +
//         webInfo.hardwareConcurrency.toString();
//   } else {
//     if (Platform.isAndroid) {
//       try {
//         final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//         deviceIdentifier = androidInfo.id;
//       }catch(e){
//         print(e.toString());
//       }
//     } else if (Platform.isIOS) {
//       final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
//       deviceIdentifier = iosInfo.identifierForVendor!;
//     } else if (Platform.isLinux) {
//       final LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
//       deviceIdentifier = linuxInfo.machineId!;
//     }
//   }
//
//   return deviceIdentifier.replaceAll('.', '');
// }

// void handleLiveScoreTopicMessage(List<MqttReceivedMessage<MqttMessage>> c) {
//
//   final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
//   final payload = MqttPublishPayload.bytesToStringAsString(
//       message.payload.message);
//   final jsonValues = json.decode(payload);
//   ChangeEventSoccer changeEventSoccer = ChangeEventSoccer.fromJson(jsonValues);
//  // print('Received message:$payload from topic: ${c[0].topic}>');
//
//   if (!mounted){
//     return;
//   }
//
//   for (League l in liveLeagues){
//
//     List<MatchEvent> events = l.liveEvents;
//     MatchEvent? relevantEvent;
//     for(MatchEvent e in events){
//       if (e.eventId == changeEventSoccer.eventId){
//         relevantEvent = e;
//         break;
//       }
//     }
//
//     if (relevantEvent == null){
//       continue;
//     }
//
//     if (ChangeEvent.MATCH_START == changeEventSoccer.changeEvent){
//       l.liveEvents.add(relevantEvent);
//       relevantEvent.status = MatchEventStatus.INPROGRESS.statusStr;
//     }
//
//     relevantEvent.changeEvent = changeEventSoccer.changeEvent;
//     relevantEvent.homeTeamScore = changeEventSoccer.homeTeamScore;
//     relevantEvent.awayTeamScore = changeEventSoccer.awayTeamScore;
//
//     MatchEvent parentEvent = ParentPageState.findEvent(changeEventSoccer.eventId);
//               parentEvent.changeEvent = changeEventSoccer.changeEvent;
//               parentEvent.homeTeamScore = changeEventSoccer.homeTeamScore;
//               parentEvent.awayTeamScore = changeEventSoccer.awayTeamScore;
//   }
//
//   oddsPageKey.currentState?.setState(() {
//     eventsPerDayMap;
//   });
//
//   livePageKey.currentState?.setState(() {
//     liveLeagues;
//   });
// }
