class AppUser{
  String? sessionKey;
  bool  authSuccess = false ;

  AppUser.create(this.sessionKey, this.authSuccess);

  factory AppUser.fromJson(Map<String, dynamic> parsedJson) {
    print(parsedJson['sessionKey']);
    return AppUser.create(parsedJson['sessionKey'],parsedJson['success']);
  }

}

class  UserProfile{
  bool success = false;
  String? name;
  String?  dateOfBirth;
  String? gender;
  bool  iProfileShared  = false;

  UserProfile.fetch(this.success, this.name, this.dateOfBirth, this.gender, this.iProfileShared);

  factory UserProfile.fromJson(Map<String, dynamic> parsedJson) {
    return UserProfile.fetch(parsedJson['success'], parsedJson['name'], parsedJson['date_of_birth'],  parsedJson['gender'],  parsedJson['is_profile_shared']);
  }


}