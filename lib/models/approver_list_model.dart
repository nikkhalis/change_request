class ApproverList {
  ApproverList({
    required this.approver,
  });
  late final List<Approver> approver;

  ApproverList.fromJson(Map<String, dynamic> json){
    approver = List.from(json['approver']).map((e)=>Approver.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['approver'] = approver.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Approver {
  Approver({
    required this.email,
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.userType,
  });
  late final String email;
  late final int id;
  late final String name;
  late final int phoneNumber;
  late final int userType;

  Approver.fromJson(Map<String, dynamic> json){
    email = json['email'];
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    userType = json['user_type'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['email'] = email;
    _data['id'] = id;
    _data['name'] = name;
    _data['phone_number'] = phoneNumber;
    _data['user_type'] = userType;
    return _data;
  }
}