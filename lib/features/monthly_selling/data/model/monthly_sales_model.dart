import '../../domain/entity/monthly_sales_entity.dart';

class MonthlySalesModel extends MonthlySalesEntity {
  const MonthlySalesModel({
    required super.message,
    required MonthlySalesDataModel super.data,
    required super.status,
  });

  factory MonthlySalesModel.fromJson(Map<String, dynamic> json) {
    return MonthlySalesModel(
      message: json['message'] ?? '',
      data: MonthlySalesDataModel.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
      status: _toInt(json['status']),
    );
  }
}

class MonthlySalesDataModel extends MonthlySalesDataEntity {
  const MonthlySalesDataModel({
    required super.yil,
    required super.oy,
    required super.jamiSumma,
    required super.sotuvlarSoni,
    required List<MonthlySaleModel> super.sotuvlar,
  });

  factory MonthlySalesDataModel.fromJson(Map<String, dynamic> json) {
    return MonthlySalesDataModel(
      yil: _toInt(json['yil']),
      oy: _toInt(json['oy']),
      jamiSumma: _toInt(json['jami_summa']),
      sotuvlarSoni: _toInt(json['sotuvlar_soni']),
      sotuvlar: (json['sotuvlar'] as List<dynamic>? ?? [])
          .map((e) => MonthlySaleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MonthlySaleModel extends MonthlySaleEntity {
  const MonthlySaleModel({
    required super.id,
    required super.mijozId,
    required super.mijozFish,
    required super.ishchiId,
    required super.ishchiFish,
    required super.jamiSumma,
    required super.tolovQilingan,
    required super.qarz,
    required super.tolovTuri,
    required super.izoh,
    required super.yakunlangan,
    required super.sana,
    required List<MonthlySaleItemModel> super.items,
  });

  factory MonthlySaleModel.fromJson(Map<String, dynamic> json) {
    return MonthlySaleModel(
      id: _toInt(json['id']),
      mijozId: _toInt(json['mijoz_id']),
      mijozFish: json['mijoz_fish'] ?? '',
      ishchiId: _toInt(json['ishchi_id']),
      ishchiFish: json['ishchi_fish'] ?? '',
      jamiSumma: _toInt(json['jami_summa']),
      tolovQilingan: _toInt(json['tolov_qilingan']),
      qarz: _toInt(json['qarz']),
      tolovTuri: json['tolov_turi'] ?? '',
      izoh: json['izoh'] ?? '',
      yakunlangan: json['yakunlangan'] ?? false,
      sana: json['sana'] ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => MonthlySaleItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MonthlySaleItemModel extends MonthlySaleItemEntity {
  const MonthlySaleItemModel({
    required super.id,
    required super.tovarId,
    required super.tovarNomi,
    required super.tovarRasm,
    required super.miqdor,
    required super.pochka,
    required super.metr,
    required super.narx,
    required super.jami,
  });

  factory MonthlySaleItemModel.fromJson(Map<String, dynamic> json) {
    return MonthlySaleItemModel(
      id: _toInt(json['id']),
      tovarId: _toInt(json['tovar_id']),
      tovarNomi: json['tovar_nomi'] ?? '',
      tovarRasm: json['tovar_rasm'] ?? '',
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