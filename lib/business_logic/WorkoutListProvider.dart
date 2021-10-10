import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:workoutnote/data/models/EditableLiftModel.dart';
import 'package:workoutnote/data/models/ExerciseModel.dart';
import 'package:workoutnote/data/models/WorkoutListModel.dart';
import 'package:workoutnote/data/services/Network.dart';


import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

import 'ConfigProvider.dart';
import 'CreateWorkoutProvider.dart';

class MainScreenProvider extends ChangeNotifier {
  //vars
  List<WorkOut> workOuts = [];
  List<WorkOut> calendarWorkouts = [];
  List<WorkOut> favoriteWorkOuts = [];
  List<Map<String, String>> notes = [];
  bool todayWorkoutsFetched = false;
  bool favoriteWorkoutsFetched = false;
  bool calendarWorkoutsFetched = false;



  List<String> workOutDates = [];
  DateTime? selectedDate = DateTime.now();
  var currentMonthIndex = DateTime.now().month - 1;
  var noteController = TextEditingController();


  int responseCode = IDLE;


  // api calls
  Future<bool> fetchTodayWorkouts() async {
    try {
      var sessionKey = userPreferences!.getString('sessionKey') ?? '';
      var fromTimeStamp = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).millisecondsSinceEpoch;
      var tillTimeStamp = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1).millisecondsSinceEpoch - 1;
      var response = await WebServices.fetchWorkOuts(sessionKey, fromTimeStamp, tillTimeStamp);
      print(jsonDecode(utf8.decode(response.bodyBytes)));



