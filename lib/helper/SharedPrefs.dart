import 'package:flutter_app/models/constants/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;
  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  void reload(){
    _sharedPrefs?.reload();
  }

  void appendEventId(String value){
    List<String> current = favEventIds;
    if (current.contains(value)) {
      throw new Exception("EVENT ALREADY IS FAVOURITE");
    }

    current.add(value);
    _sharedPrefs?.setStringList(sp_fav_event_ids, current);
    reload();

  }

  List<String> get favEventIds => _sharedPrefs?.getStringList(sp_fav_event_ids) ?? <String>[];

  remove(String key){
    _sharedPrefs?.remove(key);
  }

  removeFavEvent(String value){
    List<String> current = favEventIds;
    if (!current.contains(value)) {
      throw new Exception("EVENT ALREADY IS FAVOURITE");
    }

    current.remove(value);
    _sharedPrefs?.setStringList(sp_fav_event_ids, current);
    reload();
  }

  getByKey(String key){
    return _sharedPrefs?.getString(key) ?? Constants.empty;
  }

}

final sharedPrefs = SharedPrefs();

const String sp_fav_event_ids = "fav_event_ids";