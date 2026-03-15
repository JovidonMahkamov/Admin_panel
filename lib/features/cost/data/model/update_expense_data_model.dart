import '../../domain/entity/update_expense_entity.dart';

class UpdateExpenseModel extends UpdateExpenseEntity {
  const UpdateExpenseModel({
    required super.message,
    required UpdateExpenseDataModel super.data,
    required super.status,
  });

  factory UpdateExpenseModel.fromJson(Map<String, dynamic> json) {
    return UpdateExpenseModel(
      message: json['message'] ?? '',
      data: UpdateExpenseDataModel.fromJson(json['data'] ?? {}),
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': (data as UpdateExpenseDataModel).toJson(),
      'status': status,
    };
  }
}

class UpdateExpenseDataModel extends UpdateExpenseDataEntity {
  const UpdateExpenseDataModel({
    required super.id,
    required super.tolovTuri,
    required super.ishchiId,
    required super.ishchiFish,
    required super.summa,
    required super.sms,
    required super.izoh,
    required super.sana,
  });

  factory UpdateExpenseDataModel.fromJson(Map<String, dynamic> json) {
    return UpdateExpenseDataModel(
      id: json['id'] ?? 0,
      tolovTuri: json['tolov_turi'] ?? '',
      ishchiId: json['ishchi_id'] ?? 0,
      ishchiFish: json['ishchi_fish'] ?? '',
      summa: json['summa'] ?? 0,
      sms: json['sms'] ?? false,
      izoh: json['izoh'] ?? '',
      sana: json['sana'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tolov_turi': tolovTuri,
      'ishchi_id': ishchiId,
      'ishchi_fish': ishchiFish,
      'summa': summa,
      'sms': sms,
      'izoh': izoh,
      'sana': sana,
    };
  }
}