import '../../domain/entity/get_customer_entity.dart';

class GetCustomerModel extends GetCustomerEntity {
  const GetCustomerModel({
    required super.id,
    required super.fish,
    required super.telefon,
    required super.manzil,
    required super.qarzdorlik,
    required super.rasm,
    required super.yaratilgan,
  });

  factory GetCustomerModel.fromJson(Map<String, dynamic> json) {
    return GetCustomerModel(
      id: json['id'] ?? 0,
      fish: json['fish'] ?? '',
      telefon: json['telefon'] ?? '',
      manzil: json['manzil'] ?? '',
      qarzdorlik: json['qarzdorlik'] ?? 0,
      rasm: json['rasm'],
      yaratilgan: DateTime.tryParse(json['yaratilgan'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fish': fish,
      'telefon': telefon,
      'manzil': manzil,
      'qarzdorlik': qarzdorlik,
      'rasm': rasm,
      'yaratilgan': yaratilgan.toIso8601String(),
    };
  }
}