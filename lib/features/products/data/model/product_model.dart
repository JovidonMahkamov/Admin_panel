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
    super.sotishNarxMetr,
    super.rasm,
    super.qrKod,
    super.sotildi,
    super.sotilganMetr,
    super.sotilganMiqdor,
    super.sotilganPochka,
    required super.yaratilgan,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      sotilganMiqdor: (json['sotilgan_miqdor'] as num? ?? 0).toInt(),
      sotilganPochka: (json['sotilgan_pochka'] as num? ?? 0).toInt(),
      sotilganMetr: (json['sotilgan_metr'] as num? ?? 0).toDouble(),
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
      sotishNarxMetr: json['sotish_narx_metr']?.toString(),
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
      'sotish_narx_metr': sotishNarxMetr,
      'rasm': rasm,
      'qr_kod': qrKod,
      'yaratilgan': yaratilgan.toIso8601String(),
    };
  }
}
