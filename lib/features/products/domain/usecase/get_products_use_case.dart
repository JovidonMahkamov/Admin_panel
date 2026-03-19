import 'package:admin_panel/features/products/domain/entity/product_response_entity.dart';
import 'package:admin_panel/features/products/domain/repository/product_repositories.dart';

class GetProductUseCase {
  final ProductRepositories repository;

  GetProductUseCase(this.repository);

  Future<ProductResponseEntity> call() async {
    return await repository.getProducts();
  }
}