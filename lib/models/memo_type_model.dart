class MemoType {
  MemoType({
    required this.data,
  });
  late final List<Data> data;

  MemoType.fromJson(Map<String, dynamic> json){
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.approverList,
    required this.approverNumber,
    required this.id,
    required this.typeName,
  });
  late final String approverList;
  late final int approverNumber;
  late final int id;
  late final String typeName;

  Data.fromJson(Map<String, dynamic> json){
    approverList = json['approver_list'];
    approverNumber = json['approver_number'];
    id = json['id'];
    typeName = json['type_name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['approver_list'] = approverList;
    _data['approver_number'] = approverNumber;
    _data['id'] = id;
    _data['type_name'] = typeName;
    return _data;
  }
}