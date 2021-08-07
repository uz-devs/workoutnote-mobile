

class  BodyPartsResponse{


  bool success = false;
  List<BodyPart> _bodyParts;

  BodyPartsResponse(this.success, this._bodyParts);

  List<BodyPart> get bodyParts => _bodyParts;

  set bodyParts(List<BodyPart> value) {
    _bodyParts = value;
  }


  factory BodyPartsResponse.fromJson(Map<String,  dynamic> parsedJson){

    List<dynamic>? list = [];
    list = parsedJson['body_parts'] as List;
    List<BodyPart> bodyParts = list.map((e) => BodyPart.fromJson(e)).toList();

    return BodyPartsResponse(parsedJson["success"], bodyParts);
  }
}

class BodyPart{

  int _id;
  String _name;

  BodyPart(this._id, this._name);

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }



  factory BodyPart.fromJson(Map<String,  dynamic> parsedJson){
    return BodyPart(parsedJson["id"], parsedJson["name"]);
  }
}