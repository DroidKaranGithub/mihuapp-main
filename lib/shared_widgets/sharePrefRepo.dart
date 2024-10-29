
import 'package:shared_preferences/shared_preferences.dart';

class SharePref {

  static setDeviceToken(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("device_token", value);

  }

  static Future<String?> getDeviceToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("device_token");
  }

  ///UserId Get And Set.....>
  static setUserId(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user_id", value);
  }

  static Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_id");
  }
  ///<.....
  static setEmailId(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email_id", value);
  }

  static Future<String?> getEmailId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("email_id");
  }

  ///ProfileStep Get And Set.....>
  static setProfileStep(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("profile_step", value);
  }

  static Future<String?> getProfileStep() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("profile_step");
  }
  ///<.....


  ///UserRole Get And Set.....>
  static setUserRoleType(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user_role_type", value);
  }

  static Future<String?> getUserRoleType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_role_type");
  }
  ///<.....

  ///UserVerified Get And Set.....>
  static setUserVerified(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user_verified_from", value);
  }

  static Future<String?> getUserVerified() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_verified_from");
  }
  ///<.....

  ///userMobile Get And Set.....>
  static setUserMobile(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user_mobile", value);
  }

  static Future<String?> getUserMobile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_mobile");
  }
  ///<.....




  ///------------------------>

  static setJwtToken(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("jwt_token", value);
  }

  static Future<String?> getJwtToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token");

  }

///------------------------>

}