import '../../domain/entity/cost_entity.dart';

class CostModel extends CostEntity {
  const CostModel({
    required super.message,
    required List<CostItemModel> super.data,
    required super.status,
  });

  factory CostModel.fromJson(Map<String, dynamic> json) {
    return CostModel(
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => CostItemModel.fromJson(e))
          .toList(),
      status: json['status'] ?? 0,
    );
  }
}

class CostItemModel extends CostItemEntity {
  const CostItemModel({
    required super.id,
    required super.tolovTuri,
    required super.ishchiIdField,
    required super.summa,
    required super.sms,
    required super.izoh,
    required super.sana,
  });

  factory CostItemModel.fromJson(Map<String, dynamic> json) {
    return CostItemModel(
      id: json['id'] ?? 0,
      tolovTuri: json['tolov_turi'] ?? '',
      ishchiIdField: json['ishchi_id_field']?.toString() ?? '',
      summa: json['summa'] ?? 0,
      sms: json['sms'] ?? false,
      izoh: json['izoh'] ?? '',
      sana: json['sana'] ?? '',
    );
  }
}