class RequestListView {
  RequestListView({
    required this.requestList,
  });
  late final List<RequestList> requestList;

  RequestListView.fromJson(Map<String, dynamic> json){
    requestList = List.from(json['request_list']).map((e)=>RequestList.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['request_list'] = requestList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class RequestList {
  RequestList({
    required this.userName,
    required this.userEmail,
    required this.projectName,
    required this.changeName,
    required this.dateRequested,
    required this.vendorInCharge,
    required this.changeDescription,
    required this.changeReason,
    required this.priority,
    required this.changeImpact,
    required this.fileNames,
  });
  late final String userName;
  late final String userEmail;
  late final String projectName;
  late final String changeName;
  late final String dateRequested;
  late final String vendorInCharge;
  late final String changeDescription;
  late final String changeReason;
  late final String priority;
  late final String changeImpact;
  late final String fileNames;

  RequestList.fromJson(Map<String, dynamic> json){
    userName = json['user_name'];
    userEmail = json['user_email'];
    projectName = json['project_name'];
    changeName = json['change_name'];
    dateRequested = json['date_requested'];
    vendorInCharge = json['vendor_in_charge'];
    changeDescription = json['change_description'];
    changeReason = json['change_reason'];
    priority = json['priority'];
    changeImpact = json['change_impact'];
    fileNames = json['file_names'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user_name'] = userName;
    _data['user_email'] = userEmail;
    _data['project_name'] = projectName;
    _data['change_name'] = changeName;
    _data['date_requested'] = dateRequested;
    _data['vendor_in_charge'] = vendorInCharge;
    _data['change_description'] = changeDescription;
    _data['change_reason'] = changeReason;
    _data['priority'] = priority;
    _data['change_impact'] = changeImpact;
    _data['file_names'] = fileNames;
    return _data;
  }
}

