class SummaryEntity {
  final double jamiNarx;
  final double adminJamiNarx;
  final double jamiMetr;
  final int jamiMiqdor;
  final int jamiPochka;
  final int tovarlarSoni;

  SummaryEntity({
    required this.jamiNarx,
    this.adminJamiNarx = 0,
    required this.jamiMetr,
    required this.jamiMiqdor,
    required this.jamiPochka,
    required this.tovarlarSoni,
  });
}