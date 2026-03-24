class BalansEntity {
  final double savdoJami;
  final double xarajatJami;
  final double kassaJami;
  final double dokonJami;
  final double chiqimJami;
  final double qoldiq;

  const BalansEntity({
    required this.savdoJami,
    required this.xarajatJami,
    required this.kassaJami,
    this.dokonJami = 0,
    required this.chiqimJami,
    required this.qoldiq,
  });
}