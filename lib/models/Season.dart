import 'Standing.dart';
import 'constants/JsonConstants.dart';
import 'League.dart';

class Season{

  League leagueInfo = League.defConst();


  Season.defSeason();

  int id=-1;
  int year_start=0;
  int year_end =0;
  // int ?league_id;
  // String ?slug;
  // String ?name;

  Standing standing = Standing.defStanding();

  Season({
    required this.id,
    required this.leagueInfo,
    required this.year_start,
    required this.year_end,
    required this.standing
  });

  static seasonFromJson(seasonJson) {
//id league_id league standingTable

    League li = League.fromJson(seasonJson['league']);

    Standing st = Standing.standingFromJson(seasonJson['standingTable']);

    Season s = Season(id: seasonJson['id'], year_start: 2022, year_end: 2023, standing: st, leagueInfo: li);
    return s;

  }

  static void copyFields(Season seasonNew, Season season) {
    season.id = seasonNew.id;
    season.standing.standingRows.clear();
    season.standing.standingRows.addAll(seasonNew.standing.standingRows);
    season.leagueInfo.seasonIds.clear();
    season.leagueInfo.name = seasonNew.leagueInfo.name;
    season.leagueInfo.league_id = seasonNew.leagueInfo.league_id;
    season.leagueInfo.has_logo = seasonNew.leagueInfo.has_logo;
    season.leagueInfo.logo = seasonNew.leagueInfo.logo;
    season.leagueInfo.seasonIds.addAll(seasonNew.leagueInfo.seasonIds);
    season.leagueInfo.translations = seasonNew.leagueInfo.translations;
    // season.leagueInfo.translations?.addAll(seasonNew.leagueInfo.translations?);
  }

}