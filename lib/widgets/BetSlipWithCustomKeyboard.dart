
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/enums/BetPlacementStatus.dart';
import 'package:flutter_app/utils/BetUtils.dart';
import 'package:flutter_app/widgets/row/LiveMatchRow.dart';
import 'package:flutter_app/widgets/row/UserPredictionRow.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/UserPrediction.dart';
import '../models/constants/Constants.dart';
import '../models/match_event.dart';
import './row/SelectedOddRow.dart';
// import 'SelectedOddRow.dart';

class BetSlipWithCustomKeyboard extends StatefulWidget {


  late final List<UserPrediction> selectedOdds;

  /*
   * Input
   */
  late final Function(UserPrediction) callbackForBetRemoval;

  late final Function(double) callbackForBetPlacement;

  BetSlipWithCustomKeyboard({Key? key, required this.selectedOdds, required this.callbackForBetPlacement, required this.callbackForBetRemoval}) : super (key: key);

  @override
  BetSlipWithCustomKeyboardState createState() => BetSlipWithCustomKeyboardState(selectedOdds, callbackForBetPlacement, callbackForBetRemoval);

}

class BetSlipWithCustomKeyboardState extends State<BetSlipWithCustomKeyboard>{

  TextEditingController betAmountController = TextEditingController();
  /*
   * Input
   */
  Function(double) callbackForBetPlacement;

  /*
   * Input
   */
  Function(UserPrediction) callbackForBetRemoval;

  List<UserPrediction> selectedOdds;

  double bettingAmount = 0;

  // String errorMsg = Constants.empty;

  BetSlipWithCustomKeyboardState(
     this.selectedOdds,
     this.callbackForBetPlacement,
     this.callbackForBetRemoval);

  @override
  void initState() {
    selectedOdds = widget.selectedOdds;
    callbackForBetRemoval = widget.callbackForBetRemoval;
    callbackForBetPlacement = widget.callbackForBetPlacement;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return

    Container(color: Colors.white, child:

          Flex(
            direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children : [
                Expanded( flex:16 ,  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: selectedOdds.length,
                    itemBuilder: (context, item) {
                      return _buildBettingOddRow(selectedOdds[item]);
                    })
                ),

                Expanded( flex:2 ,

                child: Padding(
                    padding: EdgeInsets.all(4),
                    child:Align(alignment: Alignment.centerLeft,
                    child: Text('${selectedOdds.length} selections @ ${BetUtils.finalOddOf(selectedOdds).toStringAsFixed(2)}'))
                )
                ),

                Expanded( flex:2 ,
                child:
                    Padding(
                      padding: EdgeInsets.all(4),
                    child:
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(flex: 1, child: Align(alignment: Alignment.centerLeft, child: Text('To return: ${(bettingAmount * BetUtils.finalOddOf(selectedOdds)).toStringAsFixed(2)}'))),
                        Expanded(flex: 1,
                          child:


                          Align(alignment: Alignment.centerRight,
                              child: TextField(
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
                      ],
                      )
                    )
                ),

                // Expanded( flex:1 ,
                //
                //     child: Padding(
                //         padding: const EdgeInsets.all(2),
                //         child:Align(alignment: Alignment.centerLeft,
                //             child: Text(errorMsg, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.red ),)
                //     )
                // )
                // ),


                Expanded( flex:2 ,
                  child:

                  TextButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                side: BorderSide(color: Colors.black)
                            )
                        ),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade500)
                    ),
                    onPressed: () {
                      if (bettingAmount <= 0){

                        Fluttertoast.showToast(msg: 'Please select a positive bet amount');

                        // setState(() {
                        //   errorMsg = 'Please select a positive bet amount';
                        // });

                        return;
                      }

                      //BetPlacementStatus betPlacementStatus = BetPlacementStatus.FAIL_GENERIC;

                      Future<BetPlacementStatus> betPlacementStatusFuture = callbackForBetPlacement.call(bettingAmount);
                      betPlacementStatusFuture.then((betPlacementStatus) =>
                      {
                        if (betPlacementStatus == BetPlacementStatus.PLACED){
                          Fluttertoast.showToast(
                              msg: 'Bet placed successfully'),

                          // errorMsg = Constants.empty,
                          Navigator.pop(context)
                        } else
                          {
                            Fluttertoast.showToast(
                                msg: betPlacementStatus.statusText)
                            // setState(() {
                            // errorMsg = betPlacementStatus.statusText;
                            // })
                            // }
                          }
                      }

                      );

                    },
                    child: const Text('Place Bet'),
                  ),
                )
              ]
          ));
  }

  Widget _buildBettingOddRow(UserPrediction bettingOdd) {

    return SelectedOddRow(key: UniqueKey(), prediction: bettingOdd, callback: (odd) => removePrediction(odd));
    return UserPredictionRow(key: UniqueKey(), prediction: bettingOdd, callback: (odd) => removePrediction(odd));


    // return SelectedOddRow(key: UniqueKey(), prediction: bettingOdd, callback: (odd) =>
    //     removePrediction(odd)
    // );
  }

  removePrediction(UserPrediction bettingOdd){
    callbackForBetRemoval.call(bettingOdd);

    setState(() {
      selectedOdds.remove(bettingOdd);
    });

  }


}

