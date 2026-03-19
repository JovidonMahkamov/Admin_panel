import 'dart:io';
import 'package:admin_panel/features/products/data/model/create_product_response_model.dart';
import 'package:admin_panel/features/products/data/model/delete_product_model.dart';
import 'package:admin_panel/features/products/data/model/product_response_model.dart';
import 'package:admin_panel/features/products/data/model/update_product_model.dart';
import 'package:admin_panel/features/products/domain/entity/create_product_params.dart';

abstract class ProductDataSource {
  Future<ProductResponseModel> getProducts();

  Future<CreateProductResponseModel> createProduct({
    required CreateProductParams create,
  });

  Future<DeleteProductModel> deleteProduct({required int id});

  Future<UpdateProductModel> updateProduct({
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