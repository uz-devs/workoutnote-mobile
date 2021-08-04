
class User{
  String? _sessionKey;
  bool  _authSuccess = false ;

  User.create(this._sessionKey, this._authSuccess);


  String? get sessionKey => _sessionKey;
  bool get authSuccess => _authSuccess;


  factory User.fromJson(Map<String, dynamic> parsedJson) {
    print(parsedJson["sessionKey"]);
    return User.create(parsedJson["sessionKey"],parsedJson["success"]);
  }

}

class  Settings{
  bool _success = false;
  String? _name;
  String?  _dateOfBirth;
  String?  _gender;
  bool  _iProfileShared  = false;

  Settings.fetch(this._success, this._name, this._dateOfBirth, this._gender, this._iProfileShared);

  bool get iProfileShared => _iProfileShared;

  String? get gender => _gender;

  String? get dateOfBirth => _dateOfBirth;

  String? get name => _name;

  bool get success => _success;

  factory Settings.fromJson(Map<String, dynamic> parsedJson) {
    return Settings.fetch(parsedJson["success"], parsedJson["name"], parsedJson["date_of_birth"],  parsedJson["gender"],  parsedJson["is_profile_shared"]);
  }


}