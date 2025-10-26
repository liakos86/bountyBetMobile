import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/constants/ColorConstants.dart';

import '../../models/constants/Constants.dart';
import '../../models/context/AppContext.dart';
import '../dialog/DialogTextWithConfirmCancel.dart';
import 'AwardContainerWithText.dart';
import 'ProgressBarWithCenteredText.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class FantasyTipsDrawer extends StatelessWidget {

  const FantasyTipsDrawer({super.key, required this.logoutCallback, required this.deleteCallback});

  final Function logoutCallback;
  final Function deleteCallback;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,// const Color(ColorConstants.my_dark_grey),
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.black87,
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
                        maxLines:1,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: Colors.white,
                          fontSize: 16,

                        ),
                      ),
                      const SizedBox(height: 16), // Add space before status

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
                          DialogTextWithConfirmCancel(confirmCallback: logoutCallback, text: AppLocalizations.of(context)!.logout_text )
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
                  child: ProgressBarWithCenteredText(text:'${AppLocalizations.of(context)!.all_time_bets} ${(AppContext.user.betSlipsOverallPercentage() * 100).toStringAsFixed(0)}%  =  ${AppContext.user.betSlipsOverallText()}', // Display percentage
                            value: AppContext.user.betSlipsOverallPercentage() )
              )]),

              const SizedBox(height: 12),

    Row(children:[
              Expanded(
                  flex: 1,
                  child: ProgressBarWithCenteredText(text:'${AppLocalizations.of(context)!.all_time_predictions}  ${(AppContext.user.betPredictionsOverallPercentage() * 100).toStringAsFixed(0)}%  =  ${AppContext.user.betPredictionsOverallText()}', // Display percentage
                      value: AppContext.user.betPredictionsOverallPercentage())
              )]),


          const SizedBox(height: 12),

          if (AppContext.user.awards.isNotEmpty)
            Row(children:[
              Expanded(
                  flex: 1,
                  child:
                  AwardContainerWithText(award: AppContext.user.awards[0], fontSize: 12)

              ),

              if (AppContext.user.awards.length > 1)
                Expanded(
                    flex: 1,
                    child:
                    AwardContainerWithText(award: AppContext.user.awards[1], fontSize: 12)

                ),

              if (AppContext.user.awards.length > 2)
                Expanded(
                    flex: 1,
                    child:
                    AwardContainerWithText(award: AppContext.user.awards[2], fontSize: 12)

                ),

              if (AppContext.user.awards.length > 3)
                Expanded(
                    flex: 1,
                    child:
                    AwardContainerWithText(award: AppContext.user.awards[3], fontSize: 12)

                ),

              if (AppContext.user.awards.length > 4)
                Expanded(
                    flex: 1,
                    child:
                    AwardContainerWithText(award: AppContext.user.awards[4], fontSize: 12)

                ),

            ]),



          // Attribution link
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: () async {
                // final url = Uri.parse('https://www.vecteezy.com/free-vector/logotype');
                // if (await canLaunchUrl(url)) {
                //   await launchUrl(url, mode: LaunchMode.externalApplication);
                // }
              },
              child: Text(
                'Logotype Vectors by Vecteezy',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),


          const SizedBox(height: 24),
          // Attribution link

          if (AppContext.user.mongoUserId != Constants.defMongoId && AppContext.user.mongoUserId != Constants.offlineMongoId)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: () async {

                showDialog(context: context, builder: (context) =>
                    DialogTextWithConfirmCancel(confirmCallback: deleteCallback, text: 'ARE YOU SURE YOU WANT TO DELETE YOUR ACCOUNT???')
                );


              },
              child: Text(
                'Delete my account',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.red,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),


        ],
      ),
    );
  }
}
