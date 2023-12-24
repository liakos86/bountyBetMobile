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


        DecoratedBox(
          decoration: const BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))
          ),

        child:

            SizedBox(
          width:100,
            height:100,

            child:

                Container(
          height: double.infinity,
            child:
                Align(
            alignment: Alignment.center,
            child:
            Wrap(
alignment: WrapAlignment.spaceAround,
    verticalDirection: VerticalDirection.up,
    children: [
      Column(//mainAxisSize: MainAxisSize.min,// HOME TEAM NAME ROW
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

           Image.network(
                        team.logo,
                        height: 48,
                        width: 48
                    ),

                Text(team.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: const TextStyle(

                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black)),

              ],

      //  )
    //)
        )]
      //)
      ))))
    );
  }


}