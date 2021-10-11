class TargetModelResponse {
  bool success = false;
  List<Target> targets = [];

  TargetModelResponse(this.success, this.targets);

  factory TargetModelResponse.fromJson(Map<String, dynamic> parsedJson) {
    List<dynamic>? list = [];
    list = parsedJson['targets'] as List;
    List<Target> targets = list.map((e) => Target.fromJson(e)).toList();
    return TargetModelResponse(parsedJson['success'], targets);
  }
}

class Target {
  int? id;
  String? targetName;
  int? startTimestamp;
  int? endTimestamp;
  bool achieved = false;

  Target(this.targetName, this.startTimestamp, this.endTimestamp, this.achieved, this.id);

  factory Target.fromJson(Map<String, dynamic> parsedJson) {
    return Target(parsedJson['name'], parsedJson['startDateMs'], parsedJson['endDateMs'], parsedJson['achieved'], parsedJson['id']);
  }
}
