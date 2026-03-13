import 'package:admin_panel/features/history/domain/entity/history_entity.dart';

class HistoryModel extends HistoryEntity {
  const HistoryModel({
    required super.message,
    required List<HistoryDetailModel> super.data,
    required super.status,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => HistoryDetailModel.fromJson(e))
          .toList(),
      status: json['status'] ?? 0,
    );
  }
}

class HistoryDetailModel extends HistoryDetailEntity {
  const HistoryDetailModel({
    required super.tartib,
    required super.oy,
    required super.oyRaqam,
    required super.yil,
    required super.jamiSumma,
    required super.sotuvlarSoni,
  });

  factory HistoryDetailModel.fromJson(Map<String, dynamic> json) {
    return HistoryDetailModel(
      tartib: json['tartib'] ?? 0,
      oy: json['oy'] ?? '',
      oyRaqam: json['oy_raqam'] ?? 0,
      yil: json['yil'] ?? 0,
      jamiSumma: json['jami_summa'] ?? 0,
      sotuvlarSoni: json['sotuvlar_soni'] ?? 0,
    );
  }
}