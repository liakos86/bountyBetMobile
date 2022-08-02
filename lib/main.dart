
import 'package:flutter/material.dart';
import 'package:flutter_app/examples/pages/CategoryListPage.dart';
import 'package:flutter_app/get_odds.dart';
//import './random_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.green[900]),
      home: GetOdds()
    );
  }
}

