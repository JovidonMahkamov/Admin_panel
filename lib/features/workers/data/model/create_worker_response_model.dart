import 'package:admin_panel/features/workers/domain/entity/create_worker_response_entity.dart';
import 'get_worker_model.dart';

class CreateWorkerResponseModel extends CreateWorkerResponseEntity {
  const CreateWorkerResponseModel({
    required super.message,
    required GetWorkerModel super.data,
    required super.status,
  });

  factory CreateWorkerResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateWorkerResponseModel(
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
        'yaratilgan': data.yaratilgan.toIso8601String(),
      },
      'status': status,
    };
  }
}