import 'package:admin_panel/features/products/domain/entity/product_entity.dart';

abstract class GetProductsState {
  const GetProductsState();
}

class GetProductsInitial extends GetProductsState {}

class GetProductsLoading extends GetProductsState {}

class GetProductsSuccess extends GetProductsState {
  final List<ProductEntity> productEntity;

  const GetProductsSuccess({required this.productEntity});
}

class GetProductsError extends GetProductsState {
  final String message;

  const GetProductsError({required this.message});
}
