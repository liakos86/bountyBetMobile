
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/client/HttpActionsClient.dart';

import '../models/constants/ColorConstants.dart';

class DialogUserRegistered extends StatelessWidget{

  String text ='';


  DialogUserRegistered({required this.text});

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






       ///////////////////////

      // children: [
      //
      //   Text(
      //    text, style: const TextStyle(color: Colors.black),
      //   ),
      //
      //   TextButton(
      //     style: ButtonStyle(
      //         elevation: MaterialStateProperty.all<double>(10),
      //         foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      //         backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade500)
      //     ),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     child: Text('OK'),
      //   )
      //
      // ],

    )
    );
    }
    )
      );

  }

  void registerWith(String email, String password) async{
      if (email.length<3 || !email.contains('@gmail.com') || password.length <= 8){
        return;
      }

      await HttpActionsClient.registerWith(email, password);

    }



}