import 'package:admin_panel/features/products/domain/entity/product_data_entity.dart';
import 'package:admin_panel/features/products/domain/entity/product_entity.dart';

abstract class GetProductsState {
  const GetProductsState();
}

class GetProductsInitial extends GetProductsState {}

class GetProductsLoading extends GetProductsState {}

class GetProductsSuccess extends GetProductsState {
  final List<ProductEntity> productEntity;
  final ProductDataEntity productData;

  const GetProductsSuccess({
    required this.productEntity,
    required this.productData,
  });
}

class GetProductsError extends GetProductsState {
  final String message;

  const GetProductsError({required this.message});
}