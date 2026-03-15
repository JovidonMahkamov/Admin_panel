import '../../domain/entity/update_cash_expense_entity.dart';

class UpdateCashExpenseModel extends UpdateCashExpenseEntity {
  const UpdateCashExpenseModel({
    required super.message,
    required UpdateCashExpenseDataModel super.data,
    required super.status,
  });

  factory UpdateCashExpenseModel.fromJson(Map<String, dynamic> json) {
    return UpdateCashExpenseModel(
      message: json['message'] ?? '',
      data: UpdateCashExpenseDataModel.fromJson(json['data'] ?? {}),
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': (data as UpdateCashExpenseDataModel).toJson(),
      'status': status,
    };
  }
}

class UpdateCashExpenseDataModel extends UpdateCashExpenseDataEntity {
  const UpdateCashExpenseDataModel({
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

  factory UpdateCashExpenseDataModel.fromJson(Map<String, dynamic> json) {
    return UpdateCashExpenseDataModel(
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