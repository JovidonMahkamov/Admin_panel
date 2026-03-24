import '../../domain/entity/dashboard_entity.dart';

class DashboardModel extends DashboardEntity {
  const DashboardModel({
    required super.message,
    required DashboardDataModel super.data,
    required super.status,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      message: json['message'] ?? '',
      data: DashboardDataModel.fromJson(json['data'] ?? {}),
      status: json['status'] ?? 0,
    );
  }
}

class QaytarishModel extends QaytarishEntity {
  const QaytarishModel({
    required super.id,
    required super.mijozId,
    super.mijozFish,
    required super.jamiUsd,
    required super.tolovTuri,
    required super.sana,
  });

  factory QaytarishModel.fromJson(Map<String, dynamic> json) {
    return QaytarishModel(
      id:        json['id'] ?? 0,
      mijozId:   json['mijoz_id'] ?? 0,
      mijozFish: json['mijoz_fish'],
      jamiUsd:   json['jami_usd'] ?? 0,
      tolovTuri: json['tolov_turi'] ?? 'naqd',
      sana:      json['sana'] ?? '',
    );
  }
}

class DashboardDataModel extends DashboardDataEntity {
  const DashboardDataModel({
    required super.naqd,
    required super.terminal,
    required super.click,
    required super.jami,
    super.kirimNaqd,
    super.kirimTerminal,
    super.kirimClick,
    super.kirimJami,
    super.umumiy,
    super.qaytarishNaqd,
    super.qaytarishTerminal,
    super.qaytarishClick,
    super.qaytarishJami,
    required List<WorkerSummaryModel> super.ishchilar,
    required List<SaleModel> super.sotuvlar,
    super.qaytarishlar,
  });

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) {
    return DashboardDataModel(
      naqd:              json['naqd'] ?? 0,
      terminal:          json['terminal'] ?? 0,
      click:             json['click'] ?? 0,
      jami:              json['jami'] ?? 0,
      kirimNaqd:         json['kirim_naqd'] ?? 0,
      kirimTerminal:     json['kirim_terminal'] ?? 0,
      kirimClick:        json['kirim_click'] ?? 0,
      kirimJami:         json['kirim_jami'] ?? 0,
      umumiy:            json['umumiy'] ?? 0,
      qaytarishNaqd:     json['qaytarish_naqd'] ?? 0,
      qaytarishTerminal: json['qaytarish_terminal'] ?? 0,
      qaytarishClick:    json['qaytarish_click'] ?? 0,
      qaytarishJami:     json['qaytarish_jami'] ?? 0,
      ishchilar: (json['ishchilar'] as List<dynamic>? ?? [])
          .map((e) => WorkerSummaryModel.fromJson(e))
          .toList(),
      sotuvlar: (json['sotuvlar'] as List<dynamic>? ?? [])
          .map((e) => SaleModel.fromJson(e))
          .toList(),
      qaytarishlar: (json['qaytarishlar'] as List<dynamic>? ?? [])
          .map((e) => QaytarishModel.fromJson(e))
          .toList(),
    );
  }
}

class WorkerSummaryModel extends WorkerSummaryEntity {
  const WorkerSummaryModel({
    required super.ishchiId,
    required super.fish,
    required super.telefon,
    required super.jamiSumma,
  });

  factory WorkerSummaryModel.fromJson(Map<String, dynamic> json) {
    return WorkerSummaryModel(
      ishchiId:  json['ishchi_id'] ?? 0,
      fish:      json['fish'] ?? '',
      telefon:   json['telefon'] ?? '',
      jamiSumma: json['jami_summa'] ?? 0,
    );
  }
}

class SaleModel extends SaleEntity {
  const SaleModel({
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
    required List<SaleItemModel> super.items,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id:            json['id'] ?? 0,
      mijozId:       json['mijoz_id'] ?? 0,
      mijozFish:     json['mijoz_fish'] ?? '',
      ishchiId:      json['ishchi_id'] ?? 0,
      ishchiFish:    json['ishchi_fish'] ?? '',
      jamiSumma:     json['jami_summa'] ?? 0,
      tolovQilingan: json['tolov_qilingan'] ?? 0,
      qarz:          json['qarz'] ?? 0,
      tolovTuri:     json['tolov_turi'] ?? '',
      izoh:          json['izoh'] ?? '',
      yakunlangan:   json['yakunlangan'] ?? false,
      sana:          json['sana'] ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => SaleItemModel.fromJson(e))
          .toList(),
    );
  }
}

class SaleItemModel extends SaleItemEntity {
  const SaleItemModel({
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

  factory SaleItemModel.fromJson(Map<String, dynamic> json) {
    return SaleItemModel(
      id:        json['id'] ?? 0,
      tovarId:   json['tovar_id'] ?? 0,
      tovarNomi: json['tovar_nomi'] ?? '',
      tovarRasm: json['tovar_rasm'],
      miqdor:    json['miqdor'] ?? 0,
      pochka:    json['pochka'] ?? 0,
      metr:      json['metr'] ?? 0,
      narx:      json['narx'] ?? 0,
      jami:      json['jami'] ?? 0,
    );
  }
}