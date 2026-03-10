

import 'package:admin_panel/features/workers/data/model/get_worker_model.dart';
import 'package:admin_panel/features/workers/domain/entity/get_all_workers_entity.dart';

class GetAllWorkersModel extends GetAllWorkersEntity {
  const GetAllWorkersModel({
    required super.message,
    required List<GetWorkerModel> super.data,
    required super.status,
  });

  factory GetAllWorkersModel.fromJson(Map<String, dynamic> json) {
    return GetAllWorkersModel(
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => GetWorkerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((e) {
        if (e is GetWorkerModel) {
          return e.toJson();
        }
        return {
          'id': e.id,
          'fish': e.fish,
          'telefon': e.telefon,
          'login': e.login,
          'yaratilgan': e.yaratilgan.toIso8601String(),
        };
      }).toList(),
      'status': status,
    };
  }
}