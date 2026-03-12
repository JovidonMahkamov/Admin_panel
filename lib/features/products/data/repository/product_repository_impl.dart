import 'package:admin_panel/features/products/data/datasource/product_data_source.dart';
import 'package:admin_panel/features/products/domain/entity/product_entity.dart';
import 'package:admin_panel/features/products/domain/repository/product_repositories.dart';

class ProductRepositoryImpl implements ProductRepositories {
  final ProductDataSource remote;

  ProductRepositoryImpl({
    required this.remote,
  });

  @override
  Future<List<ProductEntity>> getProducts() => remote.getProducts();
}