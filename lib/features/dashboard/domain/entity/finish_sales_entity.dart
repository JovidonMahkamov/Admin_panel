class FinishSalesEntity {
  final String message;
  final FinishSalesDataEntity data;
  final int status;

  const FinishSalesEntity({
    required this.message,
    required this.data,
    required this.status,
  });
}

class FinishSalesDataEntity {
  final int yakunlanganSoni;

  const FinishSalesDataEntity({
    required this.yakunlanganSoni,
  });
}