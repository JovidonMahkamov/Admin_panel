class DashboardEntity {
  final String message;
  final DashboardDataEntity data;
  final int status;

  const DashboardEntity({
    required this.message,
    required this.data,
    required this.status,
  });
}

class DashboardDataEntity {
  final num naqd;
  final num terminal;
  final num click;
  final num jami;
  final List<WorkerSummaryEntity> ishchilar;
  final List<SaleEntity> sotuvlar;

  const DashboardDataEntity({
    required this.naqd,
    required this.terminal,
    required this.click,
    required this.jami,
    required this.ishchilar,
    required this.sotuvlar,
  });
}

class WorkerSummaryEntity {
  final int ishchiId;
  final String fish;
  final String telefon;
  final num jamiSumma;

  const WorkerSummaryEntity({
    required this.ishchiId,
    required this.fish,
    required this.telefon,
    required this.jamiSumma,
  });
}

class SaleEntity {
  final int id;
  final int mijozId;
  final String mijozFish;
  final int ishchiId;
  final String ishchiFish;
  final num jamiSumma;
  final num tolovQilingan;
  final num qarz;
  final String tolovTuri;
  final String izoh;
  final bool yakunlangan;
  final String sana;
  final List<SaleItemEntity> items;

  const SaleEntity({
    required this.id,
    required this.mijozId,
    required this.mijozFish,
    required this.ishchiId,
    required this.ishchiFish,
    required this.jamiSumma,
    required this.tolovQilingan,
    required this.qarz,
    required this.tolovTuri,
    required this.izoh,
    required this.yakunlangan,
    required this.sana,
    required this.items,
  });
}

class SaleItemEntity {
  final int id;
  final int tovarId;
  final String tovarNomi;
  final String? tovarRasm;
  final num miqdor;
  final num pochka;
  final num metr;
  final num narx;
  final num jami;

  const SaleItemEntity({
    required this.id,
    required this.tovarId,
    required this.tovarNomi,
    required this.tovarRasm,
    required this.miqdor,
    required this.pochka,
    required this.metr,
    required this.narx,
    required this.jami,
  });
}