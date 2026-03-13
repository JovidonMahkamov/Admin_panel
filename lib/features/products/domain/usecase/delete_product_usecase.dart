import 'package:admin_panel/features/products/domain/repository/product_repositories.dart';

import '../entity/delete_product_entity.dart';

class DeleteProductUseCase {
  final ProductRepositories repository;

  DeleteProductUseCase(this.repository);

  Future<DeleteProductEntity> call({required int id}) async {
    return await repository.deleteProduct(id:id);
  }
}