class ExercisesResponse {
  bool success = false;
  List<Exercise>? exercises;

  ExercisesResponse(this.success, this.exercises);

  factory ExercisesResponse.fromJson(Map<String, dynamic> parsedJson) {
    List<dynamic>? list = [];
    list = parsedJson['exercises'] as List;

    List<Exercise> exercises = list.map((e) => Exercise.fromJson(e)).toList();

    return ExercisesResponse(parsedJson['success'], exercises);
  }
}

class Exercise {
  int? id;
  String? name;
  String? bodyPart;
  String? category;
  NameTranslation? namedTranslations;
  bool isFavorite = false;

  Exercise(this.id, this.name, this.bodyPart, this.category, this.isFavorite, this.namedTranslations);

  factory Exercise.fromJson(Map<String, dynamic> parsedJson) {
    return Exercise(parsedJson['id'], parsedJson['name'], parsedJson['body_part_str'], parsedJson['category_str'], parsedJson['isFavorite'] ?? false, NameTranslation.fromJson(parsedJson['name_translations']));
  }
}

class NameTranslation {
  String? _english;

  NameTranslation(this._english);

  String? get english => _english;

  set english(String? value) {
    _english = value;
  }

  factory NameTranslation.fromJson(Map<String, dynamic> parsedJson) {
    return NameTranslation(parsedJson['EN']);
  }
}
