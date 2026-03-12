class UpdateCustomerEntity {
  final int id;
  final String fish;
  final String telefon;
  final String manzil;
  final num qarzdorlik;
  final String? rasm;
  final DateTime yaratilgan;

  const UpdateCustomerEntity({
    required this.id,
    required this.fish,
    required this.telefon,
    required this.manzil,
    required this.qarzdorlik,
    this.rasm,
    required this.yaratilgan,
  });
}