      if (response.statusCode == 200) {
        var workoutsResponse = WorkOutsResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

        if (workoutsResponse.success) {
          workOuts.addAll(workoutsResponse.workouts);
          todayWorkoutsFetched = true;
          responseCode = SUCCESS;
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> fetchCalendarWorkoutSessions() async {
    if (calendarWorkouts.isNotEmpty) calendarWorkouts.clear();
    try {
      var sessionKey = userPreferences!.getString('sessionKey') ?? '';
      var fromTimestamp = 0;
      var tillTimestamp = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1).millisecondsSinceEpoch - 1;
      var response = await WebServices.fetchWorkOuts(sessionKey, fromTimestamp, tillTimestamp);

      if (response.statusCode == 200) {
        var workoutsResponse = WorkOutsResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
        if (workoutsResponse.success) {
          calendarWorkouts.addAll(workoutsResponse.workouts);
          updateWorkoutDates(calendarWorkouts);
          calendarWorkoutsFetched = true;
        }
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> fetchFavoriteWorkoutSessions(String sessionKey) async {
    try {
      var response = await WebServices.fetchFavoriteWorkoutSessions(sessionKey);

      if (response.statusCode == 200 && jsonDecode(response.body)['success']) {
        var workoutsResponse = WorkOutsResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

        for (int i = 0; i < workoutsResponse.workouts.length; i++) {
          print(workoutsResponse.workouts[i].title);



        }
        favoriteWorkOuts.addAll(workoutsResponse.workouts);
        for (int i = 0; i < favoriteWorkOuts.length; i++) {
          favoriteWorkOuts[i].isFavorite = true;
        }
        favoriteWorkoutsFetched = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> setFavoriteWorkOut(String sessionKey, int workoutId, int mode) async {
    try {
      var response = await WebServices.setFavoriteWorkOut(sessionKey, workoutId);

      if (response.statusCode == 200 && jsonDecode(response.body)['success']) {
        _updateWorkoutFavoriteStatus(workoutId, mode);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> unsetFavoriteWorkOut(String sessionKey, int workoutId, int mode) async {
    try {
      var response = await WebServices.unsetFavoriteWorkOut(sessionKey, workoutId);

      if (response.statusCode == 200 && jsonDecode(response.body)['success']) {
        _updateWorkoutFavoriteStatus(workoutId, mode);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> deleteWorkoutSession(String sessionKey, int id) async {
    try {
      var response = await WebServices.removeWorkout(sessionKey, id);

      if (response.statusCode == 200 && jsonDecode(response.body)['success']) {

        for (int i = 0; i<calendarWorkouts.length; i++){
            if(calendarWorkouts[i].id == id){
              calendarWorkouts.removeAt(i);
            }
        }
        for (int  i = 0; i<workOuts.length; i++){
          if(workOuts[i].id == id){
            workOuts.removeAt(i);
          }
        }
        for(int i = 0; i<favoriteWorkOuts.length; i++){
          if(favoriteWorkOuts[i].id == id){
            favoriteWorkOuts.removeAt(i);
          }
        }

        notifyListeners();
        return true;
      }
      return false;
    }
    catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> fetchSingleNote(int timestamp) async {
    var sessionKey = userPreferences!.getString('sessionKey') ?? '';
    try {
      var response = await WebServices.fetchCalendarNote(sessionKey, timestamp);

      if (response.statusCode == 200) {
        String currentNote = jsonDecode(utf8.decode(response.bodyBytes))['note'];
        noteController.text = currentNote;


        print('Noooooteee: ${noteController.text}');
        notifyListeners();
        }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> saveNote(int timestamp, String note) async {
    print('timestamp: ${timestamp}');
    var sessionKey = userPreferences!.getString('sessionKey') ?? '';

    try {
      var response = await WebServices.saveCalendarNote(sessionKey, timestamp, note);
      print(response.body);
      if (response.statusCode == 200) {
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }


  //utils
  Future<void> repeatWorkoutSession(int id, CreateWorkoutProvider createWorkoutProvider, List<Exercise> exercises, int mode) async {
    List<EditableLift> lifts = [];
    String? title;

    if (calendarWorkouts.isNotEmpty) {
      for (int i = 0; i < calendarWorkouts.length; i++) {
        if (calendarWorkouts[i].id == id) {
          for (int j = 0; j < calendarWorkouts[i].lifts!.length; j++) {
            title = calendarWorkouts[i].title ?? '';
            lifts.add(EditableLift.create(calendarWorkouts[i].lifts![j].exerciseName, calendarWorkouts[i].lifts![j].exerciseId, exercises.isNotEmpty ? exercises.where((element) => element.id == calendarWorkouts[i].lifts![j].exerciseId).first.bodyPart : '', calendarWorkouts[i].lifts![j].liftMas!.toInt(), calendarWorkouts[i].lifts![j].repetitions ?? 0, calendarWorkouts[i].lifts![j].oneRepMax ?? 0.0, true, -1));
          }
        }
      }
    } else if (mode == 1) {
      print(workOuts.length);
      var workout = workOuts.where((element) => element.id == id).single;

      print(workout.title);
      for (int j = 0; j < workout.lifts!.length; j++) {
        title = workout.title ?? '';
        lifts.add(EditableLift.create(workout.lifts![j].exerciseName, workout.lifts![j].exerciseId, exercises.isNotEmpty ? exercises.where((element) => element.id == workout.lifts![j].exerciseId).first.bodyPart : '', workout.lifts![j].liftMas!.toInt(), workout.lifts![j].repetitions ?? 0, workout.lifts![j].oneRepMax ?? 0.0, true, -1));
      }
    } else if (mode == 3) {
      var workout = favoriteWorkOuts.where((element) => element.id == id).single;
      for (int j = 0; j < workout.lifts!.length; j++) {
        title = workout.title ?? '';
        lifts.add(EditableLift.create(workout.lifts![j].exerciseName, workout.lifts![j].exerciseId, exercises.isNotEmpty ? exercises.where((element) => element.id == workout.lifts![j].exerciseId).first.bodyPart : '', workout.lifts![j].liftMas!.toInt(), workout.lifts![j].repetitions ?? 0, workout.lifts![j].oneRepMax ?? 0.0, true, -1));
      }
    }

    await createWorkoutProvider.repeatWorkoutSession(lifts, title ?? '[]');
  }

  void _updateWorkoutFavoriteStatus(int id, int mode) {
    if (mode == 1)
      for (int i = 0; i < workOuts.length; i++) {
        if (workOuts[i].id == id) {
          workOuts[i].isFavorite = !workOuts[i].isFavorite;
          if (calendarWorkouts.isNotEmpty) calendarWorkouts.where((element) => element.id == id).first.isFavorite = workOuts[i].isFavorite;

          if (workOuts[i].isFavorite && favoriteWorkoutsFetched) {
            favoriteWorkOuts.add(workOuts[i]);
          } else {
            favoriteWorkOuts.removeWhere((element) => element.timestamp == workOuts[i].timestamp);
          }
          break;
        }
      }
    else if (mode == 2)
      for (int i = 0; i < calendarWorkouts.length; i++) {
        if (calendarWorkouts[i].id == id) {
          calendarWorkouts[i].isFavorite = !calendarWorkouts[i].isFavorite;

          if (calendarWorkouts[i].isFavorite && favoriteWorkoutsFetched) {
            favoriteWorkOuts.add(calendarWorkouts[i]);
          } else {
            favoriteWorkOuts.removeWhere((element) => element.timestamp == calendarWorkouts[i].timestamp);
          }
          for (int j = 0; j < workOuts.length; j++) {
            if (workOuts[j].id == id) {
              workOuts.where((element) => element.id == id).first.isFavorite = calendarWorkouts[i].isFavorite;
              break;
            }
          }
        }
      }
    else if (mode == 3) {
      print('dferqerig');
      for (int i = 0; i < favoriteWorkOuts.length; i++) {
        print(favoriteWorkOuts[i].id);
      }

      favoriteWorkOuts.removeWhere((element) => element.id == id);
      if (todayWorkoutsFetched) {
        for (int i = 0; i < workOuts.length; i++) {
          if (workOuts[i].id == id) {
            workOuts[i].isFavorite = false;
          }
        }
      }
      if (calendarWorkoutsFetched) calendarWorkouts.singleWhere((element) => element.id == id).isFavorite = false;
    }

    notifyListeners();
  }

  void reset() {
    workOuts.clear();
    calendarWorkouts.clear();
    todayWorkoutsFetched = false;
    favoriteWorkoutsFetched = false;
    calendarWorkoutsFetched = false;
    notifyListeners();
  }

  void updateWorkoutDates(List<WorkOut> workouts) {
    workOutDates.clear();
    for (int i = 0; i < calendarWorkouts.length; i++) {
      workOutDates.add(toDate(calendarWorkouts[i].timestamp ?? 0));
    }
  }

  void onCalendarDropDownButtonValueChanged(String item, List<String>? years_en, List<String>? years_kr, ConfigProvider configProvider) {
    var currentYear = DateTime.now().year;
    String selectedMonthTime = '';
    if (configProvider.activeLanguage() == english) {
      var month = years_en!.indexOf(item.toString()) + 1 >= 10 ? '${years_en.indexOf(item.toString()) + 1}' : '0${years_en.indexOf(item.toString()) + 1}';
      selectedMonthTime = '${currentYear}-${month}-01 00:00:00.000';
    } else {
      var month = years_kr!.indexOf(item.toString()) + 1 >= 10 ? '${years_kr.indexOf(item.toString()) + 1}' : '0${years_kr.indexOf(item.toString()) + 1}';
      selectedMonthTime = '${currentYear}-${month}-01 00:00:00.000';
    }
    selectedDate = DateTime.parse(selectedMonthTime);
    currentMonthIndex = configProvider.activeLanguage() == english ? years_en!.indexOf(item.toString()) : years_kr!.indexOf(item.toString());
    notifyListeners();
  }

  void onCalendarPageRefereshed(DateTime dateTime) {
    selectedDate = dateTime;
    currentMonthIndex = dateTime.month - 1;
    ;
    update();
  }

  void update() {
    notifyListeners();
  }

}
