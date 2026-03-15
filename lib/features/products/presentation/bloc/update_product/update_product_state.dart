import 'package:admin_panel/features/products/domain/entity/update_product_entity.dart';

abstract class UpdateProductState {
  const UpdateProductState();
}

class UpdateProductInitial extends UpdateProductState {}

class UpdateProductLoading extends UpdateProductState {}

class UpdateProductSuccess extends UpdateProductState {
  final UpdateProductEntity updateProductEntity;

  const UpdateProductSuccess({required this.updateProductEntity});
}

class UpdateProductError extends UpdateProductState {
  final String message;

  const UpdateProductError({required this.message});
}
