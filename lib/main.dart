import 'package:flutter/material.dart';
import 'package:flutter_app/pages/ParentPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(primaryColor: Colors.green[900]),
      home: ParentPage(),




    );
  }
}

