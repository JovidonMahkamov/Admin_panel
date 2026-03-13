import '../../domain/entity/worker_detail_entity.dart';

class WorkerDetailModel extends WorkerDetailEntity {
  const WorkerDetailModel({
    required super.message,
    required WorkerDetailDataModel super.data,
    required super.status,
  });

  factory WorkerDetailModel.fromJson(Map<String, dynamic> json) {
    return WorkerDetailModel(
      message: json['message'] ?? '',
      data: WorkerDetailDataModel.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
      status: _toInt(json['status']),
    );
  }
}

class WorkerDetailDataModel extends WorkerDetailDataEntity {
  const WorkerDetailDataModel({
    required super.fish,
    required super.telefon,
    required super.sana,
    required super.jamiSumma,
    required List<WorkerProductModel> super.mahsulotlar,
  });

  factory WorkerDetailDataModel.fromJson(Map<String, dynamic> json) {
    return WorkerDetailDataModel(
      fish: json['fish'] ?? '',
      telefon: json['telefon'] ?? '',
      sana: json['sana'] ?? '',
      jamiSumma: _toInt(json['jami_summa']),
      mahsulotlar: (json['mahsulotlar'] as List<dynamic>? ?? [])
          .map((e) => WorkerProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class WorkerProductModel extends WorkerProductEntity {
  const WorkerProductModel({
    required super.tovarNomi,
    required super.vaqt,
    required super.miqdor,
    required super.pochka,
    required super.metr,
    required super.narx,
    required super.jami,
  });

  factory WorkerProductModel.fromJson(Map<String, dynamic> json) {
    return WorkerProductModel(
      tovarNomi: json['tovar_nomi'] ?? '',
      vaqt: json['vaqt'] ?? '',
      miqdor: _toInt(json['miqdor']),
      pochka: _toInt(json['pochka']),
      metr: _toInt(json['metr']),
      narx: _toInt(json['narx']),
      jami: _toInt(json['jami']),
    );
  }
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9.-]'), '');
    return double.tryParse(cleaned)?.toInt() ?? 0;
  }
  return 0;
}