import '../model/product_model.dart';

abstract class ProductDataSource {
  Future<List<ProductModel>> getProducts();
}