//api  urls
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl= "workoutnote.com";
const String login= "api/login/";

SharedPreferences? userPreferences;

Future<void> initPreferences() async {
  userPreferences = await SharedPreferences.getInstance();
}