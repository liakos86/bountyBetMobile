import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/constants/ColorConstants.dart';
import 'package:flutter_app/models/constants/PurchaseConstants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class DialogTextWithConfirmCancel extends StatelessWidget{//} StatefulWidget {

  final Function confirmCallback;

  final String text;

  const DialogTextWithConfirmCancel({super.key, required this.confirmCallback, required this.text});

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

              Row(
                  mainAxisSize: MainAxisSize.max,
                  children:[

                    Expanded(flex:1, child:

                    ElevatedButton(
                      onPressed: () {
                        confirmCallback.call();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.red[400],  // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Rounded radius
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Button size
                      ),
                      child:  Text(

                        AppLocalizations.of(context)!.confirm_button_text,
                        maxLines: 1,
                        style: const TextStyle(

                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic
                        ),
                      ),
                    )),

                    const SizedBox(width: 4),

                    Expanded(flex:1, child:
                    ElevatedButton(
                      onPressed: () {
                        // Handle button press
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor:  const Color(ColorConstants.my_dark_grey),  // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Rounded radius
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Button size
                      ),
                      child:  Text(
                          AppLocalizations.of(context)!.cancel_button_text,
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic
                        ),
                      ),
                    )),

                  ]
              ),


        ]
        )

              );
            }
      )

        );
    }


  }

