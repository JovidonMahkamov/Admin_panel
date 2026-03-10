abstract class WorkerEvent {
  const WorkerEvent();
}

class GetAllWorkerE extends WorkerEvent {
  const GetAllWorkerE();
}

class CreateWorkerE extends WorkerEvent {
  final String fish;
  final String login;
  final String parol;
  final String telefon;

  const CreateWorkerE({
    required this.fish,
    required this.login,
    required this.parol,
    required this.telefon,
  });
}

class DeleteWorkerE extends WorkerEvent {
  final int id;

  const DeleteWorkerE({
    required this.id,
  });
}

class UpdateWorkerE extends WorkerEvent {
  final int id;
  final String fish;
  final String login;
  final String parol;
  final String telefon;

  const UpdateWorkerE({
    required this.id,
    required this.fish,
    required this.login,
    required this.parol,
    required this.telefon,
  });
}