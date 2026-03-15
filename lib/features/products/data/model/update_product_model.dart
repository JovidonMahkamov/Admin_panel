import '../../domain/entity/update_product_entity.dart';

class UpdateProductModel extends UpdateProductEntity {
  const UpdateProductModel({
    required super.message,
    required UpdateProductDataModel super.data,
    required super.status,
  });

  factory UpdateProductModel.fromJson(Map<String, dynamic> json) {
    return UpdateProductModel(
      message: json['message'] ?? '',
      data: UpdateProductDataModel.fromJson(json['data'] ?? {}),
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': (data as UpdateProductDataModel).toJson(),
      'status': status,
    };
  }
}

class UpdateProductDataModel extends UpdateProductDataEntity {
  const UpdateProductDataModel({
    required super.id,
    required super.nomi,
    required super.narxDona,
    required super.narxMetr,
    required super.narxPochka,
    required super.pochka,
    required super.metr,
    required super.miqdor,
    required super.kelganNarx,
    required super.jamiNarx,
    required super.rasm,
    required super.qrKod,
    required super.aktiv,
    required super.yaratilgan,
  });

  factory UpdateProductDataModel.fromJson(Map<String, dynamic> json) {
    return UpdateProductDataModel(
      id: json['id'] ?? 0,
      nomi: json['nomi'] ?? '',
      narxDona: json['narx_dona'],
      narxMetr: json['narx_metr'],
      narxPochka: json['narx_pochka'],
      pochka: json['pochka'],
      metr: json['metr'],
      miqdor: json['miqdor'],
      kelganNarx: json['kelgan_narx'],
      jamiNarx: json['jami_narx'],
      rasm: json['rasm'],
      qrKod: json['qr_kod'] ?? '',
      aktiv: json['aktiv'] ?? false,
      yaratilgan: json['yaratilgan'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomi': nomi,
      'narx_dona': narxDona,
      'narx_metr': narxMetr,
      'narx_pochka': narxPochka,
      'pochka': pochka,
      'metr': metr,
      'miqdor': miqdor,
      'kelgan_narx': kelganNarx,
      'jami_narx': jamiNarx,
      'rasm': rasm,
      'qr_kod': qrKod,
      'aktiv': aktiv,
      'yaratilgan': yaratilgan,
    };
  }
}