 import 'package:flutter_app/enums/MatchEventStatusMore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../enums/MatchEventStatus.dart';
import '../enums/WinnerType.dart';
import '../models/UserPrediction.dart';
 import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/match_event.dart';
 import 'package:http/http.dart' as http;
 import 'dart:io';
 import 'package:path_provider/path_provider.dart';

class ImageUtils{


  static Future<String> downloadAndSaveFile(String url, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final response = await http.get(Uri.parse(url));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  // static getNotificationIcon(logo) {
  //   final BigPictureStyleInformation bigPictureStyle = BigPictureStyleInformation(
  //     FilePathAndroidBitmap(logo),
  //     contentTitle: 'Team ' + logo,
  //     summaryText: 'summary logo ' + logo,
  //   );
  //
  //   return bigPictureStyle;
  // }

}