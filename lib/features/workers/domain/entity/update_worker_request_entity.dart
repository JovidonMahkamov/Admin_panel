class UpdateWorkerRequestEntity {
  final int id;
  final String fish;
  final String parol;
  final String telefon;
  final String login;
  final double foiz;

  const UpdateWorkerRequestEntity({
    required this.id,
    required this.fish,
    required this.parol,
    required this.telefon,
    required this.login,
    this.foiz = 0,
  });
}