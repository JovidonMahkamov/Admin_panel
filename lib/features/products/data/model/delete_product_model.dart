import '../../domain/entity/delete_product_entity.dart';

class DeleteProductModel extends DeleteProductEntity {
  const DeleteProductModel({
    required super.message,
    required super.data,
    required super.status,
  });

  factory DeleteProductModel.fromJson(Map<String, dynamic> json) {
    return DeleteProductModel(
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