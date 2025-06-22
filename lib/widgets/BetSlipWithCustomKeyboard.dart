
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/enums/BetPlacementStatus.dart';
import 'package:flutter_app/utils/BetUtils.dart';

import '../models/UserPrediction.dart';
import '../models/constants/ColorConstants.dart';
import '../models/constants/Constants.dart';
import './row/SelectedOddRow.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class BetSlipWithCustomKeyboard extends StatefulWidget {

  late final double initialHeight;

  late final List<UserPrediction> selectedOdds;

  /*
   * Input
   */
  late final Function(UserPrediction?) callbackForBetRemoval;

  late final Function(double) callbackForBetPlacement;

  BetSlipWithCustomKeyboard({Key? key, required this.initialHeight, required this.selectedOdds, required this.callbackForBetPlacement, required this.callbackForBetRemoval}) : super (key: key);

  @override
  BetSlipWithCustomKeyboardState createState() => BetSlipWithCustomKeyboardState(initialHeight, selectedOdds, callbackForBetPlacement, callbackForBetRemoval);

}

class BetSlipWithCustomKeyboardState extends State<BetSlipWithCustomKeyboard>{

  bool executingCall = false;

  BetPlacementStatus betPlacementStatus = BetPlacementStatus.FAIL_GENERIC;

  TextEditingController betAmountController = TextEditingController();
  /*
   * Input
   */
  Function(double) callbackForBetPlacement;

  double initialHeight;

  /*
   * Input
   */
  Function(UserPrediction?) callbackForBetRemoval;

  List<UserPrediction> selectedOdds;

  double bettingAmount = 0;

  // String errorMsg = Constants.empty;

  BetSlipWithCustomKeyboardState(
     this.initialHeight,
     this.selectedOdds,
     this.callbackForBetPlacement,
     this.callbackForBetRemoval);

