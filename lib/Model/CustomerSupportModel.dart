class CustomerSupportModel {
  CustomerSupportModel({
    String? uid,
    String? name,
    String? email,
    String? message,
  }) {
    _uid = uid;
    _name = name;
    _email = email;
    _message = message;
  }

  CustomerSupportModel.fromJson(dynamic json) {
    _uid = json['uid'];
    _name = json['name'];
    _email = json['email'];
    _message = json['message'];
  }

  String? _uid;
  String? _name;
  String? _email;
  String? _message;

  CustomerSupportModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? message,
  }) =>
      CustomerSupportModel(
        uid: uid ?? _uid,
        name: name ?? _name,
        email: email ?? _email,
        message: message ?? _message,
      );

  String? get uid => _uid;

  String? get name => _name;

  String? get email => _email;

  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = _uid;
    map['name'] = _name;
    map['email'] = _email;
    map['message'] = _message;
    return map;
  }
}
