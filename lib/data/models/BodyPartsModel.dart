


class  BodyPartsResponse{


  bool success = false;
  List<BodyPart>? bodyParts;

  BodyPartsResponse(this.success, this.bodyParts);


  factory BodyPartsResponse.fromJson(Map<String,  dynamic> parsedJson){

    List<dynamic>? list = [];
    list = parsedJson['body_parts'] as List;
    List<BodyPart> bodyParts = list.map((e) => BodyPart.fromJson(e)).toList();

    return BodyPartsResponse(parsedJson['success'], bodyParts);
  }
}

class BodyPart{

  int id;
  String name;

  BodyPart(this.id, this.name);



  factory BodyPart.fromJson(Map<String,  dynamic> parsedJson){
    return BodyPart(parsedJson['id'], parsedJson['name']);
  }
}