//api  urls
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = "workoutnote.com";
const String login = "api/login/";
const String workouts = "api/fetch_workouts/";
const String  exerc = "api/fetch_exercises/";

SharedPreferences? userPreferences;

Future<void> initPreferences() async {
  userPreferences = await SharedPreferences.getInstance();
}

String toDate(int timestamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var formattedDate = DateFormat('yyyy.mm.dd').format(date);

  return formattedDate;
}
