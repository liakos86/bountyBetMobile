import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/constants/ColorConstants.dart';

class ProgressBarWithCenteredText extends StatelessWidget{

  final String text;
  final double value;

  ProgressBarWithCenteredText({
    required this.text,
    required this.value,
  });


  @override
  Widget build(BuildContext context) {
   return  Stack(
     alignment: Alignment.center, // Align the text to the center of the Stack
     children: [
       SizedBox(
           height: 24,
           child:
           LinearProgressIndicator(
             borderRadius: const BorderRadius.all(Radius.circular(8)),
             value: value,
             backgroundColor: Colors.red[400],
             valueColor: const AlwaysStoppedAnimation<Color>(Color(ColorConstants.my_green)),
           )
       ),
       Text(
         text,
         style: const TextStyle(
           fontSize: 12, // Adjust the font size as needed
           fontWeight: FontWeight.bold,
           color: Colors.white, // You can customize the color here
         ),
       ),
     ],
   );
  }

}