import 'dart:io';
import 'package:admin_panel/features/products/domain/entity/update_product_entity.dart';
import 'package:admin_panel/features/products/domain/repository/product_repositories.dart';

class UpdateProductUseCase {
  final ProductRepositories repository;

  UpdateProductUseCase(this.repository);

  Future<UpdateProductEntity> call({
    required int id,
    required String nomi,
    required String? narxDona,
    required String? narxMetr,
    required String? narxPochka,
    required String? pochka,
    required String? metr,
    required String? miqdor,
    required String? kelganNarx,
    required String? jamiNarx,
    File? rasm,
  })async {
    return await repository.updateProduct(id: id, nomi: nomi, narxDona: narxDona, narxMetr: narxMetr, narxPochka: narxPochka, pochka: pochka, metr: metr, miqdor: miqdor, kelganNarx: kelganNarx, jamiNarx: jamiNarx, rasm: rasm);
  }
}