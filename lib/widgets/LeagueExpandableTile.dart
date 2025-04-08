import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/MatchEventStatus.dart';
import 'package:flutter_app/models/match_event.dart';
import 'package:flutter_app/widgets/row/UpcomingMatchRowTilted.dart';

import '../helper/SharedPrefs.dart';
import '../models/UserPrediction.dart';
import '../models/constants/ColorConstants.dart';
import '../models/constants/Constants.dart';
import '../models/LeagueWithData.dart';
import '../models/context/AppContext.dart';
import '../pages/ParentPage.dart';
import '../utils/cache/CustomCacheManager.dart';

class LeagueExpandableTile extends StatefulWidget {

  final LeagueWithData leagueWithData;

  final List<MatchEvent> events;

  final List<UserPrediction> selectedOdds;

  final Function(UserPrediction) callbackForOdds;

  final List<String> favourites;

  final bool expandAll;

  final bool isAlwaysExpanded;

  const LeagueExpandableTile(
      {Key ?key, required this.leagueWithData, required this.isAlwaysExpanded, required this.events, required this.selectedOdds, required this.callbackForOdds, required this.favourites, required this.expandAll, })
      : super(key: key);

  @override
  LeagueExpandableTileState createState() =>
      LeagueExpandableTileState();
  }

  class LeagueExpandableTileState extends State<LeagueExpandableTile>{

    late LeagueWithData leagueWithData;

    late List<MatchEvent> events;

    late List<UserPrediction> selectedOdds;

    late Function(UserPrediction) callbackForOdds;

    late List<String> favourites;

    late bool expandAll;

    late bool isAlwaysExpanded;

    @override
    void initState() {
      super.initState();
    }

  @override
  Widget build(BuildContext context) {


      isAlwaysExpanded = widget.isAlwaysExpanded;

      leagueWithData = widget.leagueWithData;
      events = widget.events;
      selectedOdds = widget.selectedOdds;
      callbackForOdds = widget.callbackForOdds;
      favourites = widget.favourites;
      expandAll = widget.expandAll;

      return Theme(
        key: UniqueKey(),
        data: Theme.of(context).copyWith(
          listTileTheme: ListTileTheme.of(context).copyWith(
            dense: true,

          ) ,
        ),

                child:

            ExpansionTile(
    key: UniqueKey(),

    onExpansionChanged: (expanded) {

    },

    iconColor: Colors.transparent,
    collapsedIconColor: Colors.transparent,
    initiallyExpanded: expandAll,
    collapsedBackgroundColor: Colors.grey.shade200,
    backgroundColor: Colors.yellow[50],
    subtitle: Text(leagueWithData.league.getLocalizedName(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 10),),
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

      const SizedBox(width: 4),

      GestureDetector(
          onTap: () async =>
          {
              if (leagueWithData.league.isFavourite){
                sharedPrefs.removeFavLeague(
                    leagueWithData.league.league_id.toString()),
               updateFav(false)
              } else
                {
                  sharedPrefs.appendLeagueId(
                      leagueWithData.league.league_id.toString()),
                 updateFav(true)
                },
              ParentPageState.favouritesUpdate(),

          },

          child:
                  leagueWithData.league.isFavourite ?
                  const Icon(Icons.favorite, color: Colors.red)
                      :
                  const Icon(Icons.favorite_border, color: Color(ColorConstants.my_dark_grey)),
      )

    ]
        ),

    leading:

    CachedNetworkImage(
      cacheManager: CustomCacheManager(),
    imageUrl: leagueWithData.league.logo ?? Constants.noImageUrl,
    placeholder: (context, url) => Image.asset(Constants.assetNoLeagueImage, width: 32, height: 32,),
    errorWidget: (context, url, error) => Image.asset(Constants.assetNoLeagueImage, width: 32, height: 32,),
    height: 32,
    width: 32,
    ),

    title: Text(AppContext.allSectionsMap[leagueWithData.league.section_id] != null ? AppContext.allSectionsMap[leagueWithData.league.section_id].getLocalizedName().toUpperCase() : 'Section: ${leagueWithData.league.section_id}',
    style: TextStyle(fontSize: 9, color: Colors.grey[600], fontWeight: FontWeight.bold)),

    children: events.map((item)=> _buildSelectedOddRow(item)).toList(),

    ),

      );
  }


  Widget _buildSelectedOddRow(MatchEvent event) {
     return UpcomingOrEndedMatchRowTilted(key: UniqueKey(), gameWithOdds: event, selectedOdds: selectedOdds, callbackForOdds: callbackForOdds);
  }

    updateFav(bool newfav) {
      int priorityChange = newfav ? 10000 : -10000;
      leagueWithData.league.priority += priorityChange;

      setState(() {
        leagueWithData.league.isFavourite = newfav;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            newfav ? 'Added ${leagueWithData.league.name} to favourites' : 'Removed ${leagueWithData.league.name} from favourites'
        ),
        showCloseIcon: true,
        duration: const Duration(seconds: 5),
      ));

    }

}