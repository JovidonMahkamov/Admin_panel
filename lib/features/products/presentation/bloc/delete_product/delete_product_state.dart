
import 'package:admin_panel/features/products/domain/entity/delete_product_entity.dart';

abstract class DeleteProductState {
  const DeleteProductState();
}

class DeleteProductInitial extends DeleteProductState {
  const DeleteProductInitial();
}

class DeleteProductLoading extends DeleteProductState {
  const DeleteProductLoading();
}

class DeleteProductSuccess extends DeleteProductState {
  final DeleteProductEntity response;

  const DeleteProductSuccess(this.response);
}

class DeleteProductError extends DeleteProductState {
  final String message;

  const DeleteProductError(this.message);
}