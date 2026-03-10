import '../../domain/entity/update_worker_request_entity.dart';

class UpdateWorkerRequestModel extends UpdateWorkerRequestEntity {
  const UpdateWorkerRequestModel({
    required super.id,
    required super.fish,
    required super.parol,
    required super.telefon,
    required super.login,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fish': fish,
      'parol': parol,
      'telefon': telefon,
      'login': login,
    };
  }
}