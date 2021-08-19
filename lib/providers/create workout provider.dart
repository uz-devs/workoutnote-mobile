import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:workoutnote/models/editible%20lift%20model.dart';
import 'package:workoutnote/models/exercises%20model.dart';
import 'package:workoutnote/models/work%20out%20list%20%20model.dart';
import 'package:workoutnote/services/network%20%20service.dart';
import 'package:workoutnote/utils/utils.dart';

class CreateWorkoutProvider extends ChangeNotifier {
  //region vars
  TextEditingController titleContoller = TextEditingController();
  String secs = "00";
  String mins = "00";
  String hrs = "00";
  StreamSubscription? timerSubscription;

  List<EditableLift> _lifts = [];
  EditableLift? _unselectedLift = EditableLift();
  Exercise? _unselectedExercise;
  int duration = 0;
  bool appRefreshed = false;
  bool ticksRefreshed = false;
  bool timeRefreshed = false;
  //endregion


  //region api calls
  Future<void> createWorkOutSession(String sessionKey, String title, int timestamp, List<WorkOut> workOuts, List<WorkOut> calendarWorkouts) async {
    bool canCreateSession = false;
    for (int i = 0; i < _lifts.length; i++) {
      if (_lifts[i].isSelected) {
        canCreateSession = true;
        break;
      }
    }
    if (canCreateSession) {
      try {
        List<Lift> lifts = [];
        int count = 0;
        var response = await WebServices.insertWorkOut(
            sessionKey, title, timestamp, duration);
        if (response.statusCode == 200 &&
            jsonDecode(response.body)["success"]) {
          for (int i = 0; i < _lifts.length; i++) {
            var insertLift = await WebServices.insertLift(
                sessionKey,
                timestamp,
                _lifts[i].mass,
                _lifts[i].exerciseId ?? -1,
                jsonDecode(response.body)["workout_session"]["id"],
                _lifts[i].rep,
                _lifts[i].rm);
            var lift = Lift.fromJson(jsonDecode(insertLift.body)["lift"]);
            print(jsonDecode(insertLift.body)["success"]);
            if (insertLift.statusCode == 200 &&
                jsonDecode(insertLift.body)["success"]) {
              count++;
              lifts.add(Lift.create(
                  lift.liftId,
                  lift.timestamp,
                  lift.oneRepMax,
                  lift.exerciseId,
                  lift.exerciseName,
                  lift.liftMas,
                  lift.repetitions));
            }
          }
          if (count == _lifts.length) {
            var workout =
                WorkOut.fromJson(jsonDecode(response.body)["workout_session"]);
            workOuts.add(WorkOut(workout.id, workout.title, workout.timestamp,
                lifts, workout.duration, false));
            calendarWorkouts.add(WorkOut(workout.id, workout.title,
                workout.timestamp, lifts, workout.duration, false));
            _lifts.removeWhere((element) => element.isSelected);
            stopTimer();
          }
        }
        notifyListeners();
      } catch (e) {
        print(e);
      }
    } else {
      showToast(
          "You need to add at least one exercise for one workout session!");
    }
  }
  //endregion
  //region restore title, lifts, duration  from  shared prefrences
  void restoreAllLifts() {
    if (!appRefreshed) {
      appRefreshed = true;
      if (userPreferences!.getString("title") != null)
        titleContoller.text = userPreferences!.getString("title") ?? "";
      print(titleContoller.text);
      if (userPreferences!.getString("lifts") != null) {
        List<EditableLift> lifts =
            EditableLift.decode(userPreferences!.getString("lifts") ?? "");
        for (int i = 0; i < lifts.length; i++) {
          _lifts.add(lifts[i]);
          print(selectedLifts[i].exerciseName);
        }
      }
    }
  }
  void restoreTimer() {
    if (!timeRefreshed && userPreferences!.getInt("time") != null) {
      timeRefreshed = true;
      hrs = ((userPreferences!.getInt("time")! / (60 * 60)) % 60)
          .floor()
          .toString()
          .padLeft(2, '0');
      mins = ((userPreferences!.getInt("time")! / 60) % 60)
          .floor()
          .toString()
          .padLeft(2, '0');
      secs = (userPreferences!.getInt("time")! % 60)
          .floor()
          .toString()
          .padLeft(2, '0');
    }
  }
  //endregion
  //region getters/setters
  set unselectedExercise(Exercise? value) {
    _unselectedExercise = value;
    notifyListeners();
  }
  List<EditableLift> get selectedLifts => _lifts;

