import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../helper/SharedPrefs.dart';
import '../ParentPage.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: true,
        top: false,
        child:
        IntroductionScreen(
          pages: [

          PageViewModel(
          title: AppLocalizations.of(context)!.welcome,
          bodyWidget: Column(
            children: [
              SizedBox(
                height: 350, // desired height
                child: Image.asset(
                  "assets/images/onboard0.png",
                  fit: BoxFit.contain, // or BoxFit.cover
                ),
              ),

              Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                AppLocalizations.of(context)!.onboard1,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          )
            ],
          ),
          decoration: const PageDecoration(
            pageColor: Colors.white,
            bodyFlex: 0, // prevents the default body flex from limiting space
            imageFlex: 0, // prevents the default image flex from limiting space
            contentMargin: EdgeInsets.all(8),
          ),
        ),

          PageViewModel(
            title: AppLocalizations.of(context)!.welcome,
            bodyWidget: Column(
              children: [
                SizedBox(
                  height: 350, // desired height
                  child: Image.asset(
                    "assets/images/onboard12.png",
                    fit: BoxFit.contain, // or BoxFit.cover
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      AppLocalizations.of(context)!.onboard2,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
            decoration: const PageDecoration(
              pageColor: Colors.white,
              bodyFlex: 0, // prevents the default body flex from limiting space
              imageFlex: 0, // prevents the default image flex from limiting space
              contentMargin: EdgeInsets.all(8),
            ),
          ),

          PageViewModel(
            title: AppLocalizations.of(context)!.welcome,
            bodyWidget: Column(
              children: [
                SizedBox(
                  height: 350, // desired height
                  child: Image.asset(
                    "assets/images/onboard13.png",
                    fit: BoxFit.contain, // or BoxFit.cover
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      AppLocalizations.of(context)!.onboard3,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
            decoration: const PageDecoration(
              pageColor: Colors.white,
              bodyFlex: 0, // prevents the default body flex from limiting space
              imageFlex: 0, // prevents the default image flex from limiting space
              contentMargin: EdgeInsets.all(8),
            ),
          ),

          PageViewModel(
            title: AppLocalizations.of(context)!.welcome,
            bodyWidget: Column(
              children: [
                SizedBox(
                  height: 350, // desired height
                  child: Image.asset(
                    "assets/images/onboard14.png",
                    fit: BoxFit.contain, // or BoxFit.cover
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      AppLocalizations.of(context)!.onboard4,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
            decoration: const PageDecoration(
              pageColor: Colors.white,
              bodyFlex: 0, // prevents the default body flex from limiting space
              imageFlex: 0, // prevents the default image flex from limiting space
              contentMargin: EdgeInsets.all(8),
            ),
          ),

          PageViewModel(
            title: AppLocalizations.of(context)!.welcome,
            bodyWidget: Column(
              children: [
                SizedBox(
                  height: 350, // desired height
                  child: Image.asset(
                    "assets/images/onboard15.png",
                    fit: BoxFit.contain, // or BoxFit.cover
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      AppLocalizations.of(context)!.onboard5,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
            decoration: const PageDecoration(
              pageColor: Colors.white,
              bodyFlex: 0, // prevents the default body flex from limiting space
              imageFlex: 0, // prevents the default image flex from limiting space
              contentMargin: EdgeInsets.all(8),
            ),
          ),

          PageViewModel(
            title: AppLocalizations.of(context)!.welcome,
            bodyWidget: Column(
              children: [
                SizedBox(
                  height: 350, // desired height
                  child: Image.asset(
                    "assets/images/onboard16.png",
                    fit: BoxFit.contain, // or BoxFit.cover
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      AppLocalizations.of(context)!.onboard6,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
            decoration: const PageDecoration(
              pageColor: Colors.white,
              bodyFlex: 0, // prevents the default body flex from limiting space
              imageFlex: 0, // prevents the default image flex from limiting space
              contentMargin: EdgeInsets.all(8),
            ),
          ),

      ],
      onDone: () {

        sharedPrefs.ackWalkThrough();
        // Navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ParentPage()),
        );
      },
      onSkip: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ParentPage()),
        );
      },
      showSkipButton: true,
      skip: Text(AppLocalizations.of(context)!.skip),
      next: const Icon(Icons.arrow_forward),
      done: Text(AppLocalizations.of(context)!.confirm_button_text, style: TextStyle(fontWeight: FontWeight.w600)),
    )
    );
  }

}
