class DeleteCustomerResponseEntity {
  final String message;
  final dynamic data;
  final int status;

  const DeleteCustomerResponseEntity({
    required this.message,
    required this.data,
    required this.status,
  });
}