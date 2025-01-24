
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/enums/BetPlacementStatus.dart';
import 'package:flutter_app/utils/BetUtils.dart';
import 'package:flutter_app/widgets/row/LiveMatchRow.dart';
import 'package:flutter_app/widgets/row/UserPredictionRow.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/UserPrediction.dart';
import '../models/constants/ColorConstants.dart';
import '../models/constants/Constants.dart';
import '../models/match_event.dart';
import './row/SelectedOddRow.dart';
// import 'SelectedOddRow.dart';

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

  BetPlacementStatus betPlacementStatus = BetPlacementStatus.PENDING;

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
                          child: Icon(Icons.check_circle, color: Colors.white,)
                      ),
                      TextSpan(
                        style: const TextStyle(fontSize: 16),
                        text: ('${selectedOdds.length} selections @ ${BetUtils.finalOddOf(selectedOdds).toStringAsFixed(2)} to return: ${(bettingAmount * BetUtils.finalOddOf(selectedOdds)).toStringAsFixed(2)}'),
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
              child: const Text('Close'),
            )
      )
    ]
    )

        )

        :

          Expanded(
            flex: 3,
                child:

                    Padding(
                      padding: const EdgeInsets.all(4),
                    child:
                    Row(
                      children: [

                        Expanded(flex: 3,
                          child:

                          Align(alignment: Alignment.centerRight,
                              child: TextField(
                                cursorColor: Colors.white,

                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            controller: betAmountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(9)],

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

                                if (bettingAmount > Constants.maxBet){
                                  Fluttertoast.showToast(msg: 'Maximum bet amount is ${Constants.maxBet}');
                                  // errorMsg = 'Maximum bet amount is ${Constants.maxBet}';
                                }

                              });
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(8),
                              isDense: true,
                              hintText: 'Amount',


                            ),
                          )
                          ),


                        ),

                        (betPlacementStatus != BetPlacementStatus.PLACED) ?

                        Expanded(flex: 5, child: TextButton(
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
                              Fluttertoast.showToast(msg: 'Please select a positive bet amount');
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
                          child: executingCall ? const CircularProgressIndicator() : Text('Place bet${bettingAmount > 0 ? ' returning ${(bettingAmount * BetUtils.finalOddOf(selectedOdds)).toStringAsFixed(2)}' : ''}'),
                        ),)

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
                          child: const Text('Close'),
                        ),)

                      ],
                      )
                    )
                ),
              ]
          ));
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

