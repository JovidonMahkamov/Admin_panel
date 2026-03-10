import '../../domain/entity/get_all_customers_entity.dart';
import 'get_customer_model.dart';

class GetAllCustomersModel extends GetAllCustomersEntity {
  const GetAllCustomersModel({
    required super.message,
    required List<GetCustomerModel> super.data,
    required super.status,
  });

  factory GetAllCustomersModel.fromJson(Map<String, dynamic> json) {
    return GetAllCustomersModel(
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => GetCustomerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((e) {
        if (e is GetCustomerModel) {
          return e.toJson();
        }
        return {
          'id': e.id,
          'fish': e.fish,
          'telefon': e.telefon,
          'manzil': e.manzil,
          'qarzdorlik': e.qarzdorlik,
          'rasm': e.rasm,
          'yaratilgan': e.yaratilgan.toIso8601String(),
        };
      }).toList(),
      'status': status,
    };
  }
}