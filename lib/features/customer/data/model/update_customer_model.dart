import '../../domain/entity/update_customer_entity.dart';

class UpdateCustomerModel extends UpdateCustomerEntity {
  const UpdateCustomerModel({
    required super.id,
    required super.fish,
    required super.telefon,
    required super.manzil,
    required super.qarzdorlik,
    super.rasm,
    required super.yaratilgan,
  });

  factory UpdateCustomerModel.fromJson(Map<String, dynamic> json) {
    return UpdateCustomerModel(
      id: json['id'] ?? 0,
      fish: json['fish'] ?? '',
      telefon: json['telefon'] ?? '',
      manzil: json['manzil'] ?? '',
      // null bo‘lsa 0 qilamiz
      qarzdorlik: json['qarzdorlik'] != null
          ? (json['qarzdorlik'] is num
          ? json['qarzdorlik']
          : num.tryParse(json['qarzdorlik'].toString()) ?? 0)
          : 0,
      rasm: json['rasm'],
      yaratilgan: json['yaratilgan'] != null
          ? DateTime.tryParse(json['yaratilgan'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "fish": fish,
      "telefon": telefon,
      "manzil": manzil,
      "qarzdorlik": qarzdorlik,
      "rasm": rasm,
      "yaratilgan": yaratilgan.toIso8601String(),
    };
  }
}