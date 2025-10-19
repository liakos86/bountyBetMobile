import 'package:animated_background/animated_background.dart';
import 'package:animated_background/particles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/Section.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/League.dart';
import '../../models/User.dart';
import '../../models/constants/ColorConstants.dart';
import '../../models/constants/Constants.dart';
import '../../models/context/AppContext.dart';
import '../../utils/client/HttpActionsClient.dart';
import '../ParentPage.dart';

class SplashScreen extends StatefulWidget {


  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  double _progress = 0;
  ParticleOptions? particles;
  bool loaded = false;

  @override
  void initState() {
    super.initState();

    simulateLoading();


    // initializeApp();
    // retrieveUser().then((a) =>
    //     updateUser(a)).then((h) => (
    //
    // HttpActionsClient.getSectionsAsync(null)
    //     .then((sections) => updateSections(sections))
    //     .then((updated) => HttpActionsClient.getLeaguesAsync(null))
    //     .then((leagues) => updateLeagues(leagues))
    //
    // ));

    // HttpActionsClient.getSectionsAsync(null)
    //     .then((sections) => updateSections(sections))
    //     .then((updated) => HttpActionsClient.getLeaguesAsync(null))
    //     .then((leagues) => updateLeagues(leagues));

  }

  void simulateLoading() async {
    await initializeApp();


    int step = 1;
    for (int i = 0; i <= 100; i = i + step) {
      await Future.delayed(const Duration(milliseconds: 30));
      if (AppContext.allSectionsMap.isNotEmpty) {
        step = 20;
      }

      setState(() {
        _progress = i / 100;
      });

    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ParentPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    particles = ParticleOptions(
      // image: Image.asset('assets/images/money-bag-100.png'),
      image: Image.network('https://xscore.cc/resb/league/europe-uefa-champions-league.png'),
      baseColor: Colors.amber,
      spawnOpacity: 0.0,
      opacityChangeRate: 0.25,
      minOpacity: 0.1,
      maxOpacity: 0.4,
      particleCount: 20,
      spawnMaxRadius: 15.0,
      spawnMaxSpeed: 100.0,
      spawnMinSpeed: 30,
      spawnMinRadius: 7.0,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBackground(
        vsync: this,
        behaviour: RandomParticleBehaviour(options: particles!),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0), // Adjust padding as needed
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Loading...",
                  style: TextStyle(fontSize: 22),
                ),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  value: _progress ,
                  backgroundColor: Colors.red[400],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(ColorConstants.my_blue)),
                  minHeight: 10,
                ),
                const SizedBox(height: 10),
                Text(
                  "${(_progress * 100).round()}%",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  initializeApp() async {
    try {
      final user = await retrieveUser();
      updateUser(user); // assumed to be void

      final sections = await HttpActionsClient.getSectionsAsync(null);
      updateSections(sections);

      final leagues = await HttpActionsClient.getLeaguesAsync(null);
      updateLeagues(leagues);

      setState(() {
        loaded = true;
      });// all steps completed successfully
    } catch (e, stackTrace) {
      // print('Initialization failed: $e');
      // Optionally log stackTrace or report the error
      setState(() {
        loaded = true;
      });// still return true, as you requested
    }
  }




  void updateSections(List<Section> secMap) {

    for ( Section s in secMap){
      AppContext.allSectionsMap.putIfAbsent(s.id, ()=>s);
    }

  }

  void updateLeagues(List<League> leagues) {
    for ( League l in leagues){
      if (AppContext.allLeaguesMap.containsKey(l.league_id)){
        AppContext.allLeaguesMap[l.league_id]?.copyFrom(l);
      }else {
        AppContext.allLeaguesMap.putIfAbsent(l.league_id, () => l);
      }

    }
  }

  /*
   * If shared prefs have a value , make a call to retrieve user
   */
  Future<User?> retrieveUser() async{
    SharedPreferences sh_prefs =  await SharedPreferences.getInstance();

    String? mongoIdFromPrefs = sh_prefs.getString(Constants.mongoId);
    if (mongoIdFromPrefs == null){
      return null;
    }

    return await HttpActionsClient.getUserAsync(mongoIdFromPrefs);
  }

  void updateUser(User? userNew){
    if (userNew == null){
      return;
    }

    if (Constants.defMongoId == userNew.mongoUserId){
      return;
    }

    AppContext.user.deepCopyFrom(userNew);
  }

}