  @override
  void initState() {
    initialHeight = widget.initialHeight;
    selectedOdds = widget.selectedOdds;
    callbackForBetRemoval = widget.callbackForBetRemoval;
    callbackForBetPlacement = widget.callbackForBetPlacement;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return

      Container(
    color: Colors.grey.shade200,
    child:
    SizedBox(
        height: initialHeight,

        child:
    Column( children:
      [
        if (betPlacementStatus == BetPlacementStatus.PLACED  )

        Expanded(
          flex:  3 ,
          child:
              Container(
                height: 50,
                color:  const Color(ColorConstants.my_green) ,
                child:
                    Row(
                      children:[
                        Expanded(flex:1,
          child:

          Padding(
            padding: const EdgeInsets.all(4),
            child: 
              
              RichText(
                  text:  TextSpan(
                    children: [


                      const WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(Icons.check_circle, color: Colors.white,)
                      ),

                      TextSpan(
                        style: const TextStyle(fontSize: 16),
                        text: ('  ${selectedOdds.length}${AppLocalizations.of(context)!.betslip_selections}${(bettingAmount * BetUtils.finalOddOf(selectedOdds)).toStringAsFixed(2)}'),
                      ),
                    ],
                  )
              )

                 
          )

                    )
  ]
                    ),
        )),

        Expanded( flex:10,
                    child: ListView.builder(
                    padding: const EdgeInsets.all(2),
                    itemCount: selectedOdds.length,
                    itemBuilder: (context, item) {
                      return _buildBettingOddRow(selectedOdds[item]);
                    })
                ),

        betPlacementStatus == BetPlacementStatus.PLACED ?

        Expanded(
            flex: 3,
            child:
            // Column(
            //     mainAxisAlignment: MainAxisAlignment.end, // Pushes child to the bottom
            //     children: [
             Align(
            alignment: Alignment.bottomCenter,
            child:
            Padding(
            padding: const EdgeInsets.all(2),
            child:
          Row(
            mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
          flex:1,
          child:
            TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          side: const BorderSide(color: Colors.black)
                      )
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(ColorConstants.my_green))
              ),
              onPressed: () {

                callbackForBetRemoval.call(null);

              },
              child:  Text( AppLocalizations.of(context)!.close),
            )
      )
    ]
    )
                  )
        //    ]
            )

        )

        :

          Expanded(
            flex: 3,
                child:

                Align(
              alignment: Alignment.bottomCenter,
              child:


                Padding(
                      padding: const EdgeInsets.all(2),
                    child:
                    Row(
                      children: [

                        Expanded(flex: 2,
                          child:

                          Align(alignment: Alignment.centerRight,
                              child: TextField(
                                cursorColor: Colors.black,

                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            controller: betAmountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                              LengthLimitingTextInputFormatter(8),
                                TextInputFormatter.withFunction((oldValue, newValue) {
                                  final text = newValue.text;
                                  if (text.isEmpty) return newValue;

                                  // Only allow one decimal point
                                  if ('.'.allMatches(text).length > 1) {
                                    return oldValue;
                                  }

                                  // Allow only 2 decimal places
                                  final parts = text.split('.');
                                  if (parts.length > 1 && parts[1].length > 2) {
                                    return oldValue;
                                  }

                                  return newValue;
                                })
                            ],

                            onChanged:
                                (text) {
                              setState(() {
                                try{
                                  double.parse(text);
                                }catch(e){
                                  bettingAmount = 0;
                                  return;
                                }

                                bettingAmount = double.parse(text);



                              });
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.all(8),
                              isDense: true,
                              hintText: AppLocalizations.of(context)!.amount,


                            ),
                          )
                          ),


                        ),

                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 40,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: const Color(ColorConstants.my_green),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child:  Center(
                              child: Text(
                               'x ${BetUtils.finalOddOf(selectedOdds).toStringAsFixed(2)}', // Replace with your actual text
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                                overflow: TextOverflow.ellipsis, // Prevents wrap
                                maxLines: 1, // Ensures it stays on one line
                                softWrap: false,
                              ),
                            ),
                          ),
                        ),


                        (betPlacementStatus != BetPlacementStatus.PLACED) ?

                        Expanded(flex: 5, child:
                        SizedBox(height:40, child:
                        TextButton(

                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      side: const BorderSide(color: Colors.black)
                                  )
                              ),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade500)
                          ),
                          onPressed: () {
                            if (bettingAmount <= 0){
                              ScaffoldMessenger.of(context).showSnackBar(  SnackBar(
                                content: Text(AppLocalizations.of(context)!.betslip_positive_amount), showCloseIcon: true, duration: const Duration(seconds: 5),
                              ));
                              return;
                            }

                            if (executingCall){
                              return;
                            }

                            setState(() {
                              executingCall = true;
                            });

                            Future<BetPlacementStatus> betPlacementStatusFuture = callbackForBetPlacement.call(bettingAmount);
                            betPlacementStatusFuture.then((betPlacementStatus) =>
                            {
                              refreshStateAfterBet(betPlacementStatus)
                            }

                            );

                          },
                          child: executingCall ? const SizedBox(
                            height: 10.0,
                            width: 10.0,
                            child: Center(
                                child: CircularProgressIndicator()
                            ),
                          ) : Text('${AppLocalizations.of(context)!.betslip_place_bet}${bettingAmount > 0 ? '${AppLocalizations.of(context)!.betslip_returning}${(bettingAmount * BetUtils.finalOddOf(selectedOdds)).toStringAsFixed(2)}' : ''}'),
                        )),)

                            :
                        Expanded(flex: 1, child: TextButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      side: const BorderSide(color: Colors.black)
                                  )
                              ),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade500)
                          ),
                          onPressed: () {
                           Navigator.pop(context);

                          },
                          child:  Text(AppLocalizations.of(context)!.close),
                        ),)

                      ],
                      )
                    ),
             //   ]
                )
                ),
              ]
          )
        )
      );
  }

  Widget _buildBettingOddRow(UserPrediction bettingOdd) {

    return SelectedOddRow(key: UniqueKey(), betPlacementStatus: betPlacementStatus,  prediction: bettingOdd, callback: (odd) => removePrediction(odd));
  }

  removePrediction(UserPrediction bettingOdd){
    callbackForBetRemoval.call(bettingOdd);

    setState(() {
      selectedOdds.remove(bettingOdd);
      initialHeight = initialHeight - 100;
    });

  }

  refreshStateAfterBet(BetPlacementStatus betPlacementSt) {
    setState(() {
      executingCall = false;
      betPlacementStatus = betPlacementSt;
    });


  }



}

