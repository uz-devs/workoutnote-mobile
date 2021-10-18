
import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import 'package:workoutnote/data/models/LanguageModel.dart';
import 'package:workoutnote/utils/Strings.dart';


//region  api  urls
const String baseUrl = 'workoutnote.com';
const String login = 'api/login/';
const String fetch_workouts = 'api/fetch_workouts/';
const String fetch_exercises = 'api/fetch_exercises/';
const String insert_workout = '/api/insert_workout';
const String fetch_settings = '/api/fetch_settings';
const String update_settings = '/api/update_settings';
const String sendVerificationCode = '/api/send_verification_code';
const String verify = '/api/verify_register';
const String fetchBody = '/api/fetch_body_parts';
const String setFavoriteWorkout = '/api/set_favorite_workout';
const String unsetFavoriteWorkout = '/api/unset_favorite_workout';
const String fetchFavoriteWorkouts = '/api/fetch_favorite_workouts';
const String setFavoriteExercise = '/api/set_favorite_exercise';
const String unsetFavoriteExercise = '/api/unset_favorite_exercise';
const String fetchFavoriteExercise = '/api/fetch_favorite_exercises';
const String passwordReset = '/api/request_password_reset';
const String updateWorkout = '/api/update_workout';
const String removeWorkOut = '/api/remove_workout';
const String updateLift = 'api/update_lift';
const String insert_lift = '/api/insert_lift';
const String deleteLift = '/api/remove_lift';
const String setNote = '/api/set_note';
const String fetchNote = '/api/fetch_note';
const String targetReg = '/api/insert_target';
const  String  targetFetch = '/api/fetch_targets';
const  String targetDel = '/api/remove_target';
const  String targetToggle = '/api/toggle_target';
const String privacyPolicyUrl = 'https://workoutnote.com/policy/';
const  String  updateTarget  = 'api/update_target';
const  String checkUserEmail = 'api/check_username';
//endregion

//region network  states
const int LOADING = 0;
const int IDLE = 1;
const int SOCKET_EXCEPTION = 2;
const int MISC_EXCEPTION = 3;
const int SUCCESS = 4;

//endregion

SharedPreferences? userPreferences, appPreferences;
List<Language> lList = [Language(english, 1), Language(korean, 2)];
const int KG = 1, LBS = -1;
const int EXERCISE_EDIT_MODE = 1;
const int EXERCISE_CREATE_MODE = 0;


//region utils functions
Future<void> initPreferences() async {
  userPreferences = await SharedPreferences.getInstance();
  appPreferences = await SharedPreferences.getInstance();
}

String toDate(int timestamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var formattedDate = DateFormat('yyyy.M.d').format(date);

  return formattedDate;
}
String toDate2(int timestamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var formattedDate = DateFormat('yyyy.MM.dd').format(date);

  return formattedDate;
}
void showToast(String message) {
  Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.black54, textColor: Colors.white, fontSize: 16.0);
}

void showSnackBar(String message, BuildContext context, Color backgroundColor, Color textColor) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: backgroundColor,
    content: Text(
      message,
      style: TextStyle(color: textColor),
    ),
    duration: Duration(milliseconds: 1000),
  ));
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        //CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7), child: Text('Loading...')),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Tuple3<String, String, String> calculateDuration(int duration) {
  String hrs, mins, secs;
  if (duration < 60) {
    secs = duration.toString();
    if (duration < 10) secs = '0' + secs;
    mins = '00';
    hrs = '00';
  } else if (duration >= 60 && duration < 3600) {
    secs = (duration % 60).toString();
    mins = (duration ~/ 60).toString();
    if (duration ~/ 60 < 10) mins = '0' + mins;
    hrs = '00';
  } else {
    hrs = (duration ~/ 3600).toString();

    if (duration ~/ 3600 < 10) hrs = '0' + hrs;
    int temp = duration - 3600;
    mins = (temp ~/ 60).toString();
    secs = (temp % 60).toString();
  }

  return Tuple3(hrs, mins, secs);
}

double roundDouble(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

void showLoadingDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Container(
      child: Center(
        child: CircularProgressIndicator(color: Color.fromRGBO(102, 51, 204, 1)),
      ),
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

String trimStringField(String value) => value.trim();

Future<bool> isInternetConnected()  async{

  var connectivity =  await Connectivity().checkConnectivity();

  if(connectivity == ConnectivityResult.wifi || connectivity == ConnectivityResult.mobile)
    return  true;
  else return  false;


}
List<String>? years_en = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
List<String>? years_kr = ['1 월', '2 월', '3 월', '4 월', '5 월', '6 월', '7 월', '8 월', '9 월', '10 월', '11 월', '12 월'];
//endregion