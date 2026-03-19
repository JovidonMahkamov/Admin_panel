import 'dart:io';

import 'package:admin_panel/features/products/domain/entity/create_product_params.dart';
import 'package:admin_panel/features/products/domain/entity/delete_product_entity.dart';
import 'package:admin_panel/features/products/domain/entity/product_entity.dart';
import 'package:admin_panel/features/products/domain/entity/product_response_entity.dart';
import 'package:admin_panel/features/products/domain/entity/update_product_entity.dart';

abstract class ProductRepositories {
  Future<ProductResponseEntity> getProducts();

  Future<ProductEntity> createProduct({required CreateProductParams create});

  Future<DeleteProductEntity> deleteProduct({required int id});

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
  });
}