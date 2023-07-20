import 'dart:convert';
import '../model/site.dart';
import '../routes.dart';
import '../service/locatorService.dart';
import '../service/navigationService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';

class AuthData{
  static setToken(token) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('AuthToken', token);
  }
  static setDeviceToken(token) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('DeviceToken', token);
  }
  static Future<String?> getToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('AuthToken');
    return token;
  }
  static Future<String?> getDeviceToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('DeviceToken');
    return token;
  }

  static setUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('User', jsonEncode(user));
  }
  static Future<User> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('User');
    User user = User.fromJson(jsonDecode(data!));
    return user;
  }

  static setSite(Site? site) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Site', jsonEncode(site));
  }
  static Future<Site?> getSite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('Site');
    if(data == null){
      return null;
    }
    Site site = Site.fromJson(jsonDecode(data));
    return site;
  }

  static Logout() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("User");
    prefs.remove("AuthToken");
    prefs.remove("Site");
    locator<NavigationService>().pushReplacementNamed(LOGINPAGE);
  }



}