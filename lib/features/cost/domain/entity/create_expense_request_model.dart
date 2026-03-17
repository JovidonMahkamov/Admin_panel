class CreateExpenseRequestModel {
  final String ishchiIdField;
  final String izoh;
  final bool sms;
  final int summa;
  final String tolovTuri;

  const CreateExpenseRequestModel({
    required this.ishchiIdField,
    required this.izoh,
    required this.sms,
    required this.summa,
    required this.tolovTuri,
  });

  Map<String, dynamic> toJson() {
    return {
      'ishchi_id': int.tryParse(ishchiIdField) ?? 0,
      'izoh': izoh,
      'sms': sms,
      'summa': summa,
      'tolov_turi': tolovTuri,
    };
  }
}