class WorkerDetailEntity {
  final String message;
  final WorkerDetailDataEntity data;
  final int status;

  const WorkerDetailEntity({
    required this.message,
    required this.data,
    required this.status,
  });
}

class WorkerDetailDataEntity {
  final String fish;
  final String telefon;
  final String sana;
  final int jamiSumma;
  final List<WorkerProductEntity> mahsulotlar;

  const WorkerDetailDataEntity({
    required this.fish,
    required this.telefon,
    required this.sana,
    required this.jamiSumma,
    required this.mahsulotlar,
  });
}

class WorkerProductEntity {
  final String tovarNomi;
  final String vaqt;
  final int miqdor;
  final int pochka;
  final int metr;
  final int narx;
  final int jami;

  const WorkerProductEntity({
    required this.tovarNomi,
    required this.vaqt,
    required this.miqdor,
    required this.pochka,
    required this.metr,
    required this.narx,
    required this.jami,
  });
}