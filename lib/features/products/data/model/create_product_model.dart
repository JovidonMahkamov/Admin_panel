import 'dart:io';

import '../../domain/entity/create_product_params.dart';

class CreateProductModel extends CreateProductParams {
  const CreateProductModel({
    required super.nomi,
    super.narxDona,
    super.narxMetr,
    super.narxPochka,
    super.pochka,
    super.metr,
    super.miqdor,
    super.kelganNarx,
    super.jamiNarx,
    super.rasm,
  });

  Map<String, dynamic> toJson() {
    return {
      'nomi': nomi,
      'narx_dona': narxDona,
      'narx_metr': narxMetr,
      'narx_pochka': narxPochka,
      'pochka': pochka,
      'metr': metr,
      'miqdor': miqdor,
      'kelgan_narx': kelganNarx,
      'jami_narx': jamiNarx,
    };
  }

  File? get imageFile => rasm;
}