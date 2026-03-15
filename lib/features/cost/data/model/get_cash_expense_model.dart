import '../../domain/entity/get_cash_expense_entity.dart';

class GetCashExpenseModel extends GetCashExpenseEntity {
  const GetCashExpenseModel({
    required super.message,
    required List<GetCashExpenseDataModel> super.data,
    required super.status,
  });

  factory GetCashExpenseModel.fromJson(Map<String, dynamic> json) {
    return GetCashExpenseModel(
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => GetCashExpenseDataModel.fromJson(e))
          .toList(),
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data
          .map((e) => (e as GetCashExpenseDataModel).toJson())
          .toList(),
      'status': status,
    };
  }
}

class GetCashExpenseDataModel extends GetCashExpenseDataEntity {
  const GetCashExpenseDataModel({
    required super.id,
    required super.tolovTuri,
    required super.doKon,
    required super.mahsulotNomi,
    required super.summa,
    required super.valyuta,
    required super.sms,
    required super.izoh,
    required super.sana,
  });

  factory GetCashExpenseDataModel.fromJson(Map<String, dynamic> json) {
    return GetCashExpenseDataModel(
      id: json['id'] ?? 0,
      tolovTuri: json['tolov_turi'] ?? '',
      doKon: json['do_kon'] ?? '',
      mahsulotNomi: json['mahsulot_nomi'] ?? '',
      summa: json['summa'] ?? 0,
      valyuta: json['valyuta'] ?? '',
      sms: json['sms'] ?? false,
      izoh: json['izoh'] ?? '',
      sana: json['sana'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tolov_turi': tolovTuri,
      'do_kon': doKon,
      'mahsulot_nomi': mahsulotNomi,
      'summa': summa,
      'valyuta': valyuta,
      'sms': sms,
      'izoh': izoh,
      'sana': sana,
    };
  }
}