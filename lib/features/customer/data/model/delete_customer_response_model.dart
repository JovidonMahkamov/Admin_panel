import 'package:admin_panel/features/customer/domain/entity/delete_customer_response_entity.dart';

class DeleteCustomerResponseModel extends DeleteCustomerResponseEntity {
  const DeleteCustomerResponseModel({
    required super.message,
    required super.data,
    required super.status,
  });

  factory DeleteCustomerResponseModel.fromJson(Map<String, dynamic> json) {
    return DeleteCustomerResponseModel(
      message: json['message'] ?? '',
      data: json['data'],
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data,
      'status': status,
    };
  }
}