  Exercise? get unselectedExercise => _unselectedExercise;

  EditableLift? get unselectedLift => _unselectedLift;

  set unselectedLift(EditableLift? value) {
    _unselectedLift = value;
    notifyListeners();
  }
  //endregion
  //region lifts: add, update,  remove
  void updateLift(int index) {
    if (_lifts[index].isSelected == false)
      _lifts[index].isSelected = true;
    else
      _lifts[index].isSelected = false;

    notifyListeners();
  }
  void removeLifts() {
    _lifts.removeWhere((element) => element.isSelected);
    notifyListeners();
  }
  void addExercise(EditableLift exercise) {
    _lifts.add(exercise);
    notifyListeners();
  }
  //endregion
  //region stopwatch
  void startTimer() {
    var timerStream = stopWatchStream();
    timerSubscription = timerStream.listen((int newTick) async {
      duration = newTick;
      hrs = ((newTick / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
      mins = ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
      secs = (newTick % 60).floor().toString().padLeft(2, '0');
      await saveTimeToSharedPreference(newTick.toInt());

      notifyListeners();
    });
    notifyListeners();
  }

  Stream<int> stopWatchStream() {
    StreamController<int>? streamController;
    Timer? timer;
    Duration timerInterval = Duration(seconds: 1);

    int counter;
    if (userPreferences!.getInt("time") != null && !ticksRefreshed) {
      counter = userPreferences!.getInt("time")!;
      ticksRefreshed = true;
    } else
      counter = 0;

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

    void pauseTimer() {
      if (timer != null) {
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

  void stopTimer() {
    if (timerSubscription != null)
      timerSubscription!.cancel().then((value) {
        hrs = "00";
        mins = "00";
        secs = "00";
        timerSubscription = null;
        notifyListeners();
      });
    else {
      print("eferfqef");
      timerSubscription = null;
      hrs = "00";
      mins = "00";
      secs = "00";
      saveTimeToSharedPreference(0);
      notifyListeners();
    }
  }

  void pauseTimer() {
    if (timerSubscription != null) timerSubscription!.pause();
    notifyListeners();
  }

  void resumeTimer() {
    timerSubscription!.resume();
    notifyListeners();
  }
  //endregion
  //region  update mass, rep, rm
  void updateMass(int index, int val) {
    _lifts[index].mass = val;
    updateRM(val, _lifts[index].rep, index);
    notifyListeners();
  }

  void updateRep(index, int val) {
    _lifts[index].rep = val;
    updateRM(_lifts[index].mass, val, index);
    notifyListeners();
  }

  void updateRM(int mass, int rep, index) {
    _lifts[index].rm = roundDouble((mass + mass * rep * 0.025), 2);
  }
  //endregion
  //region caching:  Lifts, Title, Duration
  Future<void> saveListToSharePreference() async {
    await userPreferences!
        .setString("lifts", EditableLift.encode(_lifts));
  }

  Future<void> saveTitleToSharedPreference(String title) async {
    await userPreferences!.setString("title", title);
  }

  Future<void> saveTimeToSharedPreference(int time) async {
    await userPreferences!.setInt("time", time);
  }
  //endregion
  //region utils
  void reset() {
    print("creaet");
    titleContoller.clear();
    secs = "00";
    mins = "00";
    hrs = "00";
    if (timerSubscription != null) timerSubscription!.cancel();
    timerSubscription = null;
    _lifts.clear();
    timerSubscription = null;
    unselectedLift = EditableLift();
    _unselectedExercise = null;
    duration = 0;
    appRefreshed = false;
    ticksRefreshed = false;
    timeRefreshed = false;
  }
  void repeatWorkoutSession(List<EditableLift> lifts, String title) async {
    _lifts.clear();
    _lifts.addAll(lifts);
    titleContoller.text = title;
    await saveListToSharePreference();
    await saveTimeToSharedPreference(0);
    await saveTitleToSharedPreference(title);

    stopTimer();
  }
  //endregion

}
