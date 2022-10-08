import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../enums/ChangeEvent.dart';
import '../models/Team.dart';

class LogoWithTeam extends StatelessWidget{

  Team team;

  LogoWithTeam({Key ?key, required this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min,// HOME TEAM NAME ROW

        children: [
          Padding(
              padding: EdgeInsets.all(6), child:

          Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                    child: Image.network(
                        team.logo,
                        height: 24,
                        width: 24
                    )),
                WidgetSpan(child: SizedBox(width: 10)),
                TextSpan(text: team.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black)),
              ],
            ),
          )

          ),
        ]);
  }


}