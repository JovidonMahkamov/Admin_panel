// Sotuv ichidagi mahsulot entity
class SotuvMahsulotEntity {
  final String tovarNomi;
  final String? tovarRasm;
  final num miqdor;
  final num pochka;
  final num metr;
  final num narx;
  final num jami;

  const SotuvMahsulotEntity({
    required this.tovarNomi,
    required this.tovarRasm,
    required this.miqdor,
    required this.pochka,
    required this.metr,
    required this.narx,
    required this.jami,
  });
}

// Bitta sotuv entity
class MijozSotuvEntity {
  final int id;
  final DateTime sana;
  final String tolovTuri;
  final num jamiSumma;
  final num tolovQilingan;
  final num qarz;
  final List<SotuvMahsulotEntity> mahsulotlar;

  const MijozSotuvEntity({
    required this.id,
    required this.sana,
    required this.tolovTuri,
    required this.jamiSumma,
    required this.tolovQilingan,
    required this.qarz,
    required this.mahsulotlar,
  });
}

// Mijoz detail entity (sotuvlar bilan)
class GetCustomerDetailEntity {
  final String message;
  final CustomerDetailDataEntity data;
  final int status;

  const GetCustomerDetailEntity({
    required this.message,
    required this.data,
    required this.status,
  });
}

class CustomerDetailDataEntity {
  final int id;
  final String fish;
  final String telefon;
  final String manzil;
  final String mijozTuri;
  final num qarzdorlik;
  final String? rasm;
  final DateTime yaratilgan;
  final List<MijozSotuvEntity> sotuvlar;

  const CustomerDetailDataEntity({
    required this.id,
    required this.fish,
    required this.telefon,
    required this.manzil,
    required this.mijozTuri,
    required this.qarzdorlik,
    required this.rasm,
    required this.yaratilgan,
    required this.sotuvlar,
  });
}