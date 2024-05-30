class FinancialImplicationSSPModel {
  FinancialImplicationSSPModel({
    required this.financialImpSsp,
  });
  late final List<FinancialImpSsp> financialImpSsp;

  FinancialImplicationSSPModel.fromJson(Map<String, dynamic> json){
    financialImpSsp = List.from(json['financial_imp_ssp']).map((e)=>FinancialImpSsp.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['financial_imp_ssp'] = financialImpSsp.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class FinancialImpSsp {
  FinancialImpSsp({
    required this.billNumber,
    required this.cashSpent,
    required this.cashSpentNr,
    required this.creditSold,
    required this.creditSoldDate,
    required this.creditSoldNr,
    required this.creditTo,
    required this.memoRef,
    required this.supportMaintenanceAll,
    required this.supportMaintenanceAnnual,
  });
  late final String billNumber;
  late final double cashSpent;
  late final double cashSpentNr;
  late final double creditSold;
  late final String creditSoldDate;
  late final double creditSoldNr;
  late final double creditTo;
  late final String memoRef;
  late final double supportMaintenanceAll;
  late final double supportMaintenanceAnnual;

  FinancialImpSsp.fromJson(Map<String, dynamic> json){
    billNumber = json['bill_number'];
    cashSpent = json['cash_spent'];
    cashSpentNr = json['cash_spent_nr'];
    creditSold = json['credit_sold'];
    creditSoldDate = json['credit_sold_date'];
    creditSoldNr = json['credit_sold_nr'];
    creditTo = json['credit_to'];
    memoRef = json['memo_ref'];
    supportMaintenanceAll = json['support_maintenance_all'];
    supportMaintenanceAnnual = json['support_maintenance_annual'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['bill_number'] = billNumber;
    _data['cash_spent'] = cashSpent;
    _data['cash_spent_nr'] = cashSpentNr;
    _data['credit_sold'] = creditSold;
    _data['credit_sold_date'] = creditSoldDate;
    _data['credit_sold_nr'] = creditSoldNr;
    _data['credit_to'] = creditTo;
    _data['memo_ref'] = memoRef;
    _data['support_maintenance_all'] = supportMaintenanceAll;
    _data['support_maintenance_annual'] = supportMaintenanceAnnual;
    return _data;
  }
}