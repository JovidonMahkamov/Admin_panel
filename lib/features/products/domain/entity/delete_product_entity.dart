class DeleteProductEntity {
  final String message;
  final Object? data;
  final int status;

  const DeleteProductEntity({
    required this.message,
    required this.data,
    required this.status,
  });
}