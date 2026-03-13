import 'dart:io';

import 'package:admin_panel/features/products/domain/entity/create_product_params.dart';
import 'package:admin_panel/features/products/domain/entity/delete_product_entity.dart';
import 'package:admin_panel/features/products/domain/entity/product_entity.dart';

abstract class ProductRepositories {
  Future<List<ProductEntity>> getProducts();

  Future<ProductEntity> createProduct({ required CreateProductParams create});
  Future<DeleteProductEntity> deleteProduct({required int id});
}
