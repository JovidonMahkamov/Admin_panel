import '../../domain/entity/create_cash_expense_entity.dart';

class CreateCashExpenseModel extends CreateCashExpenseEntity {
  const CreateCashExpenseModel({
    required super.message,
    required CreateCashExpenseDataModel super.data,
    required super.status,
  });

  factory CreateCashExpenseModel.fromJson(Map<String, dynamic> json) {
    return CreateCashExpenseModel(
      message: json['message'] ?? '',
      data: CreateCashExpenseDataModel.fromJson(json['data'] ?? {}),
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': (data as CreateCashExpenseDataModel).toJson(),
      'status': status,
    };
  }
}

class CreateCashExpenseDataModel extends CreateCashExpenseDataEntity {
  const CreateCashExpenseDataModel({
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

  factory CreateCashExpenseDataModel.fromJson(Map<String, dynamic> json) {
    return CreateCashExpenseDataModel(
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