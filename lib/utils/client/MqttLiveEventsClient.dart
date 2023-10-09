import 'package:flutter_app/models/constants/UrlConstants.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'dart:async';

import 'package:mqtt_client/mqtt_server_client.dart';


class MqttLiveEventsClient {

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


  Future<MqttClient> connect(String? deviceId) async {
    MqttClient client = MqttServerClient.withPort(UrlConstants.SERVER_IP_PLAIN, 'fl_$deviceId', 1883);
    client.logging(on: true);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onUnsubscribed = onUnsubscribed;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('fl_$deviceId')
    //.authenticateAs('username', 'password')
    //  .withProtocolName('mqtt')
    // .withWillTopic('TestTopic')
    //.withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    client.logging(on: false);
    client.setProtocolV311();
    client.keepAlivePeriod = 200;
    client.connectionMessage = connMessage;
    try {
      await client.connect();
    } catch (e) {
      print('**************************** Exception: $e');
      client.disconnect();
    }

    return client;
  }

  void subscribeToLiveScores(MqttClient client){


    client.subscribe("Soccer.MatchEventsLive", MqttQos.atMostOnce);
  }

}
