class HistoryEntity {
  final String message;
  final List<HistoryDetailEntity> data;
  final int status;

  const HistoryEntity({
    required this.message,
    required this.data,
    required this.status,
  });
}

class HistoryDetailEntity {
  final int tartib;
  final String oy;
  final int oyRaqam;
  final int yil;
  final num jamiSumma;
  final int sotuvlarSoni;

  const HistoryDetailEntity({
    required this.tartib,
    required this.oy,
    required this.oyRaqam,
    required this.yil,
    required this.jamiSumma,
    required this.sotuvlarSoni,
  });
}