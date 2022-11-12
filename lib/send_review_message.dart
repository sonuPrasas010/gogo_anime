// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:new_yts_movie_downloader/utitlity.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';

// class SendReviewMessage {
//   late SharedPreferences _prefs;

//   void checkIfIsFirstTime() async {
//     _prefs = await SharedPreferences.getInstance();
//     var firstOpenedDate = _prefs.getString("first_opened_date");
//     var hasAlreadyRated = _prefs.getBool("has_already_rated") ?? false;
//     if (firstOpenedDate == null) {
//       await _prefs.setString("first_opened_date", DateTime.now().toString());
//       return;
//     }
//     if (DateTime.now().difference(DateTime.parse(firstOpenedDate)).inDays < 3 ||
//         hasAlreadyRated) {
//       return;
//     }

//     showDialog(())AlertDialog(
//       content: const Text(
//           "Are you enjoying our app? Would you like to rate us on playstore?"),
//       actions: [
//         TextButton(
//           child: const Text("not now"),
//           onPressed: () {
//             Get.back();
//           },
//         ),
//         TextButton(
//           child: const Text("never"),
//           onPressed: () {
//             _prefs.setBool("has_already_rated", true);
//             Get.back();
//           },
//         ),
//         TextButton(
//           child: const Text("rate now"),
//           onPressed: () async {
//             if (await launchUrl(Uri.parse(
//                 "https://play.google.com/store/apps/details?id=com.godevs.yts_movie_downloader"))) {
//               await _prefs.setBool("has_already_rated", true);
//               Get.back();
//             }
//           },
//         ),
//       ],
//     ));
//   }
// }
