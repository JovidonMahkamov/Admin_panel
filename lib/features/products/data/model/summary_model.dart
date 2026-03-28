import 'package:admin_panel/features/products/domain/entity/summary_entity.dart';

class SummaryModel extends SummaryEntity {
  SummaryModel({
    required super.jamiNarx,
    super.adminJamiNarx,
    required super.jamiMetr,
    required super.jamiMiqdor,
    required super.jamiPochka,
    required super.tovarlarSoni,
  });

  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    return SummaryModel(
      jamiNarx:      (json['jami_narx'] as num? ?? 0).toDouble(),
      adminJamiNarx: (json['admin_jami_narx'] as num? ?? 0).toDouble(),
      jamiMetr:      (json['jami_metr'] as num? ?? 0).toDouble(),
      jamiMiqdor:    json['jami_miqdor'] ?? 0,
      jamiPochka:    json['jami_pochka'] ?? 0,
      tovarlarSoni:  json['tovarlar_soni'] ?? 0,
    );
  }
}