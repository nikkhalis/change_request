class UserListView {
  UserListView({
    required this.status,
    required this.userList,
  });
  late final String status;
  late final List<UserList> userList;

  UserListView.fromJson(Map<String, dynamic> json){
    status = json['status'];
    userList = List.from(json['user_list']).map((e)=>UserList.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['user_list'] = userList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class UserList {
  UserList({
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
  late final int phoneNum;
  late final String role;
  late final int usersId;

  UserList.fromJson(Map<String, dynamic> json){
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