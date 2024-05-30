class UserData {
  UserData({
    required this.status,
    required this.user,
  });
  late final String status;
  late final List<User> user;

  UserData.fromJson(Map<String, dynamic> json){
    status = json['status'];
    user = List.from(json['user']).map((e)=>User.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['user'] = user.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class User {
  User({
    required this.designation,
    required this.email,
    required this.name,
    required this.phoneNum,
    required this.role,
    required this.usersId,
  });
  late final String designation;
  late final String email;
  late final String name;
  late final String phoneNum;
  late final String role;
  late final int usersId;

  User.fromJson(Map<String, dynamic> json){
    designation = json['designation'];
    email = json['email'];
    name = json['name'];
    phoneNum = json['phoneNum'];
    role = json['role'];
    usersId = json['users_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['designation'] = designation;
    _data['email'] = email;
    _data['name'] = name;
    _data['phoneNum'] = phoneNum;
    _data['role'] = role;
    _data['users_id'] = usersId;
    return _data;
  }
}