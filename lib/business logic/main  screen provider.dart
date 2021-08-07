import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:workoutnote/models/body%20%20parts%20model.dart';
import 'package:workoutnote/models/editible%20lift%20model.dart';

import 'package:workoutnote/models/exercises%20model.dart';
import 'package:workoutnote/models/work%20out%20list%20%20model.dart';
import 'package:workoutnote/services/network%20%20service.dart';
import 'package:workoutnote/utils/utils.dart';

class MainScreenProvider extends ChangeNotifier {
  //vars
  String secs = "00";
  String mins = "00";
  String hrs = "00";
  StreamSubscription? timerSubscription;
  List<WorkOut> _workOuts = [];
  List<Exercise> _exercises = [];
  List<BodyPart> _bodyParts = [];
  List<Exercise> searchExercises = [];
  List<EditableLift> _selectedExercises = [];
  int? selectedMass, selectedRep;
  int _responseCode1 = 0;
  bool _requestDone1 = false;
  int _responseCode2 = 0;
  bool _requestDone2 = false;
  EditableLift? _unselectedLift = EditableLift();
  Exercise? _unselectedExercise;
  TextEditingController _titleContoller = TextEditingController();
  TextEditingController searchController = TextEditingController();

  //api  calls
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

  Future<void> fetchExercises() async {
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
  Future<void> fetchBodyParts() async {
    if(_bodyParts.isNotEmpty) _bodyParts.clear();
    try {
      var response = await WebServices.fetchBodyParts();



      if (response.statusCode == 200) {
        var bodyParts = BodyPartsResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          print(response.body);
         _bodyParts.addAll(bodyParts.bodyParts);
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
      List<Lift> lifts = [];
      int count = 0;
      var response = await WebServices.insertWorkOut(sessionKey, title, timestamp, duration);
      if (response.statusCode == 200 && jsonDecode(response.body)["success"]) {
        for (int i = 0; i < _selectedExercises.length; i++) {
          var insertLift = await WebServices.insertLift(sessionKey, timestamp, 10, _selectedExercises[i].exercise!.id ?? -1, jsonDecode(response.body)["workout_session"]["id"]);
          var lift = Lift.fromJson(jsonDecode(insertLift.body)["lift"]);
          if (insertLift.statusCode == 200 && jsonDecode(insertLift.body)["success"]) {
            count++;
            lifts.add(Lift.create(lift.liftId, lift.timestamp, lift.oneRepMax, lift.exerciseId, lift.exerciseName, lift.liftMas, lift.repetitions));
          }
        }
        if (count == _selectedExercises.length) {
          var  workout = WorkOut.fromJson(jsonDecode(response.body)["workout_session"]);
          _workOuts.add(WorkOut(workout.id, workout.title, workout.timestamp, lifts, workout.duration));
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

  List<BodyPart> get bodyParts => _bodyParts;

  set bodyParts(List<BodyPart> value) {
    _bodyParts = value;
  } //getters&setters




  List<WorkOut> get workOuts => _workOuts;

  List<Exercise> get exercises => _exercises;

  List<EditableLift> get selectedExercises => _selectedExercises;

  Exercise? get unselectedExercise => _unselectedExercise;

  set unselectedExercise(Exercise? value) {
    _unselectedExercise = value;
    notifyListeners();
  }

  EditableLift? get unselectedLift => _unselectedLift;

  int get responseCode1 => _responseCode1;

  bool get requestDone1 => _requestDone1;

  bool get requestDone2 => _requestDone2;

  int get reponseCode2 => _responseCode2;

  TextEditingController get titleContoller => _titleContoller;

  set titleContoller(TextEditingController value) {
    _titleContoller = value;
  } //region getters and setters

  set unselectedLift(EditableLift? value) {
    _unselectedLift = value;
    notifyListeners();
  }

  set requestDone1(bool value) {
    _requestDone1 = value;
  }

  set requestDone2(bool value) {
    _requestDone2 = value;
  }

  //utils
  void addExercise(EditableLift exercise) {
    selectedExercises.add(exercise);
    print(selectedExercises.length);
    notifyListeners();
  }

  void updateExercise(int index) {
    if (_selectedExercises[index].isSelected == false)
      _selectedExercises[index].isSelected = true;
    else
      _selectedExercises[index].isSelected = false;

    notifyListeners();
  }

  void removeExercises() {
    _selectedExercises.removeWhere((element) => element.isSelected);
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
    if (searchExercises.isNotEmpty) searchExercises.clear();


    for (int i = 0; i < _exercises.length; i++) {
      if (_exercises[i].name == searchWord) {
        print(_exercises[i].name);
        searchExercises.add(_exercises[i]);
      }
    }

    notifyListeners();
  }
}


/*





 */