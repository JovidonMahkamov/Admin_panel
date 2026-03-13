import 'package:admin_panel/features/products/domain/entity/product_entity.dart';

abstract class CreateProductState {
  const CreateProductState();
}

class CreateProductInitial extends CreateProductState {}

class CreateProductLoading extends CreateProductState {}

class CreateProductSuccess extends CreateProductState {
  final ProductEntity productEntity;

  const CreateProductSuccess({required this.productEntity});
}

class CreateProductError extends CreateProductState {
  final String message;

  const CreateProductError({required this.message});
}
