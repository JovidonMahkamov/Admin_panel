
import 'package:admin_panel/features/workers/domain/entity/create_worker_request_entity.dart';

class CreateWorkerRequestModel extends CreateWorkerRequestEntity {
  const CreateWorkerRequestModel({
    required super.fish,
    required super.login,
    required super.parol,
    required super.telefon,
  });

  Map<String, dynamic> toJson() {
    return {
      'fish': fish,
      'login': login,
      'parol': parol,
      'telefon': telefon,
    };
  }
}