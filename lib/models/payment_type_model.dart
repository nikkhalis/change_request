class PaymentTypeList {
  PaymentTypeList({
    required this.paymentType,
  });
  late final List<PaymentType> paymentType;

  PaymentTypeList.fromJson(Map<String, dynamic> json){
    paymentType = List.from(json['payment_type']).map((e)=>PaymentType.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['payment_type'] = paymentType.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class PaymentType {
  PaymentType({
    required this.id,
    required this.paymentName,
  });
  late final int id;
  late final String paymentName;

  PaymentType.fromJson(Map<String, dynamic> json){
    id = json['id'];
    paymentName = json['payment_name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['payment_name'] = paymentName;
    return _data;
  }
}