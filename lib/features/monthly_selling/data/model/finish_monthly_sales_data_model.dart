import '../../domain/entity/finish_monthly_sales_entity.dart';

class FinishMonthlySalesModel extends FinishMonthlySalesEntity {
  const FinishMonthlySalesModel({
    required super.message,
    required FinishMonthlySalesDataModel super.data,
    required super.status,
  });

  factory FinishMonthlySalesModel.fromJson(Map<String, dynamic> json) {
    return FinishMonthlySalesModel(
      message: json['message'] ?? '',
      data: FinishMonthlySalesDataModel.fromJson(json['data'] ?? {}),
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': (data as FinishMonthlySalesDataModel).toJson(),
      'status': status,
    };
  }
}

class FinishMonthlySalesDataModel extends FinishMonthlySalesDataEntity {
  const FinishMonthlySalesDataModel({
    required super.yakunlanganSoni,
    required super.yil,
    required super.oy,
  });

  factory FinishMonthlySalesDataModel.fromJson(Map<String, dynamic> json) {
    return FinishMonthlySalesDataModel(
      yakunlanganSoni: json['yakunlangan_soni'] ?? 0,
      yil: json['yil'] ?? 0,
      oy: json['oy'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'yakunlangan_soni': yakunlanganSoni,
      'yil': yil,
      'oy': oy,
    };
  }
}