import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:workoutnote/models/exercises%20model.dart';
import 'package:workoutnote/models/work%20out%20list%20%20model.dart';
import 'package:workoutnote/services/network%20%20service.dart';
import 'package:workoutnote/utils/utils.dart';

class MainScreenProvider extends ChangeNotifier {

  //region vars
  String secs = "00";
  String mins = "00";
  String hrs = "00";
  StreamSubscription? timerSubscription;
  TextEditingController _titleContoller = TextEditingController();


  List<WorkOut> _workOuts = [];
  List<Exercise> _exercises = [];
  List<Exercise> searchexercies = [];
  List<Map<Exercise, bool>> _selectedExercises = [];
  List<int>? masseses = List.generate(100, (index) => index+ 1);
  List<int>? repetitions = List.generate(100, (index) => index+ 1);
  int? selectedMass,  selectedRep;

  int _responseCode1 = 0;
  bool _requestDone1 = false;
  int _responseCode2 = 0;
  bool _requestDone2 = false;
  Exercise? _unselectedExercise;
  TextEditingController searchController = TextEditingController();
  //endregion
  //region api  request
  Future<void> fetchWorkOuts(String sessionKey, int timestamp) async {
    try {
      var response = await WebServices.fetchWorkOuts(sessionKey, timestamp);
      print(sessionKey);

      if (response.statusCode == 200) {
        var workoutsResponse = WorkOutsResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
        if (workoutsResponse.success) {
          _workOuts.addAll(workoutsResponse.workouts);
          _responseCode1 = SUCCESS;
          notifyListeners();
        }
      }
    } on TimeoutException catch (e) {
      _responseCode1 = TIMEOUT_EXCEPTION;
      print(e);
    } on SocketException catch (e) {
      _responseCode1 = SOCKET_EXCEPTION;
      print(e);
    } on Error catch (e) {
      _responseCode1 = MISC_EXCEPTION;
      print(e);
    }
  }

  Future<void> fecthExercises() async {
    try {
      var response = await WebServices.fetchExercises();

      if (response.statusCode == 200) {
        var workoutsResponse = ExercisesResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
        if (workoutsResponse.success) {
          _exercises.addAll(workoutsResponse.exercises ?? []);
          print(_exercises);
          _responseCode2 = SUCCESS;
          notifyListeners();
        }
      }
    } on TimeoutException catch (e) {
      _responseCode2 = TIMEOUT_EXCEPTION;
      print(e);
    } on SocketException catch (e) {
      _responseCode2 = SOCKET_EXCEPTION;
      print(e);
    } on Error catch (e) {
      _responseCode2 = MISC_EXCEPTION;
      print(e);
    }
  }

  Future<void> createWorkOutSession(String sessionKey, String title, int timestamp, int duration) async {
    try {
      Response? insertLift;
      var response = await WebServices.insertWorkOut(sessionKey, title, timestamp, duration);
      print(response.body);
      if (response.statusCode == 200) {
        Map workout = jsonDecode(response.body);
        for (int i = 0; i < _selectedExercises.length; i++) {
          print(_selectedExercises[i].keys.first.id);
          print(_selectedExercises[i].keys.first.name);

          insertLift = await WebServices.insertLift(sessionKey, timestamp, 1, _selectedExercises[i].keys.first.id ?? -1, workout["workout_session"]["id"]);
          print(insertLift.body);
        }
        if (insertLift!.statusCode == 200) {
          _selectedExercises.clear();
        }
      }
      notifyListeners();
    } on TimeoutException catch (e) {
      _responseCode2 = TIMEOUT_EXCEPTION;
      print(e);
    } on SocketException catch (e) {
      _responseCode2 = SOCKET_EXCEPTION;
      print(e);
    } on Error catch (e) {
      _responseCode2 = MISC_EXCEPTION;
      print(e);
    }
  }


  TextEditingController get titleContoller => _titleContoller;

  set titleContoller(TextEditingController value) {
    _titleContoller = value;
  } //region getters and setters



  List<WorkOut> get workOuts => _workOuts;

  List<Exercise> get exercises => _exercises;

  List<Map<Exercise, bool>> get selectedExercises => _selectedExercises;

  Exercise? get unselectedExercise => _unselectedExercise;

  int get responseCode1 => _responseCode1;

  bool get requestDone1 => _requestDone1;

  bool get requestDone2 => _requestDone2;

  int get reponseCode2 => _responseCode2;

  set unselectedExercise(Exercise? value) {
    _unselectedExercise = value;
    notifyListeners();
  }

  set requestDone1(bool value) {
    _requestDone1 = value;
  }

  set requestDone2(bool value) {
    _requestDone2 = value;
  }
  //endregion
  //region util  methods
  void addExercise(Map<Exercise, bool> exercise) {
    selectedExercises.add(exercise);
    notifyListeners();
  }

  void updateExercise(int index) {
    if (_selectedExercises[index].values.first == false)
      _selectedExercises[index][_selectedExercises[index].keys.first] = true;
    else
      _selectedExercises[index][_selectedExercises[index].keys.first] = false;

    notifyListeners();
  }

  void removeExercises() {
    _selectedExercises.removeWhere((element) => element.values.first);
    notifyListeners();
  }

  void startTimer() {
    var timerStream = stopWatchStream();
    timerSubscription = timerStream.listen((int newTick) {
      hrs = ((newTick / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
      mins = ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
      secs = (newTick % 60).floor().toString().padLeft(2, '0');

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

  void searchResults(String searchWord) {
    if (searchexercies.isNotEmpty) searchexercies.clear();

    for (int i = 0; i < _exercises.length; i++) {
      if (_exercises[i].name == searchWord){
        print(_exercises[i].name);
        searchexercies.add(_exercises[i]);
    }}

    notifyListeners();
  }



  //endregion
}
