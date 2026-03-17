import 'package:admin_panel/features/customer/domain/entity/get_customer_detail_entity.dart';

class SotuvMahsulotModel extends SotuvMahsulotEntity {
  const SotuvMahsulotModel({
    required super.tovarNomi,
    required super.tovarRasm,
    required super.miqdor,
    required super.pochka,
    required super.metr,
    required super.narx,
    required super.jami,
  });

  factory SotuvMahsulotModel.fromJson(Map<String, dynamic> json) {
    return SotuvMahsulotModel(
      tovarNomi: json['tovar_nomi'] ?? '',
      tovarRasm: json['tovar_rasm'],
      miqdor: json['miqdor'] ?? 0,
      pochka: json['pochka'] ?? 0,
      metr: json['metr'] ?? 0,
      narx: json['narx'] ?? 0,
      jami: json['jami'] ?? 0,
    );
  }
}

class MijozSotuvModel extends MijozSotuvEntity {
  const MijozSotuvModel({
    required super.id,
    required super.sana,
    required super.tolovTuri,
    required super.jamiSumma,
    required super.tolovQilingan,
    required super.qarz,
    required super.mahsulotlar,
  });

  factory MijozSotuvModel.fromJson(Map<String, dynamic> json) {
    return MijozSotuvModel(
      id: json['id'] ?? 0,
      sana: DateTime.tryParse(json['sana'] ?? '') ?? DateTime.now(),
      tolovTuri: json['tolov_turi'] ?? '',
      jamiSumma: json['jami_summa'] ?? 0,
      tolovQilingan: json['tolov_qilingan'] ?? 0,
      qarz: json['qarz'] ?? 0,
      mahsulotlar: (json['mahsulotlar'] as List<dynamic>? ?? [])
          .map((e) => SotuvMahsulotModel.fromJson(e))
          .toList(),
    );
  }
}

class CustomerDetailDataModel extends CustomerDetailDataEntity {
  const CustomerDetailDataModel({
    required super.id,
    required super.fish,
    required super.telefon,
    required super.manzil,
    required super.mijozTuri,
    required super.qarzdorlik,
    required super.rasm,
    required super.yaratilgan,
    required super.sotuvlar,
  });

  factory CustomerDetailDataModel.fromJson(Map<String, dynamic> json) {
    return CustomerDetailDataModel(
      id: json['id'] ?? 0,
      fish: json['fish'] ?? '',
      telefon: json['telefon'] ?? '',
      manzil: json['manzil'] ?? '',
      mijozTuri: json['mijoz_turi'] ?? '',
      qarzdorlik: json['qarzdorlik'] ?? 0,
      rasm: json['rasm'],
      yaratilgan: DateTime.tryParse(json['yaratilgan'] ?? '') ?? DateTime.now(),
      sotuvlar: (json['sotuvlar'] as List<dynamic>? ?? [])
          .map((e) => MijozSotuvModel.fromJson(e))
          .toList(),
    );
  }
}

class GetCustomerDetailModel extends GetCustomerDetailEntity {
  const GetCustomerDetailModel({
    required super.message,
    required super.data,
    required super.status,
  });

  factory GetCustomerDetailModel.fromJson(Map<String, dynamic> json) {
    return GetCustomerDetailModel(
      message: json['message'] ?? '',
      data: CustomerDetailDataModel.fromJson(json['data'] ?? {}),
      status: json['status'] ?? 0,
    );
  }
}