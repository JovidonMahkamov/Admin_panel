import '../../domain/entity/create_customer_response_entity.dart';
import 'get_customer_model.dart';

class CreateCustomerResponseModel extends CreateCustomerResponseEntity {
  const CreateCustomerResponseModel({
    required super.message,
    required GetCustomerModel super.data,
    required super.status,
  });

  factory CreateCustomerResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateCustomerResponseModel(
      message: json['message'] ?? '',
      data: GetCustomerModel.fromJson(json['data'] as Map<String, dynamic>),
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': {
        'id': data.id,
        'fish': data.fish,
        'telefon': data.telefon,
        'manzil': data.manzil,
        'qarzdorlik': data.qarzdorlik,
        'rasm': data.rasm,
        'yaratilgan': data.yaratilgan.toIso8601String(),
      },
      'status': status,
    };
  }
}