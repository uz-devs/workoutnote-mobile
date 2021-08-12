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
  //vars
  TextEditingController titleContoller = TextEditingController();
  String secs = "00";
  String mins = "00";
  String hrs = "00";
  StreamSubscription? timerSubscription;

  List<EditableLift> _selectedLifts = [];
  EditableLift? _unselectedLift = EditableLift();
  Exercise? _unselectedExercise;
  int duration = 0;
  bool appRefereshed = false;
  bool ticksReefrshed = false;
  bool timeRefreshed = false;

  //api calls
  Future<void> createWorkOutSession(String sessionKey, String title,
      int timestamp, List<WorkOut> workOuts, Function updateHome) async {
    bool canCreateSession = false;
    for (int i = 0; i < _selectedLifts.length; i++) {
      if (_selectedLifts[i].isSelected) {
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
          for (int i = 0; i < _selectedLifts.length; i++) {
            var insertLift = await WebServices.insertLift(
                sessionKey,
                timestamp,
                _selectedLifts[i].mass,
                _selectedLifts[i].exerciseId ?? -1,
                jsonDecode(response.body)["workout_session"]["id"]);
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
          if (count == _selectedLifts.length) {
            var workout =
                WorkOut.fromJson(jsonDecode(response.body)["workout_session"]);
            workOuts.add(WorkOut(workout.id, workout.title, workout.timestamp,
                lifts, workout.duration, false));
            updateHome();
            _selectedLifts.removeWhere((element) => element.isSelected);
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

  //utils
  set unselectedExercise(Exercise? value) {
    _unselectedExercise = value;
    notifyListeners();
  }

  void firstEnterApp() {
    appRefereshed = true;
    if (userPreferences!.getString("title") != null)
      titleContoller.text = userPreferences!.getString("title") ?? "";
    print(titleContoller.text);
    if (userPreferences!.getString("lifts") != null) {
      List<EditableLift> lifts =
          EditableLift.decode(userPreferences!.getString("lifts") ?? "");
      for (int i = 0; i < lifts.length; i++) {
        _selectedLifts.add(lifts[i]);
        print(selectedLifts[i].exerciseName);
      }
    }
  }

  List<EditableLift> get selectedLifts => _selectedLifts;
  Exercise? get unselectedExercise => _unselectedExercise;
  set unselectedLift(EditableLift? value) {
    _unselectedLift = value;
    notifyListeners();
  }

  void updateExercise(int index) {
    if (_selectedLifts[index].isSelected == false)
      _selectedLifts[index].isSelected = true;
    else
      _selectedLifts[index].isSelected = false;

    notifyListeners();
  }

  void removeExercises() {
    _selectedLifts.removeWhere((element) => element.isSelected);
    notifyListeners();
  }

  Future<void> startTimer() async {
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
    if (userPreferences!.getInt("time") != null && !ticksReefrshed) {
      counter = userPreferences!.getInt("time")!;
      ticksReefrshed = true;
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
  }

  void pauseTimer() {
    timerSubscription!.pause();
    notifyListeners();
  }

  void resumeTimer() {
    timerSubscription!.resume();
    notifyListeners();
  }

  void updateMass(int index, int val) {
    _selectedLifts[index].mass = val;
    updateRM(val, _selectedLifts[index].rep, index);
    notifyListeners();
  }

  void updateRep(index, int val) {
    _selectedLifts[index].rep = val;
    updateRM(_selectedLifts[index].mass, val, index);
    notifyListeners();
  }

  void updateRM(int mass, int rep, index) {
    _selectedLifts[index].rm = mass + mass * rep * 0.025;
  }

  Future<void> saveListToSharePreference() async {
    await userPreferences!
        .setString("lifts", EditableLift.encode(_selectedLifts));
  }

  Future<void> saveTitleToSharedPreference(String title) async {
    await userPreferences!.setString("title", title);
  }

  Future<void> saveTimeToSharedPreference(int time) async {
    await userPreferences!.setInt("time", time);
  }

  void addExercise(EditableLift exercise) {
    _selectedLifts.add(exercise);
    notifyListeners();
  }

  EditableLift? get unselectedLift => _unselectedLift;

  void reset() {
    titleContoller.clear();
    secs = "00";
    mins = "00";
    hrs = "00";
    if (timerSubscription != null) timerSubscription!.cancel();
    _selectedLifts.clear();
    unselectedLift = EditableLift();
    _unselectedExercise = null;
    duration = 0;
    appRefereshed = false;
    ticksReefrshed = false;
    timeRefreshed = false;
  }
}
