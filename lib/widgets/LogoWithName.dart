import 'dart:io';
import 'dart:math';
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

  const LogoWithName(
      {Key ?key, required this.logoUrl, required this.logoSize, required this.fontSize,
        required this.name, required this.redCards, required this.winnerType, required this.goalScored})
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
              imageUrl: logoUrl,
              cacheManager: CustomCacheManager(),
              placeholder: (context, url) => Image.asset(Constants.assetNoTeamImage, width: logoSize, height: logoSize,),
              errorWidget: (context, url, error) => Image.asset(Constants.assetNoTeamImage, width: logoSize, height: logoSize,),
              height: logoSize,
              width: logoSize,
            ),

              // Image(
              //   image: NetworkImage(logoUrl),
              //     height: logoSize,
              //     width: logoSize,
              //   errorBuilder:
              //       ( context,  exception,  stackTrace) {
              //     if (exception is HttpException ) {
              //       return Image.asset("assets/images/substitution.png" , width: logoSize, height: logoSize,);
              //     } else {
              //       return Image.asset("assets/images/substitution.png", width: logoSize, height: logoSize,);
              //     }
              //   },
              // )
        ),

        Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.only(left: 0, top:8, bottom: 8),

              child: Column(
              children:  [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text( name + (WinnerType.AFTER == winnerType ? '*' : Constants.empty), overflow: TextOverflow.ellipsis, textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: WinnerType.NONE == winnerType ? FontWeight.w500 : FontWeight.w900, fontSize: fontSize, color: goalScored ? Colors.red : Colors.white),)),
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

}