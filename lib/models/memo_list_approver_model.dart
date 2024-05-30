class MemoListApproverView {
  MemoListApproverView({
    required this.memoList,
  });
  late final List<MemoList> memoList;

  MemoListApproverView.fromJson(Map<String, dynamic> json){
    memoList = List.from(json['memo_list']).map((e)=>MemoList.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['memo_list'] = memoList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class MemoList {
  MemoList({
    required this.approvalsRef,
    required this.approverList,
    required this.attachment,
    required this.creator,
    required this.dateCreated,
    required this.id,
    required this.memoStatus,
    required this.memoStatusId,
    required this.memoType,
    required this.pendingApproval,
    required this.refNum,
    required this.title,
  });
  late final String approvalsRef;
  late final List<ApproverList> approverList;
  late final String attachment;
  late final Creator creator;
  late final String dateCreated;
  late final int id;
  late final String memoStatus;
  late final int memoStatusId;
  late final MemoType memoType;
  late final int pendingApproval;
  late final String refNum;
  late final String title;

  MemoList.fromJson(Map<String, dynamic> json){
    approvalsRef = json['approvals_ref'];
    approverList = List.from(json['approver_list']).map((e)=>ApproverList.fromJson(e)).toList();
    attachment = json['attachment'];
    creator = Creator.fromJson(json['creator']);
    dateCreated = json['date_created'];
    id = json['id'];
    memoStatus = json['memo_status'];
    memoStatusId = json['memo_status_id'];
    memoType = MemoType.fromJson(json['memo_type']);
    pendingApproval = json['pending_approval'];
    refNum = json['ref_num'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['approvals_ref'] = approvalsRef;
    _data['approver_list'] = approverList.map((e)=>e.toJson()).toList();
    _data['attachment'] = attachment;
    _data['creator'] = creator.toJson();
    _data['date_created'] = dateCreated;
    _data['id'] = id;
    _data['memo_status'] = memoStatus;
    _data['memo_status_id'] = memoStatusId;
    _data['memo_type'] = memoType.toJson();
    _data['pending_approval'] = pendingApproval;
    _data['ref_num'] = refNum;
    _data['title'] = title;
    return _data;
  }
}

class ApproverList {
  ApproverList({
    required this.approved,
    required this.approverDesignation,
    required this.approverName,
    this.dateApproved,
    required this.id,
    required this.typeName,
    required this.userType,
  });
  late final int approved;
  late final String approverDesignation;
  late final String approverName;
  late final Null dateApproved;
  late final int id;
  late final String typeName;
  late final int userType;

  ApproverList.fromJson(Map<String, dynamic> json){
    approved = json['approved'];
    approverDesignation = json['approver_designation'];
    approverName = json['approver_name'];
    dateApproved = null;
    id = json['id'];
    typeName = json['type_name'];
    userType = json['user_type'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['approved'] = approved;
    _data['approver_designation'] = approverDesignation;
    _data['approver_name'] = approverName;
    _data['date_approved'] = dateApproved;
    _data['id'] = id;
    _data['type_name'] = typeName;
    _data['user_type'] = userType;
    return _data;
  }
}

class Creator {
  Creator({
    required this.designation,
    required this.id,
    required this.name,
  });
  late final String designation;
  late final int id;
  late final String name;

  Creator.fromJson(Map<String, dynamic> json){
    designation = json['designation'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['designation'] = designation;
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}

class MemoType {
  MemoType({
    required this.id,
    required this.name,
  });
  late final int id;
  late final String name;

  MemoType.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}