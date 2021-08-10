import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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

  List<EditableLift> _selectedExercises = [];
  int _responseCode1 = 0;
  bool _requestDone1 = false;
  int _responseCode2 = 0;
  bool _requestDone2 = false;
  EditableLift? _unselectedLift = EditableLift();
  Exercise? _unselectedExercise;
  TextEditingController _titleContoller = TextEditingController();
  //drop down buttons

  bool appRefereshed = false;
  bool ticksReefrshed = false;
  bool timeRefreshed = false;
  int duration = 0;

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
  Future<void> createWorkOutSession(String sessionKey, String title, int timestamp) async {

    bool  canCreateSession = false;
    for(int i = 0; i<_selectedExercises.length; i++){
      if(_selectedExercises[i].isSelected) {
        canCreateSession = true;
        break;
      }
    }
   if(canCreateSession){
    try {
      List<Lift> lifts = [];
      int count = 0;
      var response = await WebServices.insertWorkOut(sessionKey, title, timestamp, duration);
      if (response.statusCode == 200 && jsonDecode(response.body)["success"]) {
        print(response.body);
        for (int i = 0; i < _selectedExercises.length; i++) {
          var insertLift = await WebServices.insertLift(sessionKey, timestamp, _selectedExercises[i].mass, _selectedExercises[i].exerciseId ?? -1, jsonDecode(response.body)["workout_session"]["id"]);
          var lift = Lift.fromJson(jsonDecode(insertLift.body)["lift"]);
          if (insertLift.statusCode == 200 && jsonDecode(insertLift.body)["success"]) {
            count++;
            lifts.add(Lift.create(lift.liftId, lift.timestamp, lift.oneRepMax, lift.exerciseId, lift.exerciseName, lift.liftMas, lift.repetitions));
          }
        }
        if (count == _selectedExercises.length) {
          var workout = WorkOut.fromJson(jsonDecode(response.body)["workout_session"]);
          _workOuts.add(WorkOut(workout.id, workout.title, workout.timestamp, lifts, workout.duration, false ));
          _selectedExercises.removeWhere((element) => element.isSelected);
           stopTimer();
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
   else{
     showToast("You need to add at least one exercise for one workout session!");
   }
  }
  Future<void> setFavoriteWorkOut(String sessionKey, int workoutId) async{
    try {
      var response = await WebServices.setFavoriteWorkOut(sessionKey, workoutId);
      print(response.body);
      if (response.statusCode == 200 && jsonDecode(response.body)["success"]) {
        setFavorite(workoutId);
      }

    }
    catch(e){
        print(e);

      }
    }
  Future<void> unsetFavoriteWorkOut(String sessionKey, int workoutId) async{
    try {
      var response = await WebServices.unsetFavoriteWorkOut(sessionKey, workoutId);
      print(response.body);
      if (response.statusCode == 200 && jsonDecode(response.body)["success"]) {
        unsetFavorite(workoutId);
      }
    }
    catch(e){
      print(e);
    }
  }
  void unsetFavorite(int id){
    for(int i = 0; i<_workOuts.length; i++){
      if(_workOuts[i].id == id){
        _workOuts[i].isFavorite = !_workOuts[i].isFavorite;
        break;
      }
    }
  }
  void setFavorite(int   id){
    for(int i = 0; i<_workOuts.length; i++){
      if(_workOuts[i].id == id){
        _workOuts[i].isFavorite = !_workOuts[i].isFavorite;
        break;
      }
    }
  }





  //getters&setters




  List<WorkOut> get workOuts => _workOuts;
  List<EditableLift> get selectedExercises => _selectedExercises;
  Exercise? get unselectedExercise => _unselectedExercise;
  int get responseCode1 => _responseCode1;
  bool get requestDone1 => _requestDone1;
  bool get requestDone2 => _requestDone2;
  int get reponseCode2 => _responseCode2;
  EditableLift? get unselectedLift => _unselectedLift;
  TextEditingController get titleContoller => _titleContoller;


  set unselectedExercise(Exercise? value) {
    _unselectedExercise = value;
    notifyListeners();
  }

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
  Future<void> saveListToSharePreference() async {
    await userPreferences!.setString("lifts", EditableLift.encode(_selectedExercises));
  }

  Future<void> saveTitleToSharedPreference(String title) async {
    await userPreferences!.setString("title", title);
  }

  Future<void> saveTimeToSharedPreference(int time) async {
    await userPreferences!.setInt("time", time);
  }

  void addExercise(EditableLift exercise) {
    _selectedExercises.add(exercise);
    //set State
  }

  void firstEnterApp() {
    appRefereshed = true;
    if (userPreferences!.getString("title") != null) titleContoller.text = userPreferences!.getString("title") ?? "";
    print(titleContoller.text);
    if (userPreferences!.getString("lifts") != null) {
      List<EditableLift> lifts = EditableLift.decode(userPreferences!.getString("lifts") ?? "");
      for (int i = 0; i < lifts.length; i++) {
        _selectedExercises.add(lifts[i]);
        print(_selectedExercises[i].exerciseName);
      }
    }
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
    _selectedExercises[index].mass = val;
    updateRM(val,  _selectedExercises[index].rep, index);
    notifyListeners();
  }

  void updateRep(index, int val) {
    _selectedExercises[index].rep = val;
    updateRM(_selectedExercises[index].mass, val, index);
    notifyListeners();
  }

  void updateRM(int mass, int rep, index) {
    _selectedExercises[index].rm = mass + mass * rep * 0.025;
  }
}
