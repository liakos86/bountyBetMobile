import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LogoWithName extends StatelessWidget{

  final String logoUrl;

  final String name;

  LogoWithName({Key ?key, required this.logoUrl, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Row(

      children: [
        Expanded(
            flex: 2,
            child: Container(

                child: Image.network(
                  logoUrl,
                  height: 24,
                  width: 24,
                ),
        )),

        Expanded(
            flex: 6,
            child: Padding(
              padding: EdgeInsets.only(left: 0, top:8, bottom: 8),

              child: Column(
              children:  [Align(
                  alignment: Alignment.centerLeft,
                  child: Container( child: Text(name, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left,  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),))),
                 ]))),

      ],

    );
  }

}