
import 'package:admin_panel/features/workers/domain/entity/get_worker_entity.dart';

class GetWorkerModel extends GetWorkerEntity {
  const GetWorkerModel({
    required super.id,
    required super.fish,
    required super.telefon,
    required super.login,
    required super.yaratilgan,
    required super.parol,
  });

  factory GetWorkerModel.fromJson(Map<String, dynamic> json) {
    return GetWorkerModel(
      id: json['id'] ?? 0,
      fish: json['fish'] ?? '',
      telefon: json['telefon'] ?? '',
      login: json['login'] ?? '',
      parol: json['parol'] ?? '',
      yaratilgan: DateTime.tryParse(json['yaratilgan'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fish': fish,
      'telefon': telefon,
      'login': login,
      'parol': parol,
      'yaratilgan': yaratilgan.toIso8601String(),
    };
  }
}