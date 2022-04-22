/// uid : ""
/// name : ""
/// userName : ""
/// mobileNo : ""
/// gender : ""
/// email : ""
/// dateOfBirth : ""

class User {
  User({
    String? uid,
    String? name,
    String? userName,
    String? mobileNo,
    String? gender,
    String? email,
    String? dateOfBirth,
  }) {
    _uid = uid;
    _name = name;
    _userName = userName;
    _mobileNo = mobileNo;
    _gender = gender;
    _email = email;
    _dateOfBirth = dateOfBirth;
  }

  User.fromJson(dynamic json) {
    _uid = json['uid'];
    _name = json['name'];
    _userName = json['userName'];
    _mobileNo = json['mobileNo'];
    _gender = json['gender'];
    _email = json['email'];
    _dateOfBirth = json['dateOfBirth'];
  }

  String? _uid;
  String? _name;
  String? _userName;
  String? _mobileNo;
  String? _gender;
  String? _email;
  String? _dateOfBirth;

  User copyWith({
    String? uid,
    String? name,
    String? userName,
    String? mobileNo,
    String? gender,
    String? email,
    String? dateOfBirth,
  }) =>
      User(
        uid: uid ?? _uid,
        name: name ?? _name,
        userName: userName ?? _userName,
        mobileNo: mobileNo ?? _mobileNo,
        gender: gender ?? _gender,
        email: email ?? _email,
        dateOfBirth: dateOfBirth ?? _dateOfBirth,
      );

  String? get uid => _uid;

  String? get name => _name;

  String? get userName => _userName;

  String? get mobileNo => _mobileNo;

  String? get gender => _gender;

  String? get email => _email;

  String? get dateOfBirth => _dateOfBirth;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = _uid;
    map['name'] = _name;
    map['userName'] = _userName;
    map['mobileNo'] = _mobileNo;
    map['gender'] = _gender;
    map['email'] = _email;
    map['dateOfBirth'] = _dateOfBirth;
    return map;
  }
}
