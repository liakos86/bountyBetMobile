
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/constants/ColorConstants.dart';

class DialogUserRegistered extends StatelessWidget{

  final String text;

  const DialogUserRegistered({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;

    return

      AlertDialog(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
    ),
    content:
    Builder(
    builder: (context) {
    return SizedBox(width: width,
    child:

     Column(


       mainAxisSize: MainAxisSize.min,
       children: [

         Text(
           text,
           style: const TextStyle(fontSize: 16.0),
         ),
         const SizedBox(height: 20.0),

         ElevatedButton(
           onPressed: () {
             Navigator.pop(context);
           },
           style: ElevatedButton.styleFrom(
             foregroundColor: Colors.white, backgroundColor: const Color(ColorConstants.my_dark_grey),  // Text color
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(20), // Rounded radius
             ),
             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Button size
           ),
           child: const Text(
             'Close',
             style: TextStyle(
                 fontSize: 16,
                 fontWeight: FontWeight.bold,
                 fontStyle: FontStyle.italic
             ),
           ),
         )

       ]

    )
    );
    }
    )
      );

  }

}