class DokonChiqimEntity {
  final int id;
  final String tolovTuri;
  final double summa;
  final String? izoh;
  final String? tavsif;
  final String sana;

  const DokonChiqimEntity({
    required this.id,
    required this.tolovTuri,
    required this.summa,
    this.izoh,
    this.tavsif,
    required this.sana,
  });
}

class CreateDokonChiqimEntity {
  final String message;
  final DokonChiqimEntity data;
  final int status;

  const CreateDokonChiqimEntity({
    required this.message,
    required this.data,
    required this.status,
  });
}

class DeleteDokonChiqimEntity {
  final String message;
  final dynamic data;
  final int status;

  const DeleteDokonChiqimEntity({
    required this.message,
    required this.data,
    required this.status,
  });
}