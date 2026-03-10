import 'get_customer_entity.dart';

class CreateCustomerResponseEntity {
  final String message;
  final GetCustomerEntity data;
  final int status;

  const CreateCustomerResponseEntity({
    required this.message,
    required this.data,
    required this.status,
  });
}