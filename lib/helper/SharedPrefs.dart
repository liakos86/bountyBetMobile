import 'package:flutter_app/models/constants/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;
  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  void reload () async{
    await _sharedPrefs?.reload();
  }

  void appendEventId(String value){
    List<String> current =  _sharedPrefs?.getStringList(sp_fav_event_ids) ?? <String>[];//favEventIds;
    if (current.contains(value)) {
      throw new Exception("EVENT ALREADY IS FAVOURITE");
    }

    current.add(value);
    _sharedPrefs?.setStringList(sp_fav_event_ids, current);
    //reload();

  }

  void appendLeagueId(String value){
    List<String> current =  _sharedPrefs?.getStringList(sp_fav_league_ids) ?? <String>[];//favEventIds;
    if (current.contains(value)) {
      throw new Exception("LEAGUE ALREADY IS FAVOURITE");
    }

    current.add(value);
    _sharedPrefs?.setStringList(sp_fav_league_ids, current);
    //reload();

  }

  remove(String key){
    _sharedPrefs?.remove(key);
  }

  void removeFavEvent(String value){
    List<String> current =  _sharedPrefs?.getStringList(sp_fav_event_ids) ?? <String>[];//favEventIds;
    if (!current.contains(value)) {
      return;
      // throw new Exception("EVENT IS NOT FAVOURITE");
    }

    current.remove(value);
    _sharedPrefs?.setStringList(sp_fav_event_ids, current);
    //reload();
  }

  void removeFavLeague(String value){
    List<String> current =  _sharedPrefs?.getStringList(sp_fav_league_ids) ?? <String>[];//favEventIds;
    if (!current.contains(value)) {
      throw new Exception("LEAGUE IS NOT FAVOURITE");
    }

    current.remove(value);
    _sharedPrefs?.setStringList(sp_fav_league_ids, current);
    //reload();
  }

  getByKey(String key){
    return _sharedPrefs?.getString(key) ?? Constants.empty;
  }

  getListByKey(String key){
    return _sharedPrefs?.getStringList(key) ?? <String>[];
  }

  Future<bool> isFavEvent(String eventId) async{
    await _sharedPrefs?.reload();
    List<String> current =  _sharedPrefs?.getStringList(sp_fav_event_ids) ?? <String>[];//favEventIds;
    if (!current.contains(eventId)) {
      return false;
    }

    return true;
  }

}

final sharedPrefs = SharedPrefs();

const String sp_fav_event_ids = "fav_event_ids";
const String sp_fav_league_ids = "fav_league_ids";