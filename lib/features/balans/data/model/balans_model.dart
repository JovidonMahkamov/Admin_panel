import '../../domain/entity/balans_entity.dart';

class BalansModel extends BalansEntity {
  const BalansModel({
    required super.savdoJami,
    required super.xarajatJami,
    required super.kassaJami,
    required super.chiqimJami,
    required super.qoldiq,
  });

  factory BalansModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return BalansModel(
      savdoJami:   (data['savdo_jami']   ?? 0).toDouble(),
      xarajatJami: (data['xarajat_jami'] ?? 0).toDouble(),
      kassaJami:   (data['kassa_jami']   ?? 0).toDouble(),
      chiqimJami:  (data['chiqim_jami']  ?? 0).toDouble(),
      qoldiq:      (data['qoldiq']       ?? 0).toDouble(),
    );
  }
}