class UpdateProductEntity {
  final String message;
  final UpdateProductDataEntity data;
  final int status;

  const UpdateProductEntity({
    required this.message,
    required this.data,
    required this.status,
  });
}

class UpdateProductDataEntity {
  final int id;
  final String nomi;
  final String? narxDona;
  final String? narxMetr;
  final String? narxPochka;
  final String? pochka;
  final String? metr;
  final String? miqdor;
  final String? kelganNarx;
  final String? jamiNarx;
  final String? rasm;
  final String qrKod;
  final bool aktiv;
  final String yaratilgan;

  const UpdateProductDataEntity({
    required this.id,
    required this.nomi,
    required this.narxDona,
    required this.narxMetr,
    required this.narxPochka,
    required this.pochka,
    required this.metr,
    required this.miqdor,
    required this.kelganNarx,
    required this.jamiNarx,
    required this.rasm,
    required this.qrKod,
    required this.aktiv,
    required this.yaratilgan,
  });
}