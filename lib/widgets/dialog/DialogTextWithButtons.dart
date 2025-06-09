import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/constants/ColorConstants.dart';
import 'package:flutter_app/models/constants/PurchaseConstants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class DialogTextWithButtons extends StatelessWidget{//} StatefulWidget {

  final Function topUpCallback;

  const DialogTextWithButtons({super.key, required this.topUpCallback});

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
                AppLocalizations.of(context)!.topup_text,
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 20.0),

              Row(
                mainAxisSize: MainAxisSize.max,
                children:[

                  Expanded(flex:1, child:

              ElevatedButton(
                onPressed: () {
                  // Handle button press
                  Navigator.pop(context);
                  topUpCallback.call(PurchaseConstants.topup1000);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red[400],  // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded radius
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), // Button size
                ),
                child: Text(

                  '${AppLocalizations.of(context)!.topup_button_text} 1000',
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
                      topUpCallback.call(PurchaseConstants.topup3000);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.red[400],  // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Rounded radius
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), // Button size
                    ),
                    child: Text(
                      '${AppLocalizations.of(context)!.topup_button_text} 3000',
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
                child: Text(
                  AppLocalizations.of(context)!.close,
                  style: const TextStyle(
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

