class FinishMonthlySalesEntity {
  final String message;
  final FinishMonthlySalesDataEntity data;
  final int status;

  const FinishMonthlySalesEntity({
    required this.message,
    required this.data,
    required this.status,
  });
}

class FinishMonthlySalesDataEntity {
  final int yakunlanganSoni;
  final int yil;
  final int oy;

  const FinishMonthlySalesDataEntity({
    required this.yakunlanganSoni,
    required this.yil,
    required this.oy,
  });
}