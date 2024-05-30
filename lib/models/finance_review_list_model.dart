class FinanceReviewModal {
  FinanceReviewModal({
    required this.financeReviewMemoList,
  });
  late final List<FinanceReviewMemoList> financeReviewMemoList;

  FinanceReviewModal.fromJson(Map<String, dynamic> json){
    financeReviewMemoList = List.from(json['finance_review_memo_list']).map((e)=>FinanceReviewMemoList.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['finance_review_memo_list'] = financeReviewMemoList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class FinanceReviewMemoList {
  FinanceReviewMemoList({
    required this.approvalsRef,
    required this.attachment,
    required this.creator,
    required this.dateCreated,
    required this.id,
    required this.memoStatus,
    required this.memoType,
    required this.refNum,
    this.reviewedBy,
    required this.title,
  });
  late final String approvalsRef;
  late final String attachment;
  late final String creator;
  late final String dateCreated;
  late final int id;
  late final int memoStatus;
  late final MemoType memoType;
  late final String refNum;
  late final String? reviewedBy;
  late final String title;

  FinanceReviewMemoList.fromJson(Map<String, dynamic> json){
    approvalsRef = json['approvals_ref'];
    attachment = json['attachment'];
    creator = json['creator'];
    dateCreated = json['date_created'];
    id = json['id'];
    memoStatus = json['memo_status'];
    memoType = MemoType.fromJson(json['memo_type']);
    refNum = json['ref_num'];
    reviewedBy = null;
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['approvals_ref'] = approvalsRef;
    _data['attachment'] = attachment;
    _data['creator'] = creator;
    _data['date_created'] = dateCreated;
    _data['id'] = id;
    _data['memo_status'] = memoStatus;
    _data['memo_type'] = memoType.toJson();
    _data['ref_num'] = refNum;
    _data['reviewed_by'] = reviewedBy;
    _data['title'] = title;
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