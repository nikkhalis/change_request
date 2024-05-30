class UserRole {
  UserRole({
    required this.status,
    required this.userRoleList,
  });
  late final String status;
  late final List<UserRoleList> userRoleList;

  UserRole.fromJson(Map<String, dynamic> json){
    status = json['status'];
    userRoleList = List.from(json['user_role_list']).map((e)=>UserRoleList.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['user_role_list'] = userRoleList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class UserRoleList {
  UserRoleList({
    required this.id,
    required this.role,
  });
  late final int id;
  late final String role;

  UserRoleList.fromJson(Map<String, dynamic> json){
    id = json['id'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['role'] = role;
    return _data;
  }
}