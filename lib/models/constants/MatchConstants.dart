import '../../utils/DateUtils.dart';

class MatchConstants{

   static const String MATCH_START_TIME_FORMAT = "yyyy-MM-dd HH:mm:ss";

   static const String GMT = "GMT";

   static  String KEY_TODAY = DateUtils.formattedDateWithOffset(0);// '0';
   static  String KEY_TOMORROW = DateUtils.formattedDateWithOffset(1);
   static  String KEY_YESTERDAY = DateUtils.formattedDateWithOffset(-1);

}