

import 'dart:convert';

import 'package:flutter/material.dart';

class  WorkOutsResponse{
  bool _success = false;
  List<WorkOut> _workouts;

  WorkOutsResponse(this._success, this._workouts);

  List<WorkOut> get workouts => _workouts;

  bool get success => _success;

  factory WorkOutsResponse.fromJson(Map<String, dynamic> parsedJson){
    List<dynamic>? list = [];
    list = parsedJson['workouts'] as List;

    print(list.length);
    print(parsedJson["success"]);

    List<WorkOut> workouts = list.map((e) => WorkOut.fromJson(e)).toList();
      return  WorkOutsResponse(parsedJson["success"], workouts);

  }

}

class WorkOut {
  int? _id;
  String? _title;
  int? _timestamp;
  int? _duration;
  List<Lift>? lifts;

  WorkOut(this._id,  this._title, this._timestamp, this.lifts, this._duration);
  int? get timestamp => _timestamp;

  String? get title => _title;

  int? get id => _id;

  int? get duration  => _duration;



  factory WorkOut.fromJson(Map<String,  dynamic> parsedJson){
    List<dynamic>? list = [];


    if(parsedJson['lifts'] != null)
    list = parsedJson['lifts'] as List;
    else  list  = [];
   List<Lift> lifts = list.map((e) => Lift.fromJson(e)).toList();
    return WorkOut(parsedJson["id"], parsedJson["title"],  parsedJson["timestamp"], lifts, parsedJson["duration"] );
  }

}

class Lift {
  int? _liftId;
  int? _timestamp;
  double? _oneRepMax;
  int? _exerciseId;
  String? _exerciseName;
  double? _liftMas;
  int? _repetitions;

  Lift.create(this._liftId, this._timestamp, this._oneRepMax, this._exerciseId, this._exerciseName, this._liftMas, this._repetitions);

  Lift();
  int? get repetitions => _repetitions;

  double? get liftMas => _liftMas;

  String? get exerciseName => _exerciseName;

  int? get exerciseId => _exerciseId;

  double? get oneRepMax => _oneRepMax;

  int? get timestamp => _timestamp;

  int? get liftId => _liftId;


  set liftId(int? value) {
    _liftId = value;
  }

  factory Lift.fromJson(Map<String,  dynamic> parsedJson){
    return Lift.create(parsedJson["id"], parsedJson["timestamp"], parsedJson["one_rep_max"], parsedJson["exercise_id"], parsedJson["exercise_name"], parsedJson["lift_mass"], parsedJson["repetitions"]);
  }


  static String encode(List<Lift> workouts){
    return  json.encode(workouts.map<Map<String, dynamic>> ((e) => Lift.toMap(e)).toList());
  }
  static List<Lift > decode(String lifts) {
    return (json.decode(lifts) as List<dynamic>).map<Lift>((e) => Lift.fromJson(e)).toList();

  }

  static Map<String, dynamic> toMap(Lift lift){
    return  {
      'id': lift.liftId,
      'timestamp': lift.timestamp,
      'one_rep_max': lift.oneRepMax,
      'exercise_id': lift.exerciseId,
      'exercise_name': lift.exerciseName,
      'lift_mass': lift.liftMas,
      'repetitions': lift.repetitions
    };
  }

  set timestamp(int? value) {
    _timestamp = value;
  }

  set oneRepMax(double? value) {
    _oneRepMax = value;
  }

  set exerciseId(int? value) {
    _exerciseId = value;
  }

  set exerciseName(String? value) {
    _exerciseName = value;
  }

  set liftMas(double? value) {
    _liftMas = value;
  }

  set repetitions(int? value) {
    _repetitions = value;
  }
}
