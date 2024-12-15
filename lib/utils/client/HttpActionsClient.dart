// import 'package:flutter_app/models/constants/UrlConstants.dart';
// import 'package:http/http.dart';
// import 'dart:async';
//
// import '../../models/constants/Constants.dart';
// import '../SecureUtils.dart';
//
//
//
// class HttpActionsClient {
//
//   String? access_token;
//
//   Future<void> loginUser() async{
//     try {
//
//       if (access_token == null) {
//         access_token = await SecureUtils().retrieveValue(
//             Constants.accessToken);
//         await authorizeAsync();
//         if (access_token == null) {
//           print('login COULD NOT AUTHORIZE ********************************************************************');
//           return;
//         }
//       }
//
//       Response loginResponse = await post(Uri.parse(UrlConstants.POST_LOGIN_USER),
//           headers: {
//             "Accept": "application/json",
//             "Content-Type": "application/json",
//             'Authorization': 'Bearer $access_token'
//           },
//           body: jsonEncode(toJson(emailOrUsername, password)),
//           encoding: Encoding.getByName("utf-8")).timeout(
//           const Duration(seconds: 5));
//
//       var responseDec = jsonDecode(loginResponse.body);
//       User userFromServer = User.fromJson(responseDec);
//
//       callback.call(userFromServer);
//
//     }catch(e){
//
//       setState(() {
//         errorMsg = 'Login failed server error';
//       });
//
//       print(e);
//     }
//   }
//
// }
