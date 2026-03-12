import 'dart:io';

class CreateProductParams {
  final String nomi;
  final String? narxDona;
  final String? narxMetr;
  final String? narxPochka;
  final String? pochka;
  final String? metr;
  final String? miqdor;
  final String? kelganNarx;
  final String? jamiNarx;
  final File? rasm;

  const CreateProductParams({
    required this.nomi,
    this.narxDona,
    this.narxMetr,
    this.narxPochka,
    this.pochka,
    this.metr,
    this.miqdor,
    this.kelganNarx,
    this.jamiNarx,
    this.rasm,
  });
}