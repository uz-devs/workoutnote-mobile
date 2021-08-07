


import 'package:workoutnote/models/exercises%20model.dart';

class EditableLift{

  Exercise? _exercise;
  int? _mass;
  int? _rep;
  bool  _isSelected = false;

  EditableLift.create(this._exercise, this._mass, this._rep, this._isSelected);

  EditableLift();
  bool get isSelected => _isSelected;

  set isSelected(bool value) {
    _isSelected = value;
  }

  int? get rep => _rep;

  set rep(int? value) {
    _rep = value;
  }

  int? get mass => _mass;

  set mass(int? value) {
    _mass = value;
  }

  Exercise? get exercise => _exercise;

  set exercise(Exercise? value) {
    _exercise = value;
  }
}