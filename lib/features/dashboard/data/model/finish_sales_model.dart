import '../../domain/entity/finish_sales_entity.dart';

class FinishSalesModel extends FinishSalesEntity {
  const FinishSalesModel({
    required super.message,
    required FinishSalesDataModel super.data,
    required super.status,
  });

  factory FinishSalesModel.fromJson(Map<String, dynamic> json) {
    return FinishSalesModel(
      message: json['message'] ?? '',
      data: FinishSalesDataModel.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
      status: json['status'] ?? 0,
    );
  }
}

class FinishSalesDataModel extends FinishSalesDataEntity {
  const FinishSalesDataModel({
    required super.yakunlanganSoni,
  });

  factory FinishSalesDataModel.fromJson(Map<String, dynamic> json) {
    return FinishSalesDataModel(
      yakunlanganSoni: _toInt(json['yakunlangan_soni']),
    );
  }
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}