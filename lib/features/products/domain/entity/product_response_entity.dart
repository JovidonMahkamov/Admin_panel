import 'package:admin_panel/features/products/domain/entity/product_data_entity.dart';

class ProductResponseEntity {
  final String message;
  final ProductDataEntity data;
  final int status;

  ProductResponseEntity({
    required this.message,
    required this.data,
    required this.status,
  });
}