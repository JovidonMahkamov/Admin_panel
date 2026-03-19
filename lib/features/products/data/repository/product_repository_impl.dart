import 'dart:io';

import 'package:admin_panel/features/products/data/datasource/product_data_source.dart';
import 'package:admin_panel/features/products/domain/entity/create_product_params.dart';
import 'package:admin_panel/features/products/domain/entity/delete_product_entity.dart';
import 'package:admin_panel/features/products/domain/entity/product_entity.dart';
import 'package:admin_panel/features/products/domain/entity/product_response_entity.dart';
import 'package:admin_panel/features/products/domain/entity/update_product_entity.dart';
import 'package:admin_panel/features/products/domain/repository/product_repositories.dart';

class ProductRepositoryImpl implements ProductRepositories {
  final ProductDataSource remote;

  ProductRepositoryImpl({required this.remote});

  @override
  Future<ProductResponseEntity> getProducts() => remote.getProducts();

  @override
  Future<ProductEntity> createProduct({required CreateProductParams create}) async {
    final response = await remote.createProduct(create: create);
    return response.data;
  }

  @override
  Future<DeleteProductEntity> deleteProduct({required int id}) async {
    return await remote.deleteProduct(id: id);
  }

  @override
  Future<UpdateProductEntity> updateProduct({
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
  }) {
    return remote.updateProduct(
      id: id,
      nomi: nomi,
      narxDona: narxDona,
      narxMetr: narxMetr,
      narxPochka: narxPochka,
      pochka: pochka,
      metr: metr,
      miqdor: miqdor,
      kelganNarx: kelganNarx,
      jamiNarx: jamiNarx,
      rasm: rasm,
    );
  }
}