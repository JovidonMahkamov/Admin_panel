class CostEntity {
  final String message;
  final List<CostItemEntity> data;
  final int status;

  const CostEntity({
    required this.message,
    required this.data,
    required this.status,
  });
}

class CostItemEntity {
  final int id;
  final String tolovTuri;
  final String ishchiIdField;
  final String ishchiFish;
  final num summa;
  final bool sms;
  final String izoh;
  final String sana;

  const CostItemEntity({
    required this.id,
    required this.tolovTuri,
    required this.ishchiIdField,
    required this.ishchiFish,
    required this.summa,
    required this.sms,
    required this.izoh,
    required this.sana,
  });
}