import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../enums/ChangeEvent.dart';
import '../models/Team.dart';
import '../models/league.dart';

class LogoWithLeague extends StatelessWidget{

  League league;

  LogoWithLeague({Key ?key, required this.league}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
   
      Wrap(//mainAxisSize: MainAxisSize.min,// HOME TEAM NAME ROW

        children: [
          Padding(
              padding: EdgeInsets.all(6), child:

          Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                    child: Image.network(
                        league.logo ?? "https://tipsscore.com/resb/no-league.png",
                        height: 24,
                        width: 24
                    )),
                WidgetSpan(child: SizedBox(width: 10)),
                TextSpan(text: league.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black)),
              ],
            ),
          )

          ),
        ]
      );
  }


}