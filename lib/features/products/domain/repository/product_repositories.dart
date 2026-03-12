import 'package:admin_panel/features/products/domain/entity/product_entity.dart';

abstract class ProductRepositories {
  Future<List<ProductEntity>> getProducts();
}
