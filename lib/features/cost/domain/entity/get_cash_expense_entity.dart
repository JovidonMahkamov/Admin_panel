class GetCashExpenseEntity {
  final String message;
  final List<GetCashExpenseDataEntity> data;
  final int status;

  const GetCashExpenseEntity({
    required this.message,
    required this.data,
    required this.status,
  });
}

class GetCashExpenseDataEntity {
  final int id;
  final String tolovTuri;
  final String doKon;
  final String mahsulotNomi;
  final num summa;
  final num qarzQoldiq;
  final bool toliqTolangan;
  final String valyuta;
  final bool sms;
  final String izoh;
  final String sana;

  const GetCashExpenseDataEntity({
    required this.id,
    required this.tolovTuri,
    required this.doKon,
    required this.mahsulotNomi,
    required this.summa,
    this.qarzQoldiq = 0,
    this.toliqTolangan = false,
    required this.valyuta,
    required this.sms,
    required this.izoh,
    required this.sana,
  });
}