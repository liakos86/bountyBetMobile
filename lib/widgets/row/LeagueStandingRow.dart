

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/models/StandingRow.dart';
import '../../enums/WinnerType.dart';
import '../../models/constants/ColorConstants.dart';
import '../LogoWithName.dart';

class LeagueStandingRow extends StatefulWidget {

  final StandingRow standing;


  const LeagueStandingRow({Key ?key, required this.standing}) : super(key: key);

  @override
  LeagueStandingRowState createState() => LeagueStandingRowState(standing: standing,);
}

class LeagueStandingRowState extends State<LeagueStandingRow> {

  StandingRow standing;


  LeagueStandingRowState({
    required this.standing,
  });


  @override
  Widget build(BuildContext context) {
    return

      Stack(
          clipBehavior: Clip.none, // Allow positioning outside the container
          children: [

      Container(
      padding: const EdgeInsets.all(2),
    margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 0),
    decoration: BoxDecoration(
    color: const Color(ColorConstants.my_dark_grey)
    , // Dark background color
    borderRadius: BorderRadius.circular(12),
    ),
    child:

    Row(//top father
        mainAxisSize: MainAxisSize.max,
        children: [
          // OLA TA CHILDREN PREPEI NA GINOUN EXPANDED!!!!!!!!!!!!!!!
          Expanded(//first column
              flex: 10,
              child:

              // Column(
              //
              // children: [

                Padding(padding: const EdgeInsets.only(left: 8),
                  child:
                  Align(
                  alignment: Alignment.centerLeft,
                  child:
                LogoWithName(key: UniqueKey(), name: standing.team.getLocalizedName(), logoUrl: standing.team.logo, redCards: 0, logoSize: 24, fontSize: 14,  winnerType: WinnerType.NONE),
                  )
                )
          //     ]
          // )
          ),
          Expanded(
              flex: 2,
              child:
              Align(
                  alignment: Alignment.centerRight,
                  child:
                  // Column(//second column
                  //     children: [
                  //      Padding(padding: const EdgeInsets.all(8), child:
                  Text((standing.wins_total.toString() + '-' + standing.draws_total.toString() + '-' + standing.losses_total.toString()), style: const TextStyle(
                      fontSize: 12,

                      fontWeight: FontWeight.bold,
                      color: Colors.white),)
              )
            // )
            //     ]
            // )
          ),
          //), // FIRST COLUMN END
          Expanded(
              flex: 2,
              child:
                  Align(
                    alignment: Alignment.centerRight,
                    child:
          // Column(//second column
          //     children: [
          //      Padding(padding: const EdgeInsets.all(8), child:
                Text((standing.goals_total).toString(), style: const TextStyle(
                    fontSize: 12,

                    fontWeight: FontWeight.bold,
                    color: Colors.white),)
                  )
          // )
          //     ]
          // )
      ),
          Expanded(
              flex: 2,
              child:
              Align(
                  alignment: Alignment.centerRight,
                  child:
                  // Column(//second column
                  //     children: [
                  //      Padding(padding: const EdgeInsets.all(8), child:
                  Text((standing.points).toString(), style: const TextStyle(
                      fontSize: 12,

                      fontWeight: FontWeight.bold,
                      color: Colors.white),)
              )
            // )
            //     ]
            // )
          ),
        ])

    ),
            Positioned(
                top: 8, // Slightly above the container
                left: 0, // Slightly left of the container
                child:

                _buildPosition()


            ),


          ]);
  }

  _buildPosition() {
    return

      Transform(
        transform: Matrix4.skewX(-0.2), // Tilt the container
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            // margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: const Color(ColorConstants.my_green), // Background color of the parallelogram
              borderRadius: BorderRadius.circular(8),
            ),
            child:

            Text(standing.position.toString(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),)

        ),
      );
  }
}


