class UrlConstants{

  //static const SERVER_IP_PLAIN = "liakos86-32935.portmap.host";

  static const SERVER_IP_PLAIN = "192.168.1.3";
  // static const SERVER_IP_PLAIN = "192.168.1.53";

  static const SRV_VERSION = "betCoreServer";

  static const SERVER_IP = "http://" + SERVER_IP_PLAIN + ":8080/";//'http://192.168.43.17:8080/';  // for mobile hotspot

  static const String GET_LEAGUE_EVENTS = SERVER_IP +  SRV_VERSION + '/betServer/getLeagueEvents';
  static const String GET_LIVE_EVENTS = SERVER_IP +  SRV_VERSION + '/betServer/getLiveEvents';
  static const String GET_LEAGUES = SERVER_IP +  SRV_VERSION + '/betServer/getLeagues';
  static const String GET_SECTIONS = SERVER_IP +  SRV_VERSION + '/betServer/getSections';

  static const String GET_STANDINGS_WITHOUT_TABLES = SERVER_IP +  SRV_VERSION + '/betServer/getStandingsAllWithoutTables';

  static const String GET_SEASON_STANDINGS = SERVER_IP +  SRV_VERSION + '/betServer/getStandingsOfSeason/{1}/{2}';

  static const String GET_SPECIFIC_LIVE = SERVER_IP +  SRV_VERSION + '/betServer/getLiveSpecific';

  static const String GET_LEADERS_URL = SERVER_IP + SRV_VERSION + '/betServer/getLeaderBoard';

  static const POST_PLACE_BET = SERVER_IP + SRV_VERSION + '/betServer/placeBet';

  static const GET_USER_URL = SERVER_IP + SRV_VERSION + '/betServer/getUser/';
  static const GET_EVENT_STATISTICS_URL = SERVER_IP + SRV_VERSION + '/betServer/getEventStatistics/';

  static const POST_REGISTER_USER = SERVER_IP + SRV_VERSION + '/betServer/registerUser';

  static const POST_LOGIN_USER = SERVER_IP + SRV_VERSION + '/betServer/loginUser';

  static const URL_ENC = "mF=!72kg*&;.J^1]";

}