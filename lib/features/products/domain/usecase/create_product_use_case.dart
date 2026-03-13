import 'package:admin_panel/features/products/domain/entity/create_product_params.dart';
import 'package:admin_panel/features/products/domain/entity/product_entity.dart';
import 'package:admin_panel/features/products/domain/repository/product_repositories.dart';

class CreateProductUseCase {
  final ProductRepositories repository;

  CreateProductUseCase(this.repository);

  Future<ProductEntity> call({
    required CreateProductParams create
  }) async {
    return await repository.createProduct(create: create);
  }
}
