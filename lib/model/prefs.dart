import 'package:shared_preferences/shared_preferences.dart';

class CheckIfHasGrant {
  static var hasGranted = false;
  static SharedPreferences? preferences;

  static Future<bool> checkIfHasGrant() async {
    if (hasGranted) return hasGranted;
    preferences = await SharedPreferences.getInstance();
    var date = preferences?.getString("date");
    var currentDateTime = DateTime.now().toString().split(" ")[0];
    if (date == currentDateTime) return hasGranted = true;

    return hasGranted = false;
  }

  static setGrant() {
    if (!hasGranted) {
      preferences?.setString("date", DateTime.now().toString().split(" ")[0]);
    }
  }
}
