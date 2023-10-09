import 'dart:convert';

import 'package:mqtt_client/mqtt_client.dart';
import 'dart:async';

import 'package:mqtt_client/mqtt_server_client.dart';

import '../../models/ChangeEventSoccer.dart';

// connection succeeded
void onConnected() {
  print('Connected');
}

// unconnected
void onDisconnected() {
  print('Disconnected');
}

// subscribe to topic succeeded
void onSubscribed(String topic) {
  print('Subscribed topic: $topic');
}

// subscribe to topic failed
void onSubscribeFail(String topic) {
  print('Failed to subscribe $topic');
}

// unsubscribe succeeded
void onUnsubscribed(String? topic) {
  print('Unsubscribed topic: $topic');
}

// PING response received
void pong() {
  print('Ping response client callback invoked');
}


Future<MqttServerClient> connect() async {
  MqttServerClient client =
  MqttServerClient.withPort('192.168.1.8', 'flutter_client', 1883);
  client.logging(on: true);
  client.onConnected = onConnected;
  client.onDisconnected = onDisconnected;
  client.onUnsubscribed = onUnsubscribed;
  client.onSubscribed = onSubscribed;
  client.onSubscribeFail = onSubscribeFail;
  client.pongCallback = pong;

  final connMessage = MqttConnectMessage()
  .withClientIdentifier('flutter_client')
      //.authenticateAs('username', 'password')
    //  .withProtocolName('mqtt')
     // .withWillTopic('TestTopic')
      //.withWillMessage('Will message')
      .startClean()
      .withWillQos(MqttQos.atLeastOnce);

  client.logging(on: true);
  client.setProtocolV311();
  client.keepAlivePeriod = 10000;
  client.connectionMessage = connMessage;
  try {
     await client.connect();
  } catch (e) {
    print('**************************** Exception: $e');
    client.disconnect();
  }



  client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    print('Received message size ${c.length}');
    final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
    final payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
    final jsonValues = json.decode(payload);
    ChangeEventSoccer changeEventSoccer = ChangeEventSoccer.fromJson(jsonValues);

    print('Received message:$payload from topic: ${c[0].topic}>');
  });

  client.subscribe("Soccer.MatchEventsLive", MqttQos.atMostOnce);

  return client;
}


main(){
  connect();
}