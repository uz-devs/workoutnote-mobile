//api  urls
import 'dart:async';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = "workoutnote.com";
const String login = "api/login/";
const String fetch_workouts = "api/fetch_workouts/";
const String  fetch_exercises = "api/fetch_exercises/";
const String insert_workout = "/api/insert_workout";
const String insert_lift = "/api/insert_lift";
const String fetch_settings = "/api/fetch_settings";
const String update_settings = "/api/update_settings";

//network  state codes
const int LOADING = 0;
const int TIMEOUT_EXCEPTION = 1;
const int SOCKET_EXCEPTION = 2;
const int MISC_EXCEPTION = 3;
const int  SUCCESS = 4;

//util  methods
SharedPreferences? userPreferences;

Future<void> initPreferences() async {
  userPreferences = await SharedPreferences.getInstance();
}

String toDate(int timestamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var formattedDate = DateFormat('yyyy.mm.dd').format(date);

  return formattedDate;
}

Stream<int> stopWatchStream() {
  StreamController<int>? streamController;
  Timer? timer;
  Duration timerInterval = Duration(seconds: 1);
  int counter = 0;

  void tick(_) {
    counter++;
    streamController!.add(counter);
  }
  void stopTimer() {
    if (timer != null) {
      timer!.cancel();
      timer = null;
      counter = 0;
      streamController!.close();
    }
  }

  void pauseTimer(){
     if(timer !=null){
       timer!.cancel();
     }
  }

  void startTimer() {
    timer = Timer.periodic(timerInterval, tick);
  }


  streamController = StreamController<int>(
    onListen: startTimer,
    onCancel: stopTimer,
    onResume: startTimer,
    onPause: pauseTimer,
  );

  return streamController.stream;
}




