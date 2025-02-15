import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/MatchEventStatus.dart';
import 'package:flutter_app/models/match_event.dart';
import 'package:flutter_app/widgets/row/UpcomingMatchRowTilted.dart';

import '../models/UserPrediction.dart';
import '../models/constants/Constants.dart';
import '../models/LeagueWithData.dart';
import '../models/context/AppContext.dart';
import '../utils/cache/CustomCacheManager.dart';

class LeagueExpandableTile extends StatefulWidget {

  final LeagueWithData league;

  final List<MatchEvent> events;

  final List<UserPrediction> selectedOdds;

  final Function(UserPrediction) callbackForOdds;

  // final Function callbackForExpansion;

  final List<String> favourites;

  final bool expandAll;

  final bool isAlwaysExpanded;

  // int index;

  const LeagueExpandableTile(
      {Key ?key, required this.league, required this.isAlwaysExpanded, required this.events, required this.selectedOdds, required this.callbackForOdds, required this.favourites, required this.expandAll, })
      : super(key: key);

  @override
  LeagueExpandableTileState createState() =>
      LeagueExpandableTileState();
  }

  class LeagueExpandableTileState extends State<LeagueExpandableTile>{

    // final ExpansionTileController controller = ExpansionTileController();

    late LeagueWithData league;

    late List<MatchEvent> events;

    late List<UserPrediction> selectedOdds;

    late Function(UserPrediction) callbackForOdds;
    // late Function callbackForExpansion;

    late List<String> favourites;

    late bool expandAll;

    late bool isAlwaysExpanded;

    // late int pos;


    @override
    void initState() {
      super.initState();
    }

  @override
  Widget build(BuildContext context) {


      isAlwaysExpanded = widget.isAlwaysExpanded;

      league = widget.league;
      events = widget.events;
      selectedOdds = widget.selectedOdds;
      callbackForOdds = widget.callbackForOdds;
      favourites = widget.favourites;
      expandAll = widget.expandAll;
      // callbackForExpansion = widget.callbackForExpansion;
      // pos = widget.index;

      return Theme(
        key: UniqueKey(),
        data: Theme.of(context).copyWith(
          listTileTheme: ListTileTheme.of(context).copyWith(
            dense: true,

          ) ,
        ),

                child:

            ExpansionTile(
    // controller: controller,
    key: UniqueKey(),
    // maintainState: false,

    onExpansionChanged: (expanded) {

    },

    iconColor: Colors.transparent,
    collapsedIconColor: Colors.transparent,
    initiallyExpanded: expandAll,
    collapsedBackgroundColor: Colors.grey.shade200,
    backgroundColor: Colors.yellow[50],
    subtitle: Text(league.league.getLocalizedName(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 10),),
    trailing:

        Row(
          mainAxisSize: MainAxisSize.min,
    children:[

      if (!expandAll)
    Container(
      width: 20, // Adjust width for rectangle shape
      height: 20, // Adjust height for rectangle shape
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all( // Adding border to the first container
          color: Colors.black, // Border color
          width: 0.5, // Border width
        ),
        borderRadius: BorderRadius.circular(4), // Optional rounded corners
      ),
      child: Text(
        '${events.length}',
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
                const SizedBox(width: 4),
      Container(
        width: 20, // Adjust width for rectangle shape
        height: 20, // Adjust height for rectangle shape
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.red,
          border: Border.all( // Adding border to the first container
            color: Colors.black, // Border color
            width: 0.5, // Border width
          ),
          borderRadius: BorderRadius.circular(4), // Optional rounded corners
        ),
        child: Text(
          '${events.where((element) => element.status == MatchEventStatus.INPROGRESS.statusStr).length}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

    ]
        ),

    // Text('(${events.length})', style: const TextStyle(color: Colors.black, fontSize: 9),),
    leading:

    CachedNetworkImage(
      cacheManager: CustomCacheManager(),
    imageUrl: league.league.logo ?? Constants.noImageUrl,
    placeholder: (context, url) => Image.asset(Constants.assetNoLeagueImage, width: 32, height: 32,),
    errorWidget: (context, url, error) => Image.asset(Constants.assetNoLeagueImage, width: 32, height: 32,),
    height: 32,
    width: 32,
    ),

    title: Text(AppContext.allSectionsMap[league.league.section_id] != null ? AppContext.allSectionsMap[league.league.section_id].getLocalizedName().toUpperCase() : 'unknown section: '+league.league.section_id.toString(),
    style: TextStyle(fontSize: 9, color: Colors.grey[600], fontWeight: FontWeight.bold)),

    children: events.map((item)=> _buildSelectedOddRow(item)).toList(),


    // onExpansionChanged: (bool expanding) => callExp(expanding)


    ),

         //   )
      );
  }

  // callExp(bool exp) async{
  //     if (exp) {
  //       callbackForExpansion.call(pos);
  //     }
  // }

  Widget _buildSelectedOddRow(MatchEvent event) {
    // MatchEventStatus? matchEventStatus =  MatchEventStatus.fromStatusText(event.status);
    // if (matchEventStatus == MatchEventStatus.INPROGRESS || matchEventStatus == MatchEventStatus.FINISHED
    //     || matchEventStatus == MatchEventStatus.POSTPONED || matchEventStatus == MatchEventStatus.CANCELLED) {
    //   return LiveMatchRow(key: UniqueKey(), gameWithOdds: event);
    // }

    // print('UPCMING ROW BUILDING ' + AppContext.eventsPerDayMap['0'].length.toString());


    // return UpcomingOrEndedMatchRow(key: UniqueKey(), gameWithOdds: event, selectedOdds: selectedOdds, callbackForOdds: callbackForOdds);
    return UpcomingOrEndedMatchRowTilted(key: UniqueKey(), gameWithOdds: event, selectedOdds: selectedOdds, callbackForOdds: callbackForOdds);
  }



}