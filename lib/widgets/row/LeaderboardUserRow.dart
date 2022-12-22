import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/models/StandingRow.dart';

import '../../models/User.dart';

class LeaderboardUserRow extends StatefulWidget {

  User user;


  LeaderboardUserRow({Key ?key, required this.user}) : super(key: key);

  @override
  LeaderboardRowState createState() => LeaderboardRowState(user: user);
}

class LeaderboardRowState extends State<LeaderboardUserRow> {

  User user;

  LeaderboardRowState({
    required this.user
  });


  @override
  Widget build(BuildContext context) {
    return

      SizedBox(

          height: 36,

          child:
          Row(//top father
              mainAxisSize: MainAxisSize.max,
              children: [
                // OLA TA CHILDREN PREPEI NA GINOUN EXPANDED!!!!!!!!!!!!!!!
                //), // FIRST COLUMN END
                Expanded(
                    child:
                    Column(//second column
                        children: [
                          Padding(padding: EdgeInsets.all(6), child:
                          Text(user.username, style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent),))
                        ]
                    )),//SECOND COLUMN END
              ])//parent column end
      );
  }
}


