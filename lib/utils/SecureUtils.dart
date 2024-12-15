// import 'package:encrypt/encrypt.dart';
//
// import '../examples/util/encryption.dart';
//
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureUtils{
//
//   String base_64_key  = "6C6E6576579D38B2C3DAC435ECB78377165D8DCD01CF7AFD69D1FCB313682450";
//
//   String encodeAES(toEncode){
//     Encrypted encrypted = encryptWithAES(base_64_key, toEncode);
//     return encrypted.base64;
//   }
//




  static Future<String> getDeviceIdentifier() async {
    String deviceIdentifier = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (kIsWeb) {
      final WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
      deviceIdentifier = webInfo.vendor! +
          webInfo.userAgent! +
          webInfo.hardwareConcurrency.toString();
    } else {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceIdentifier = androidInfo.id;
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceIdentifier = iosInfo.identifierForVendor!;
      } else if (Platform.isLinux) {
        final LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
        deviceIdentifier = linuxInfo.machineId!;
      }
    }

    return deviceIdentifier;
  }

  Future<void> storeValue(String key, String value) async {
    await const FlutterSecureStorage().write(key: key, value: value);
  }

  Future<String?> retrieveValue(String key) async {
    String? value = await const FlutterSecureStorage().read(key: key);
    return value;
  }

  void deleteValue(String accessToken) {
     const FlutterSecureStorage().delete(key: accessToken);

  }


}