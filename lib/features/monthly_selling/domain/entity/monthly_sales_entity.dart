class MonthlySalesEntity {
  final String message;
  final MonthlySalesDataEntity data;
  final int status;

  const MonthlySalesEntity({
    required this.message,
    required this.data,
    required this.status,
  });
}

class MonthlySalesDataEntity {
  final int yil;
  final int oy;
  final int jamiSumma;
  final int sotuvlarSoni;
  final List<MonthlySaleEntity> sotuvlar;

  const MonthlySalesDataEntity({
    required this.yil,
    required this.oy,
    required this.jamiSumma,
    required this.sotuvlarSoni,
    required this.sotuvlar,
  });
}

class MonthlySaleEntity {
  final int id;
  final int mijozId;
  final String mijozFish;
  final int ishchiId;
  final String ishchiFish;
  final int jamiSumma;
  final int tolovQilingan;
  final int qarz;
  final String tolovTuri;
  final String izoh;
  final bool yakunlangan;
  final String sana;
  final List<MonthlySaleItemEntity> items;

  const MonthlySaleEntity({
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

class MonthlySaleItemEntity {
  final int id;
  final int tovarId;
  final String tovarNomi;
  final String tovarRasm;
  final int miqdor;
  final int pochka;
  final int metr;
  final int narx;
  final int jami;

  const MonthlySaleItemEntity({
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