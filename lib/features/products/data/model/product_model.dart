import '../../domain/entity/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
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
    super.qrKod,
    required super.yaratilgan,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      nomi: json['nomi'] ?? '',
      narxDona: json['narx_dona']?.toString(),
      narxMetr: json['narx_metr']?.toString(),
      narxPochka: json['narx_pochka']?.toString(),
      pochka: json['pochka']?.toString(),
      metr: json['metr']?.toString(),
      miqdor: json['miqdor']?.toString(),
      kelganNarx: json['kelgan_narx']?.toString(),
      jamiNarx: json['jami_narx']?.toString(),
      rasm: json['rasm']?.toString(),
      qrKod: json['qr_kod']?.toString(),
      yaratilgan: DateTime.tryParse(json['yaratilgan'] ?? '') ?? DateTime.now(),
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
      'yaratilgan': yaratilgan.toIso8601String(),
    };
  }
}