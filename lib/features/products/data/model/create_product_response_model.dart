import 'product_model.dart';

class CreateProductResponseModel {
  final String message;
  final ProductModel data;
  final int status;

  const CreateProductResponseModel({
    required this.message,
    required this.data,
    required this.status,
  });

  factory CreateProductResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateProductResponseModel(
      message: json['message'] ?? '',
      data: ProductModel.fromJson(json['data'] ?? {}),
      status: json['status'] ?? 0,
    );
  }
}