import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/match_event.dart';
import 'package:flutter_app/widgets/row/LiveMatchRow.dart';

import '../enums/MatchEventStatus.dart';
import '../models/UserPrediction.dart';
import '../models/constants/Constants.dart';
import '../models/league.dart';
import 'UpcomingMatchRow.dart';

class LeagueExpandableTile extends StatefulWidget {

  final League league;

  final List<MatchEvent> events;

  final List<UserPrediction> selectedOdds;

  final Function(UserPrediction) callbackForOdds;

  final List<String> favourites;


  LeagueExpandableTile(
      {Key ?key, required this.league, required this.events, required this.selectedOdds, required this.callbackForOdds, required this.favourites})
      : super(key: key);

  @override
  LeagueExpandableTileState createState() =>
      LeagueExpandableTileState();
  }

  class LeagueExpandableTileState extends State<LeagueExpandableTile>{

    late League league;

    late List<MatchEvent> events;

    late List<UserPrediction> selectedOdds;

    late Function(UserPrediction) callbackForOdds;

    late List<String> favourites;


    @override
    void initState() {
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
      league = widget.league;
      events = widget.events;
      selectedOdds = widget.selectedOdds;
      callbackForOdds = widget.callbackForOdds;
      favourites = widget.favourites;

      return Theme(
        key: UniqueKey(),
        data: Theme.of(context).copyWith(
          listTileTheme: ListTileTheme.of(context).copyWith(
            dense: true,
          ),
        ),

                child: ExpansionTile(
                    key: UniqueKey(),
                    maintainState: false,
                    iconColor: Colors.transparent,
                    collapsedIconColor: Colors.transparent,
                    initiallyExpanded: true,
                    collapsedBackgroundColor: Colors.yellow[50],
                    backgroundColor: Colors.yellow[50],
                    subtitle: Text(league.name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 12),),
                    trailing: Text('(${events.length})', style: const TextStyle(color: Colors.black, fontSize: 10),),
                    leading:

                    CachedNetworkImage(
                      imageUrl: league.logo ?? Constants.noImageUrl,
                      placeholder: (context, url) => Image.asset(Constants.assetNoLeagueImage, width: 32, height: 32,),
                      errorWidget: (context, url, error) => Image.asset(Constants.assetNoLeagueImage, width: 32, height: 32,),
                      height: 32,
                      width: 32,
                    ),

                    title: Text(league.section.name.toUpperCase(),
                        style: TextStyle(fontSize: 10, color: Colors.grey[600], fontWeight: FontWeight.bold)),
                    children: events.map((item)=> _buildSelectedOddRow(item)).toList()
                ),

         //   )
      );
  }

  Widget _buildSelectedOddRow(MatchEvent event) {
    MatchEventStatus? matchEventStatus =  MatchEventStatus.fromStatusText(event.status);
    if (matchEventStatus == MatchEventStatus.INPROGRESS || matchEventStatus == MatchEventStatus.FINISHED
        || matchEventStatus == MatchEventStatus.POSTPONED || matchEventStatus == MatchEventStatus.CANCELLED) {
      return LiveMatchRow(key: UniqueKey(), gameWithOdds: event);
    }

    return UpcomingMatchRow(key: UniqueKey(), gameWithOdds: event, selectedOdds: selectedOdds, callbackForOdds: callbackForOdds);
  }

}