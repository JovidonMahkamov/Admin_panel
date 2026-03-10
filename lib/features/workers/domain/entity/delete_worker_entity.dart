class DeleteWorkerResponseEntity {
  final String message;
  final dynamic data;
  final int status;

  const DeleteWorkerResponseEntity({
    required this.message,
    required this.data,
    required this.status,
  });
}