import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workoutnote/data/models/EditableLiftModel.dart';
import 'package:workoutnote/data/models/ExerciseModel.dart';
import 'package:workoutnote/data/models/WorkoutListModel.dart';
import 'package:workoutnote/data/services/Network.dart';

import 'package:workoutnote/utils/Strings.dart';
import 'package:workoutnote/utils/Utils.dart';

import 'ConfigProvider.dart';
import 'ExerciseDialogProvider.dart';

class CreateWorkoutProvider extends ChangeNotifier {
  //region vars
  TextEditingController titleContoller = TextEditingController();
  String secs = '00';
  String mins = '00';
  String hrs = '00';
  StreamSubscription? timerSubscription;

  List<EditableLift> _lifts = [];
  EditableLift? _unselectedExercise = EditableLift();
  int duration = 0;
  bool appRefreshed = false;
  bool ticksRefreshed = false;
  bool timeRefreshed = false;

  //endregion
  //region api calls
  Future<void> createWorkOutSession(String sessionKey, String title, int timestamp, List<WorkOut> workOuts, List<WorkOut> calendarWorkouts, ConfigProvider configProvider, BuildContext context) async {
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
        var response = await WebServices.insertWorkOut(sessionKey, title, timestamp, duration);
        if (response.statusCode == 200 && jsonDecode(response.body)['success']) {
          _unselectedExercise = EditableLift.create(_unselectedExercise?.exerciseName, _unselectedExercise?.exerciseId, _unselectedExercise?.bodyPart, 1, 1, 1.02, false, -1);

          for (int i = 0; i < _lifts.length; i++) {
            if (_lifts[i].isSelected) {
              var insertLift = await WebServices.insertLift(sessionKey, timestamp, _lifts[i].mass, _lifts[i].exerciseId ?? -1, jsonDecode(response.body)['workout_session']['id'], _lifts[i].rep, _lifts[i].rm);
              var lift = Lift.fromJson(jsonDecode(insertLift.body)['lift']);
              if (insertLift.statusCode == 200 && jsonDecode(insertLift.body)['success']) {
                count++;
                lifts.add(Lift.create(lift.liftId, lift.timestamp, lift.oneRepMax, lift.exerciseId, lift.exerciseName, lift.liftMas, lift.repetitions));
              }
            }
          }
          if (count == _lifts.where((element) => element.isSelected == true).length) {
            var workout = WorkOut.fromJson(jsonDecode(response.body)['workout_session']);
            workOuts.add(WorkOut(workout.id, workout.title, workout.timestamp, lifts, workout.duration, false));
            calendarWorkouts.add(WorkOut(workout.id, workout.title, workout.timestamp, lifts, workout.duration, false));
            _lifts.clear();
            titleContoller.text = '';
            stopTimer();
          }
        }
        notifyListeners();
      } catch (e) {
        print(e);
      }
    } else {
      showSnackBar('${noExerciseWarning[configProvider.activeLanguage()]}', context, Colors.red, Colors.white);
      //showToast('${noExerciseWarning[configProvider.activeLanguage()]}');
    }
  }

  //endregion
  //region restore title, lifts, duration  from  shared prefrences

  void restoreAllLifts(ExercisesDialogProvider exercisesDialogProvider) {
    if (!appRefreshed) {
      appRefreshed = true;
      if (userPreferences!.getString('title') != null) titleContoller.text = userPreferences!.getString('title') ?? '';
      if (userPreferences!.getString('lifts') != null) {
        List<EditableLift> lifts = EditableLift.decode(userPreferences!.getString('lifts') ?? '');
        for (int i = 0; i < lifts.length; i++) {
          _lifts.add(lifts[i]);
        }
      }
      if (userPreferences!.getInt('unselected_ex_id') != null) {
        int? id = userPreferences!.getInt('unselected_ex_id');
        Exercise exercise = exercisesDialogProvider.allExercises.where((element) => element.id == id).single;
        _unselectedExercise = EditableLift.create(exercise.name, exercise.id, exercise.bodyPart, 1, 1, 1.02, false, -1);
      }
    }
  }

  void restoreTimer() {
    if (!timeRefreshed && userPreferences!.getInt('time') != null) {
      timeRefreshed = true;
      hrs = ((userPreferences!.getInt('time')! / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
      mins = ((userPreferences!.getInt('time')! / 60) % 60).floor().toString().padLeft(2, '0');
      secs = (userPreferences!.getInt('time')! % 60).floor().toString().padLeft(2, '0');
    }
  }

  //endregion
  //region getters/setters
  set unselectedExercise(EditableLift? value) {
    _unselectedExercise = value;
    notifyListeners();
  }

  List<EditableLift> get selectedLifts => _lifts;

  EditableLift? get unselectedExercise => _unselectedExercise;

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
    if (userPreferences!.getInt('time') != null && !ticksRefreshed) {
      counter = userPreferences!.getInt('time')!;
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
        hrs = '00';
        mins = '00';
        secs = '00';
        timerSubscription = null;
        notifyListeners();
      });
    else {
      timerSubscription = null;
      hrs = '00';
      mins = '00';
      secs = '00';
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
  void updateActiveExerciseMass(int index, int val) {
    _lifts[index].mass = val;
    updateRM(val, _lifts[index].rep, index);
    notifyListeners();
  }

  void updateInactiveExerciseMass(int val) {
    _unselectedExercise?.mass = val;
    updateInactiveExerciseRM(val, _unselectedExercise?.rep ?? 1);
    notifyListeners();
  }

  void updateInactiveExerciseRep(int val) {
    _unselectedExercise?.rep = val;
    updateInactiveExerciseRM(_unselectedExercise?.rep ?? 1, val);
    notifyListeners();
  }

  void updateInactiveExerciseRM(int mass, int rep) {
    _unselectedExercise?.rm = roundDouble((mass + mass * rep * 0.025), 2);
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
    await userPreferences!.setString('lifts', EditableLift.encode(_lifts));
  }

  Future<void> clearPreferences() async {
    await userPreferences!.setString('lifts', EditableLift.encode([]));
  }

  Future<void> saveTitleToSharedPreference(String title) async {
    await userPreferences!.setString('title', title);
  }

  Future<void> saveTimeToSharedPreference(int time) async {
    await userPreferences!.setInt('time', time);
  }

  Future<void> saveUnselectedExerciseToPreferences() async {
    int? exerciseId = unselectedExercise?.exerciseId;
    await userPreferences!.setInt('unselected_ex_id', exerciseId ?? -1);
  }

  void reorderList(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final items = _lifts.removeAt(oldIndex);
    _lifts.insert(newIndex, items);
    notifyListeners();
  }

  //endregion
  //region utils
  void reset() {
    titleContoller.clear();
    secs = '00';
    mins = '00';
    hrs = '00';
    if (timerSubscription != null) timerSubscription!.cancel();
    timerSubscription = null;
    _lifts.clear();
    timerSubscription = null;
    _unselectedExercise = null;
    duration = 0;
    appRefreshed = false;
    ticksRefreshed = false;
    timeRefreshed = false;
  }

  String? getExerciseName(ExercisesDialogProvider exercisesDialogProvider, ConfigProvider configProvider, int exerciseId) {
    //TODO: calling it after completing network request

   if(exercisesDialogProvider.allExercises.isNotEmpty) {

     Exercise exercise = exercisesDialogProvider.allExercises.where((element) => element.id == exerciseId).first;
     if (configProvider.activeLanguage() == korean)
       return '${exercise.name}(${exercise.bodyPart})';
     else {
       NameTranslation? namedTranslation = exercise.namedTranslations;
       if (namedTranslation?.english != null) {
         return '${namedTranslation?.english}(${exercise.bodyPart})';
       }
       return '${exercise.name}(${exercise.bodyPart})';
     }
   }
   return configProvider.activeLanguage() == english? 'Loading...':'로드 중...';
  }

  Future<void> repeatWorkoutSession(List<EditableLift> lifts, String title) async {
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
