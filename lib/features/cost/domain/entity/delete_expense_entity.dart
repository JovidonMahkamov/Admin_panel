class DeleteExpenseEntity {
  final String message;
  final dynamic data;
  final int status;

  const DeleteExpenseEntity({
    required this.message,
    required this.data,
    required this.status,
  });
}