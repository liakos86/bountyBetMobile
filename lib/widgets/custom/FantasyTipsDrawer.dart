import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/constants/ColorConstants.dart';

import '../../models/constants/Constants.dart';
import '../../models/context/AppContext.dart';
import '../dialog/DialogTextWithConfirmCancel.dart';
import 'ProgressBarWithCenteredText.dart';

class FantasyTipsDrawer extends StatelessWidget {

  const FantasyTipsDrawer({super.key, required this.logoutCallback});

  final Function logoutCallback;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(ColorConstants.my_dark_grey),
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(ColorConstants.my_green),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0), // Add padding around the content
              child: Stack(
                children: [
                  // The content inside the header
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
                    children: [
                      // Username
                      Text(
                        AppContext.user.username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8), // Add some space between text elements

                      // Email
                      Text(
                        AppContext.user.email,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16), // Add space before status

                      // RichText for position and balance
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: AppContext.user.userPosition > 0
                                  ? ' pos[${AppContext.user.userPosition}] '
                                  : '[validation pending]',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const WidgetSpan(child: SizedBox(width: 8)),
                            AppContext.user.balance.balance > 0
                                ? WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(
                                Icons.currency_exchange,
                                size: 20,
                                color: Colors.amber,
                              ),
                            )
                                : const TextSpan(text: Constants.empty),
                            TextSpan(
                              text: AppContext.user.balance.balance > 0
                                  ? AppContext.user.balance.balance.toStringAsFixed(2)
                                  : Constants.empty,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Logout IconButton at the top-right corner
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 40, // Set width for the circular button
                      height: 40, // Set height for the circular button
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red, // Red background color
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                          size: 20, // Adjust size if needed
                        ),
                        onPressed: () {
                          showDialog(context: context, builder: (context) =>
                          DialogTextWithConfirmCancel(confirmCallback: logoutCallback, text: 'Are you sure you want to logout?')
                          );
                        },
                      ),
                    )
                    ,
                  ),
                ],
              ),
            ),
          ),

              Row(children:[
              Expanded(
                flex: 1,
                  child: ProgressBarWithCenteredText(text:'All time bets ${(AppContext.user.betSlipsOverallPercentage() * 100).toStringAsFixed(0)}%  =  ${AppContext.user.betSlipsOverallText()}', // Display percentage
                            value: AppContext.user.betSlipsOverallPercentage() )
              )]),

              const SizedBox(height: 12),

    Row(children:[
              Expanded(
                  flex: 1,
                  child: ProgressBarWithCenteredText(text:'All time predictions ${(AppContext.user.betPredsOverallPercentage() * 100).toStringAsFixed(0)}%  =  ${AppContext.user.betPredictionsOverallText()}', // Display percentage
                      value: AppContext.user.betSlipsOverallPercentage())
              )]),

        ],
      ),
    );
  }
}
