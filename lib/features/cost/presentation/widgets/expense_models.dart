import 'package:flutter/material.dart';

enum PaymentType { naqd, terminal, click }

extension PaymentTypeX on PaymentType {
  String get label => switch (this) {
    PaymentType.naqd => 'Naqd',
    PaymentType.terminal => 'Terminal',
    PaymentType.click => 'Click',
  };
}

enum CurrencyType { uzs, usd }

extension CurrencyTypeX on CurrencyType {
  String get label => switch (this) {
    CurrencyType.uzs => 'UZS',
    CurrencyType.usd => r'$',
  };

  String get symbol => switch (this) {
    CurrencyType.uzs => "so'm",
    CurrencyType.usd => r"$",
  };
}

class WorkerOption {
  final String id;
  final String name;
  final String phone;

  const WorkerOption({
    required this.id,
    required this.name,
    required this.phone,
  });
}

class ExpenseRowData {
  final String id;
  final DateTime sana;
  final PaymentType paymentType;

  final String workerId;
  final String workerName;
  final String workerPhone;

  final int summa;
  final CurrencyType currency;

  final bool convertatsiya;
  final bool foyda;
  final bool sms;

  final String izoh;

  const ExpenseRowData({
    required this.id,
    required this.sana,
    required this.paymentType,
    required this.workerId,
    required this.workerName,
    required this.workerPhone,
    required this.summa,
    required this.currency,
    required this.convertatsiya,
    required this.foyda,
    required this.sms,
    required this.izoh,
  });

  ExpenseRowData copyWith({
    DateTime? sana,
    PaymentType? paymentType,
    String? workerId,
    String? workerName,
    String? workerPhone,
    int? summa,
    CurrencyType? currency,
    bool? convertatsiya,
    bool? foyda,
    bool? sms,
    String? izoh,
  }) {
    return ExpenseRowData(
      id: id,
      sana: sana ?? this.sana,
      paymentType: paymentType ?? this.paymentType,
      workerId: workerId ?? this.workerId,
      workerName: workerName ?? this.workerName,
      workerPhone: workerPhone ?? this.workerPhone,
      summa: summa ?? this.summa,
      currency: currency ?? this.currency,
      convertatsiya: convertatsiya ?? this.convertatsiya,
      foyda: foyda ?? this.foyda,
      sms: sms ?? this.sms,
      izoh: izoh ?? this.izoh,
    );
  }
}

class ExpenseFormResult {
  final PaymentType paymentType;
  final String workerId;
  final int summa;
  final CurrencyType currency;
  final bool convertatsiya;
  final bool foyda;
  final bool sms;
  final String izoh;

  const ExpenseFormResult({
    required this.paymentType,
    required this.workerId,
    required this.summa,
    required this.currency,
    required this.convertatsiya,
    required this.foyda,
    required this.sms,
    required this.izoh,
  });
}

/// helpers
String formatDate(DateTime date) {
  final d = date.day.toString().padLeft(2, '0');
  final m = date.month.toString().padLeft(2, '0');
  final y = date.year.toString();
  return '$d.$m.$y';
}

String formatAmount(int value) {
  final s = value.toString();
  final buffer = StringBuffer();
  int count = 0;
  for (int i = s.length - 1; i >= 0; i--) {
    buffer.write(s[i]);
    count++;
    if (count % 3 == 0 && i != 0) buffer.write(' ');
  }
  return buffer.toString().split('').reversed.join();
}

InputDecoration dialogInputDecoration({required String hintText}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(color: Color(0xFFB8BDC7), fontSize: 13),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFE6E8ED)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFF1877F2)),
    ),
  );
}