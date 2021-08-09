import 'dart:convert';
import 'package:workoutnote/models/exercises%20model.dart';
import 'package:workoutnote/models/work%20out%20list%20%20model.dart';

class EditableLift{

  String? _exerciseName;
  int? _exerciseId;
  String?   _bodyPart;

  int _mass = 1;
  int _rep = 1;
  bool  _isSelected = false;
  List<int> kgs = List.generate(51, (index) => (index));
  List<int> reps = List.generate(51, (index) => (index));

  EditableLift.create(this._exerciseName, this._exerciseId, this._bodyPart, this._mass, this._rep, this._isSelected);

  EditableLift();
  bool get isSelected => _isSelected;

  set isSelected(bool value) {
    _isSelected = value;
  }

  int get rep => _rep;

  set rep(int value) {
    _rep = value;
  }

  int get mass => _mass;

  set mass(int value) {
    _mass = value;
  }


  String? get exerciseName => _exerciseName;

  set exerciseName(String? value) {
    _exerciseName = value;
  }

  factory EditableLift.fromJson(Map<String,  dynamic> parsedJson){

    return EditableLift.create(parsedJson["exercise_name"], parsedJson["id"], parsedJson["body_part"], parsedJson["mass"], parsedJson["rep"], parsedJson["is_selected"]);
  }


  static String encode(List<EditableLift> editableLifts){

    return  json.encode(editableLifts.map<Map<String, dynamic>> ((e) => EditableLift.toMap(e)).toList());
  }
  static List<EditableLift > decode(String lifts) {
    return (json.decode(lifts) as List<dynamic>).map<EditableLift>((e) => EditableLift.fromJson(e)).toList();

  }
  static Map<String, dynamic> toMap(EditableLift lift){




    return  {
      'exercise_name': lift.exerciseName,
      'id' :lift.exerciseId,
      'body_part': lift.bodyPart,
      'mass': lift.mass,
      'rep': lift.rep,
      'is_selected': lift.isSelected,
    };
  }

  int? get exerciseId => _exerciseId;

  set exerciseId(int? value) {
    _exerciseId = value;
  }

  String? get bodyPart => _bodyPart;

  set bodyPart(String? value) {
    _bodyPart = value;
  }
}