import 'package:admin_panel/features/cost/domain/entity/expense_entity.dart';
class ExpenseModel extends ExpenseEntity {
  const ExpenseModel({
    required super.id,
    required super.tolovTuri,
    required super.ishchiIdField,
    required super.summa,
    required super.sms,
    required super.izoh,
    required super.sana,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] ?? 0,
      tolovTuri: json['tolov_turi'] ?? '',
      ishchiIdField: json['ishchi_id_field'] ?? '',
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
      'ishchi_id_field': ishchiIdField,
      'summa': summa,
      'sms': sms,
      'izoh': izoh,
      'sana': sana,
    };
  }
}