import 'package:admin_panel/features/products/domain/entity/create_product_params.dart';

abstract class ProductsEvent {
  const ProductsEvent();
}

class GetProductsE extends ProductsEvent {
  const GetProductsE();
}

class CreateProductE extends ProductsEvent {
  final CreateProductParams create;
  CreateProductE({
    required this.create,

  });
}
class DeleteProductE extends ProductsEvent {
  final int id;

  const DeleteProductE({required this.id});}