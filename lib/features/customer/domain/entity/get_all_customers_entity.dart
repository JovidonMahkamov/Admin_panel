import 'get_customer_entity.dart';

class GetAllCustomersEntity {
  final String message;
  final List<GetCustomerEntity> data;
  final int status;

  const GetAllCustomersEntity({
    required this.message,
    required this.data,
    required this.status,
  });
}