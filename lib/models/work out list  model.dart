class WorkOuts{

int?  _id;
String? _title;
int? _timestamp;
List<Lift>? lifts;

}


class Lift{
 int? _liftId;
 int?  _timestamp;
 String?  _oneRepMax;
 int? _exerciseId;
 String?  _exerciseName;
 double? _liftMas;
 int? _repetitions;

 Lift(this._liftId, this._timestamp, this._oneRepMax, this._exerciseId, this._exerciseName, this._liftMas, this._repetitions);

 int? get repetitions => _repetitions;

  double? get liftMas => _liftMas;

  String? get exerciseName => _exerciseName;

  int? get exerciseId => _exerciseId;

  String? get oneRepMax => _oneRepMax;

  int? get timestamp => _timestamp;

  int? get liftId => _liftId;
}

