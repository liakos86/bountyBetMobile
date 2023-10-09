
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/utils/BetUtils.dart';

import '../enums/ChangeEvent.dart';
import '../enums/MatchEventStatus.dart';
import '../enums/MatchEventStatusMore.dart';
import '../utils/MockUtils.dart';
import '../models/UserPrediction.dart';
import '../models/match_event.dart';
import 'SelectedOddRow.dart';

class BetSlipWithCustomKeyboard extends StatefulWidget {

  //bool showOdds = false;

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

          Flex(
            direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children : [
                Expanded( flex:16 , child: ListView.builder(
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
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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

                Expanded( flex:2 ,
                  child:
                  TextButton(
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade500)
                    ),
                    onPressed: () {
                      if (bettingAmount <= 0){
                        return;
                      }

                      Navigator.pop(context);
                      callbackForBetPlacement.call(bettingAmount);
                    },
                    child: const Text('Place Bet'),
                  ),
                )
              ]
          );
  }

  Widget _buildBettingOddRow(UserPrediction bettingOdd) {
    //MatchEvent eventOfOdd = ParentPageState.findEvent(bettingOdd.eventId);
      MatchEvent eventOfOdd = MockUtils().mockEvent(
          100,
          1.5,
          1.5,
          1.5,
          1.5,
          1.5,
          MatchEventStatus.INPROGRESS.statusStr,
          MatchEventStatusMore.INPROGRESS_1ST_HALF.statusStr,
          ChangeEvent.NONE);

    return SelectedOddRow(key: UniqueKey(), event: eventOfOdd, prediction: bettingOdd, callback: (odd) =>
        removePrediction(odd)
    );
  }

  removePrediction(UserPrediction bettingOdd){
    callbackForBetRemoval.call(bettingOdd);

    setState(() {
      selectedOdds.remove(bettingOdd);
    });

  }


}

