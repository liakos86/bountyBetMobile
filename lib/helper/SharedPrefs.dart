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
      throw Exception("EVENT ALREADY IS FAVOURITE $value");
    }

    current.add(value);
    _sharedPrefs?.setStringList(sp_fav_event_ids, current);
    //reload();

  }

  void appendWonMonth(String value){
    List<String> current =  _sharedPrefs?.getStringList(sp_won_months) ?? <String>[];
    if (current.contains(value)) {
      throw Exception("MONTH ALREADY IS IN WON $value");
    }

    current.add(value);
    _sharedPrefs?.setStringList(sp_won_months, current);
  }

  void appendAckLeagueId(String value){
    List<String> current =  _sharedPrefs?.getStringList(sp_ack_league_ids) ?? <String>[];
    if (current.contains(value)) {
      throw Exception("FLID ALREADY IS IN ACK $value");
    }

    current.add(value);
    _sharedPrefs?.setStringList(sp_ack_league_ids, current);
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

  void ackWalkThrough(){
    _sharedPrefs?.setBool(sp_seen_walk_through, true);
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

  updateFantasyLeagueId(String leagueId){
    return _sharedPrefs?.setString(sp_fantasy_league_id, leagueId);
  }

  getByKey(String key){
    return _sharedPrefs?.getString(key) ?? Constants.empty;
  }

  getListByKey(String key){
    return _sharedPrefs?.getStringList(key) ?? <String>[];
  }

  getBoolByKey(String key){
    return _sharedPrefs?.getBool(key) ?? false;
  }


  Future<bool> isInWonMonths(String monthYear) async{
    await _sharedPrefs?.reload();
    List<String> current =  _sharedPrefs?.getStringList(sp_won_months) ?? <String>[];
    if (!current.contains(monthYear)) {
      return false;
    }

    return true;
  }

  Future<bool> isFantasyLeagueAcknowledged(String id) async{
    await _sharedPrefs?.reload();
    List<String> current =  _sharedPrefs?.getStringList(sp_ack_league_ids) ?? <String>[];
    if (!current.contains(id)) {
      return false;
    }

    return true;
  }

}

final sharedPrefs = SharedPrefs();

const String sp_fav_event_ids = "fav_event_ids";
const String sp_fav_league_ids = "fav_league_ids";
const String sp_won_months = "won_months";
const String sp_ack_league_ids = "ack_league_ids";
const String sp_fantasy_league_id = "fantasy_league_id";
const String sp_seen_walk_through = "seen_walk_through";