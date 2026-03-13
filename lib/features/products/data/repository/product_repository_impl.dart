import 'package:admin_panel/features/products/data/datasource/product_data_source.dart';
import 'package:admin_panel/features/products/domain/entity/create_product_params.dart';
import 'package:admin_panel/features/products/domain/entity/delete_product_entity.dart';
import 'package:admin_panel/features/products/domain/entity/product_entity.dart';
import 'package:admin_panel/features/products/domain/repository/product_repositories.dart';

class ProductRepositoryImpl implements ProductRepositories {
  final ProductDataSource remote;

  ProductRepositoryImpl({required this.remote});

  @override
  Future<List<ProductEntity>> getProducts() => remote.getProducts();

  @override
  Future<ProductEntity> createProduct({required CreateProductParams create}) async {
    final response = await remote.createProduct(create: create);
    return response.data;
  }
  @override
  Future<DeleteProductEntity> deleteProduct({ required int id}) async {
    final result = await remote.deleteProduct(id:id);
    return result;
  }
}