

import 'dart:convert';

class ExercisesResponse{
  bool  _success = false;
  List<Exercise>? _exercises;

  ExercisesResponse(this._success, this._exercises);

  List<Exercise>? get exercises => _exercises;

  bool get success => _success;

  factory ExercisesResponse.fromJson(Map<String,  dynamic> parsedJson) {

    List<dynamic>? list = [];
    list = parsedJson['exercises'] as List;



    List<Exercise> exercises = list.map((e) => Exercise.fromJson(e)).toList();

    return  ExercisesResponse(parsedJson["success"], exercises);

  }
}

class  Exercise{
  int?  _id;
  String?  _name;
  String?  _bodyPart;
  String?  _category;

  Exercise(this._id, this._name, this._bodyPart, this._category);



  String? get category => _category;

  String? get bodyPart => _bodyPart;

  String? get name => _name;

  int? get id => _id;

  factory Exercise.fromJson(Map<String,  dynamic> parsedJson){
     return Exercise(parsedJson["id"], parsedJson["name"], parsedJson["body_part_str"], parsedJson["category_str"]);

  }
}