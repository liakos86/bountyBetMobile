import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/interfaces/StatefulWidgetWithName.dart';


class LeaderBoardPage extends StatefulWidgetWithName {

  LeaderBoardPage(){
    setName('Leaderboard');
  }

  @override
  LeaderBoardPageState createState() => LeaderBoardPageState();

}

class LeaderBoardPageState extends State<LeaderBoardPage>{

  @override
  Widget build(BuildContext context) {

    return Container(
        child : Text('Leader board page')
    );

  }

}