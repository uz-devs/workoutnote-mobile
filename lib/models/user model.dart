
class User{
  String? _sessionKey;
  bool  _authSuccess = false ;

  User.create(this._sessionKey, this._authSuccess);


  String? get sessionKey => _sessionKey;
  bool get authSuccess => _authSuccess;


  factory User.fromJson(Map<String, dynamic> parsedJson) {

    return User.create(parsedJson["sessionKey"],parsedJson["success"]);
  }

}