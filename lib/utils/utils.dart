//api  urls
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl= "workoutnote.com";
const String login= "api/login/";
const String workouts = "api/fetch_workouts/";

SharedPreferences? userPreferences;

Future<void> initPreferences() async {
  userPreferences = await SharedPreferences.getInstance();
}