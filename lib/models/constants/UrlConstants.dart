class UrlConstants{

  //static const SERVER_IP_PLAIN = "liakos86-32935.portmap.host";

  // static const SERVER_IP_PLAIN = "192.168.2.2";
  static const SERVER_IP_PLAIN = "192.168.1.6";

  static const SRV_VERSION = "fantasyTips";

  static const SERVER_IP = "http://" + SERVER_IP_PLAIN + ":8080/";//'http://192.168.43.17:8080/';  // for mobile hotspot

  static const String AUTH = SERVER_IP +  SRV_VERSION + '/rest/authorize';
  static const String GET_LEAGUE_EVENTS = SERVER_IP +  SRV_VERSION + '/rest/getLeagueEvents';
  static const String GET_LIVE_EVENTS = SERVER_IP +  SRV_VERSION + '/rest/getLiveEvents';
  static const String GET_LEAGUES = SERVER_IP +  SRV_VERSION + '/rest/getLeagues';
  static const String GET_SECTIONS = SERVER_IP +  SRV_VERSION + '/rest/getSections';

  // static const String GET_STANDINGS_WITHOUT_TABLES = SERVER_IP +  SRV_VERSION + '/rest/getStandingsAllWithoutTables';

  static const String GET_SEASON_STANDINGS = SERVER_IP +  SRV_VERSION + '/rest/getStandingsOfSeason/{1}/{2}';

  // static const String GET_SPECIFIC_LIVE = SERVER_IP +  SRV_VERSION + '/rest/getLiveSpecific';

  static const String GET_LEADERS_URL = SERVER_IP + SRV_VERSION + '/rest/getLeaderBoard';

  static const POST_PLACE_BET = SERVER_IP + SRV_VERSION + '/rest/placeBet';

  static const GET_USER_URL = SERVER_IP + SRV_VERSION + '/rest/getUser/';

  static const GET_EVENT_STATISTICS_URL = SERVER_IP + SRV_VERSION + '/rest/getEventStatistics/';

  static const POST_REGISTER_USER = SERVER_IP + SRV_VERSION + '/rest/registerUser';

  static const POST_LOGIN_USER = SERVER_IP + SRV_VERSION + '/rest/loginUser';

  static const POST_VERIFY_PURCHASE = SERVER_IP + SRV_VERSION + '/rest/verifyPurchase';

  static String LOGO_BASE_URL ="https://xscore.cc/resb/team/";

  static const URL_ENC = "mF=!72kg*&;.J^1]";

}