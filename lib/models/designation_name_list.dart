class UserDesignation {
  UserDesignation({
    required this.designationNameList,
    required this.status,
  });
  late final List<DesignationNameList> designationNameList;
  late final String status;

  UserDesignation.fromJson(Map<String, dynamic> json){
    designationNameList = List.from(json['designation_name_list']).map((e)=>DesignationNameList.fromJson(e)).toList();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['designation_name_list'] = designationNameList.map((e)=>e.toJson()).toList();
    _data['status'] = status;
    return _data;
  }
}

class DesignationNameList {
  DesignationNameList({
    required this.designationName,
    required this.id,
  });
  late final String designationName;
  late final int id;

  DesignationNameList.fromJson(Map<String, dynamic> json){
    designationName = json['designation'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['designation'] = designationName;
    _data['id'] = id;
    return _data;
  }
}