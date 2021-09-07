import 'dart:convert';

class EditableLift {
  String? exerciseName;
  int? exerciseId;
  String? bodyPart;
  int mass = 1;
  int rep = 1;
  double rm = 1.0;
  bool isSelected = false;
  int? liftId;
  List<int> kgs = List.generate(51, (index) => (index));
  List<int> reps = List.generate(51, (index) => (index));

  EditableLift.create(this.exerciseName, this.exerciseId, this.bodyPart, this.mass, this.rep, this.rm, this.isSelected, this.liftId);

  EditableLift();

  factory EditableLift.fromJson(Map<String, dynamic> parsedJson) {
    return EditableLift.create(parsedJson["exercise_name"], parsedJson["id"], parsedJson["body_part"], parsedJson["mass"], parsedJson["rep"], parsedJson["rm"], parsedJson["is_selected"], -1);
  }

  static String encode(List<EditableLift> editableLifts) {
    return json.encode(editableLifts.map<Map<String, dynamic>>((e) => EditableLift.toMap(e)).toList());
  }

  static List<EditableLift> decode(String lifts) {
    return (json.decode(lifts) as List<dynamic>).map<EditableLift>((e) => EditableLift.fromJson(e)).toList();
  }

  static Map<String, dynamic> toMap(EditableLift lift) {
    return {
      'exercise_name': lift.exerciseName,
      'id': lift.exerciseId,
      'body_part': lift.bodyPart,
      'mass': lift.mass,
      'rep': lift.rep,
      'rm': lift.rm,
      'is_selected': lift.isSelected,
    };
  }
}
