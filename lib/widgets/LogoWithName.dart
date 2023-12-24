import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LogoWithName extends StatefulWidget {

  final String logoUrl;

  final String name;

  final int redCards;

  const LogoWithName(
      {Key ?key, required this.logoUrl, required this.name, required this.redCards})
      : super(key: key);

  @override
  LogoWithNameState createState() => LogoWithNameState();
  }


  class LogoWithNameState extends State<LogoWithName>{

  late int redCards;

  late String logoUrl;

  late String name;

  @override
  void initState() {
    super.initState();
    redCards = widget.redCards;
    name = widget.name;
    logoUrl = widget.logoUrl;
  }

  @override
  Widget build(BuildContext context) {
    return
      Row(
        mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
            flex: 2,
            child: Image.network(
              logoUrl,
              height: 24,
              width: 24,
            )),

        Expanded(
            flex: 6,
            child: Padding(
              padding: EdgeInsets.only(left: 0, top:8, bottom: 8),

              child: Column(
              children:  [Align(
                  alignment: Alignment.centerLeft,
                  child: Text(name, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left,  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),)),
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