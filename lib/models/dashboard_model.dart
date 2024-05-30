class DashboardModel {
  DashboardModel({
    required this.memoDetails,
    required this.recentMemo,
  });
  late final List<MemoDetails> memoDetails;
  late final List<RecentMemo> recentMemo;

  DashboardModel.fromJson(Map<String, dynamic> json){
    memoDetails = List.from(json['memo_details']).map((e)=>MemoDetails.fromJson(e)).toList();
    recentMemo = List.from(json['recent_memo']).map((e)=>RecentMemo.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['memo_details'] = memoDetails.map((e)=>e.toJson()).toList();
    _data['recent_memo'] = recentMemo.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class MemoDetails {
  MemoDetails({
    required this.frequency,
    required this.memoType,
    required this.typeName,
  });
  late final int frequency;
  late final int memoType;
  late final String typeName;

  MemoDetails.fromJson(Map<String, dynamic> json){
    frequency = json['frequency'];
    memoType = json['memo_type'];
    typeName = json['type_name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['frequency'] = frequency;
    _data['memo_type'] = memoType;
    _data['type_name'] = typeName;
    return _data;
  }
}

class RecentMemo {
  RecentMemo({
    required this.dateCreated,
    required this.id,
    required this.title,
    required this.typeName,
  });
  late final String dateCreated;
  late final int id;
  late final String title;
  late final String typeName;

  RecentMemo.fromJson(Map<String, dynamic> json){
    dateCreated = json['date_created'];
    id = json['id'];
    title = json['title'];
    typeName = json['type_name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['date_created'] = dateCreated;
    _data['id'] = id;
    _data['title'] = title;
    _data['type_name'] = typeName;
    return _data;
  }
}