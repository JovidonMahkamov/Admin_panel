import 'expense_models.dart'; 

class KassaExpenseRowData {
  final String id;
  final DateTime sana;
  final PaymentType paymentType;
  final int summa;
  final CurrencyType currency;
  final bool convertatsiya;
  final bool foyda;
  final bool sms;
  final String izoh;

  const KassaExpenseRowData({
    required this.id,
    required this.sana,
    required this.paymentType,
    required this.summa,
    required this.currency,
    required this.convertatsiya,
    required this.foyda,
    required this.sms,
    required this.izoh,
  });

  KassaExpenseRowData copyWith({
    DateTime? sana,
    PaymentType? paymentType,
    int? summa,
    CurrencyType? currency,
    bool? convertatsiya,
    bool? foyda,
    bool? sms,
    String? izoh,
  }) {
    return KassaExpenseRowData(
      id: id,
      sana: sana ?? this.sana,
      paymentType: paymentType ?? this.paymentType,
      summa: summa ?? this.summa,
      currency: currency ?? this.currency,
      convertatsiya: convertatsiya ?? this.convertatsiya,
      foyda: foyda ?? this.foyda,
      sms: sms ?? this.sms,
      izoh: izoh ?? this.izoh,
    );
  }
}

class KassaExpenseFormResult {
  final PaymentType paymentType;
  final int summa;
  final CurrencyType currency;
  final bool convertatsiya;
  final bool foyda;
  final bool sms;
  final String izoh;

  const KassaExpenseFormResult({
    required this.paymentType,
    required this.summa,
    required this.currency,
    required this.convertatsiya,
    required this.foyda,
    required this.sms,
    required this.izoh,
  });
}