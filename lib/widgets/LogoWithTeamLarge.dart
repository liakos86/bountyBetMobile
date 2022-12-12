import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../enums/ChangeEvent.dart';
import '../models/Team.dart';

class LogoWithTeamLarge extends StatelessWidget{

  Team team;

  LogoWithTeamLarge({Key ?key, required this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return

        Container(
          padding: EdgeInsets.all(10),
          width: 120,
          decoration: BoxDecoration(
            //shape: BoxShape.rectangle,
            border: Border.all(width: 3, color: Colors.blue.shade200),
              color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))
          ),


        child:
      Column(//mainAxisSize: MainAxisSize.min,// HOME TEAM NAME ROW

        children: [
           Image.network(
                        team.logo,
                        height: 64,
                        width: 64
                    ),

                Text(team.name,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
              ],
            ),

      //)
      // )
    );
  }


}