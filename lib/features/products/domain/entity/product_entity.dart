class ProductEntity {
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
  final String? qrKod;
  final int? sotildi;
  final DateTime yaratilgan;

  const ProductEntity({
    required this.id,
    required this.nomi,
    this.sotildi,
    this.narxDona,
    this.narxMetr,
    this.narxPochka,
    this.pochka,
    this.metr,
    this.miqdor,
    this.kelganNarx,
    this.jamiNarx,
    this.rasm,
    this.qrKod,
    required this.yaratilgan,
  });
}