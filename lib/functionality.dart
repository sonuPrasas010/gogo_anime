import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'safari_chrome.dart';

class Functionality {
  static Future<void> launchUniversalLinkIos({
    required String defaultUrl,
  }) async {
    if (await canLaunch(defaultUrl)) {
      await launch(
        defaultUrl,
        forceSafariVC: false,
        universalLinksOnly: true,
        // universalLinksOnly: true,
      );
      // if (!nativeAppLaunchSucceeded) {
      //   await launch(
      //     magnetUrl,
      //     forceSafariVC: true,
      //     forceWebView: true,
      //   );
      // }
    }
  }

  static launchSafariChrome(String url) {
    MyChromeSafariBrowser().open(url: Uri.parse(url));
  }

  static bool checkPosition(double position, double maxScrollExtend) {
    debugPrint(position.toString());
    debugPrint(maxScrollExtend.toString());
    if (position >= maxScrollExtend - 500) {
      debugPrint("object");

      return true;
    }
    return false;
  }
}
