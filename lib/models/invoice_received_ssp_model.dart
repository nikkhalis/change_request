class InvoiceReceivedSSPModel {
  InvoiceReceivedSSPModel({
    required this.invoiceRecieved,
  });
  late final List<InvoiceRecieved> invoiceRecieved;

  InvoiceReceivedSSPModel.fromJson(Map<String, dynamic> json){
    invoiceRecieved = List.from(json['invoice_recieved']).map((e)=>InvoiceRecieved.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['invoice_recieved'] = invoiceRecieved.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class InvoiceRecieved {
  InvoiceRecieved({
    required this.item,
    required this.memoRef,
    required this.paymentTo,
    required this.totalAmount,
    required this.type,
  });
  late final String item;
  late final String memoRef;
  late final String paymentTo;
  late final double totalAmount;
  late final String type;

  InvoiceRecieved.fromJson(Map<String, dynamic> json){
    item = json['item'];
    memoRef = json['memo_ref'];
    paymentTo = json['payment_to'];
    totalAmount = json['total_amount'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['item'] = item;
    _data['memo_ref'] = memoRef;
    _data['payment_to'] = paymentTo;
    _data['total_amount'] = totalAmount;
    _data['type'] = type;
    return _data;
  }
}