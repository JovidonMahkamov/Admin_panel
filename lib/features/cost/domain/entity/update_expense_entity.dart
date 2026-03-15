class UpdateExpenseEntity {
  final String message;
  final UpdateExpenseDataEntity data;
  final int status;

  const UpdateExpenseEntity({
    required this.message,
    required this.data,
    required this.status,
  });
}

class UpdateExpenseDataEntity {
  final int id;
  final String tolovTuri;
  final int ishchiId;
  final String ishchiFish;
  final num summa;
  final bool sms;
  final String izoh;
  final String sana;

  const UpdateExpenseDataEntity({
    required this.id,
    required this.tolovTuri,
    required this.ishchiId,
    required this.ishchiFish,
    required this.summa,
    required this.sms,
    required this.izoh,
    required this.sana,
  });
}