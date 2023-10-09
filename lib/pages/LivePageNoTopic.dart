// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:collection/collection.dart'; // You have to add this manually, for some reason it cannot be added automatically
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/enums/ChangeEvent.dart';
// import 'package:flutter_app/enums/MatchEventStatus.dart';
// import 'package:flutter_app/models/ChangeEventSoccer.dart';
// import 'package:flutter_app/models/interfaces/StatefulWidgetWithName.dart';
// import 'package:flutter_app/utils/client/MqttLiveEventsClient.dart';
// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';
// import 'package:device_info_plus/device_info_plus.dart';
//
// import '../models/league.dart';
// import '../models/match_event.dart';
// import '../widgets/LeagueExpandableTile.dart';
//
//
// class LivePageNoTopic extends StatefulWidgetWithName {
//
//   @override
//   LivePageState createState() => LivePageState();
//
//   final List<League> liveLeagues ;
//
//   LivePageNoTopic({
//     Key? key,
//     required this.liveLeagues,
//
//     //setName('Today\'s Odds')
//
//   } ) : super(key: key);
//
//   // LivePage(List<League> _liveMatchesPerLeague, getLiveEventsCallBack) {
//   //   this.liveLeagues = _liveMatchesPerLeague;
//   //   this.functionReloadLiveLeagues = getLiveEventsCallBack;
//   //   setName('Live');
//   // }
//
// }
//
// class LivePageState extends State<LivePageNoTopic> with AutomaticKeepAliveClientMixin{
//
//
//   List<League> liveLeagues = <League>[];
//
//   @override
//   void initState(){
//     liveLeagues = widget.liveLeagues;
//
//     super.initState();
//
//   }
//
//   @override
//   void dispose(){
//     super.dispose();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//
//     return ListView.builder(
//             itemCount: liveLeagues.length,
//             itemBuilder: (context, item) {
//               return _buildRow(liveLeagues[item]);
//             });
//
//   }
//
//   Widget _buildRow(League league) {
//     return LeagueExpandableTile(key: UniqueKey(), league: league, events: league.liveEvents, selectedOdds: [], callbackForOdds: (a)=>{},);
//   }
//
//   @override
//   bool get wantKeepAlive => true;
// }