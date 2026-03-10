import '../../domain/entity/update_worker_response_entity.dart';
import 'get_worker_model.dart';

class UpdateWorkerResponseModel extends UpdateWorkerResponseEntity {
  const UpdateWorkerResponseModel({
    required super.message,
    required GetWorkerModel super.data,
    required super.status,
  });

  factory UpdateWorkerResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateWorkerResponseModel(
      message: json['message'] ?? '',
      data: GetWorkerModel.fromJson(json['data'] as Map<String, dynamic>),
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': {
        'id': data.id,
        'fish': data.fish,
        'telefon': data.telefon,
        'login': data.login,
        'parol': data.parol,
        'yaratilgan': data.yaratilgan.toIso8601String(),
      },
      'status': status,
    };
  }
}