
class User{
  String? sessionKey;
  bool  authSuccess = false ;

  User.create(this.sessionKey, this.authSuccess);




  factory User.fromJson(Map<String, dynamic> parsedJson) {
    print(parsedJson["sessionKey"]);
    return User.create(parsedJson["sessionKey"],parsedJson["success"]);
  }

}

class  Settings{
  bool success = false;
  String? name;
  String?  dateOfBirth;
  String? gender;
  bool  iProfileShared  = false;

  Settings.fetch(this.success, this.name, this.dateOfBirth, this.gender, this.iProfileShared);



  factory Settings.fromJson(Map<String, dynamic> parsedJson) {
    return Settings.fetch(parsedJson["success"], parsedJson["name"], parsedJson["date_of_birth"],  parsedJson["gender"],  parsedJson["is_profile_shared"]);
  }


}