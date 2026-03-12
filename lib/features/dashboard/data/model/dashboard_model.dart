import '../../domain/entity/dashboard_entity.dart';

class DashboardModel extends DashboardEntity {
  DashboardModel({
    required super.message,
    required super.data,
    required super.status,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      message: json['message'],
      status: json['status'],
      data: DashboardDataModel.fromJson(json['data']),
    );
  }
}

class DashboardDataModel extends DashboardDataEntity {
  DashboardDataModel({
    required super.naqd,
    required super.terminal,
    required super.click,
    required super.jami,
    required super.ishchilar,
    required super.sotuvlar,
  });

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) {
    return DashboardDataModel(
      naqd: json['naqd'] ?? 0,
      terminal: json['terminal'] ?? 0,
      click: json['click'] ?? 0,
      jami: json['jami'] ?? 0,
      ishchilar: json['ishchilar'] ?? [],
      sotuvlar: json['sotuvlar'] ?? [],
    );
  }
}