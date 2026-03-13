import 'package:admin_panel/features/products/data/model/create_product_response_model.dart';
import 'package:admin_panel/features/products/data/model/delete_product_model.dart';
import 'package:admin_panel/features/products/domain/entity/create_product_params.dart';

import '../model/product_model.dart';

abstract class ProductDataSource {
  Future<List<ProductModel>> getProducts();

  Future<CreateProductResponseModel> createProduct({
    required CreateProductParams create,
  });
  Future<DeleteProductModel> deleteProduct({required int id});
}