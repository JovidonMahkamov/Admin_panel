import 'dart:io';

import 'package:admin_panel/features/products/domain/entity/create_product_params.dart';

abstract class ProductsEvent {
  const ProductsEvent();
}

class GetProductsE extends ProductsEvent {
  const GetProductsE();
}

class CreateProductE extends ProductsEvent {
  final CreateProductParams create;

  CreateProductE({required this.create});
}

class DeleteProductE extends ProductsEvent {
  final int id;

  const DeleteProductE({required this.id});
}

class UpdateProductE extends ProductsEvent {
  final int id;
  final String nomi;
  final String? narxDona;
  final String? narxMetr;
  final String? narxPochka;
  final String? pochka;
  final String? metr;
  final String? miqdor;
  final String? kelganNarx;
  final String? jamiNarx;
  final File? rasm;

  const UpdateProductE({
    required this.id,
    required this.nomi,
    this.narxDona,
    this.narxMetr,
    this.narxPochka,
    this.pochka,
    this.metr,
    this.miqdor,
    this.kelganNarx,
    this.jamiNarx,
    this.rasm,
  });
}
