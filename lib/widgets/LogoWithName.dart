import 'dart:ui';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../enums/WinnerType.dart';
import '../models/constants/Constants.dart';
import '../utils/cache/CustomCacheManager.dart';


class LogoWithName extends StatefulWidget {

  final String logoUrl;

  final String name;

  final int redCards;

  final double fontSize;

  final double logoSize;

  final WinnerType winnerType;

  final bool goalScored;

  final bool isHomeTeam;

  const LogoWithName(
      {Key ?key, required this.logoUrl, required this.logoSize, required this.fontSize,
        required this.name, required this.redCards, required this.winnerType, required this.goalScored, required this.isHomeTeam})
      : super(key: key);

  @override
  LogoWithNameState createState() => LogoWithNameState();
  }


  class LogoWithNameState extends State<LogoWithName>{

  late int redCards;

  late String logoUrl;

  late double logoSize;

  double fontSize=0;

  late String name;

  late WinnerType winnerType;

  late bool goalScored;

  late bool isHomeTeam;

  @override
  void initState() {
    super.initState();
    fontSize = widget.fontSize;
    logoSize = widget.logoSize;
    redCards = widget.redCards;
    name = widget.name;
    logoUrl = widget.logoUrl;
    winnerType = widget.winnerType;
    goalScored = widget.goalScored;
    isHomeTeam = widget.isHomeTeam;
  }

  @override
  Widget build(BuildContext context) {


    return
      Row(
        mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
            flex: 2,
            child:

            CachedNetworkImage(
              key: ValueKey(logoUrl),
              imageUrl: logoUrl,
              cacheManager: CustomCacheManager.instance,

              placeholderFadeInDuration: const Duration(milliseconds: 300),
              fadeInDuration: const Duration(milliseconds: 300),
              placeholder: (context, url) =>
                  Image.asset(Constants.assetNoLeagueImage, width: 32, height: 32),
              errorWidget: (context, url, error) =>
                  Image.asset(Constants.assetNoLeagueImage, width: 32, height: 32),

              height: logoSize,
              width: logoSize,
            ),


        ),

        Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.only(left: 0, top:8, bottom: 8),

              child: Column(
              children:  [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text( name + extraText(), overflow: TextOverflow.ellipsis, textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: WinnerType.NONE == winnerType && !goalScored ? FontWeight.w500 : FontWeight.w900, fontSize: fontSize, color: goalScored ? Colors.redAccent : Colors.white),)),
                 ]))),

        Expanded(
            flex: 2,
            child: Wrap( children:[
              redCards > 0 ?
              Image.asset('assets/images/redcard.png', width: 16, height: 16,)
            : const SizedBox(width: 0,),

              redCards > 1 ?
              Image.asset('assets/images/redcard.png', width: 16, height: 16,)
                  : const SizedBox(width: 0,),

              redCards > 2 ?
              Image.asset('assets/images/redcard.png', width: 16, height: 16,)
                  : const SizedBox(width: 0,)


            ])),


      ],

    );
  }

  String extraText() {
    if ((WinnerType.AGGREGATED_HOME == winnerType && isHomeTeam) || (WinnerType.AGGREGATED_AWAY == winnerType && !isHomeTeam)) {
      return '*' ;
    }

    return (Constants.empty);
  }


}