import 'expense_models.dart';

class KassaExpenseRowData {
  final String id;
  final DateTime sana;
  final PaymentType paymentType;
  final String doKon;
  final List<String> mahsulotlar; // bir nechta mahsulot
  final num summa;
  final bool sms;
  final String izoh;

  const KassaExpenseRowData({
    required this.id,
    required this.sana,
    required this.paymentType,
    required this.doKon,
    required this.mahsulotlar,
    required this.summa,
    required this.sms,
    required this.izoh,
  });

  KassaExpenseRowData copyWith({
    DateTime? sana,
    PaymentType? paymentType,
    String? doKon,
    List<String>? mahsulotlar,
    num? summa,
    bool? sms,
    String? izoh,
  }) {
    return KassaExpenseRowData(
      id: id,
      sana: sana ?? this.sana,
      paymentType: paymentType ?? this.paymentType,
      doKon: doKon ?? this.doKon,
      mahsulotlar: mahsulotlar ?? this.mahsulotlar,
      summa: summa ?? this.summa,
      sms: sms ?? this.sms,
      izoh: izoh ?? this.izoh,
    );
  }
}

class KassaExpenseFormResult {
  final PaymentType paymentType;
  final String doKon;
  final String mahsulotNomi; // API ga bitta string yuboriladi (join qilingan)
  final num summa;
  final bool sms;
  final String izoh;

  const KassaExpenseFormResult({
    required this.paymentType,
    required this.doKon,
    required this.mahsulotNomi,
    required this.summa,
    required this.sms,
    required this.izoh,
  });
}