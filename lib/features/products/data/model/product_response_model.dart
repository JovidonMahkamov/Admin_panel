import 'package:admin_panel/features/products/data/model/product_data_model.dart';
import 'package:admin_panel/features/products/domain/entity/product_response_entity.dart';

class ProductResponseModel extends ProductResponseEntity {
  ProductResponseModel({
    required super.message,
    required super.data,
    required super.status,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseModel(
      message: json['message'],
      data: ProductDataModel.fromJson(json['data']),
      status: json['status'],
    );
  }
}