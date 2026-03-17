import 'package:admin_panel/features/customer/domain/entity/create_customer_request_entity.dart';

abstract class CustomerEvent {
  const CustomerEvent();
}

class GetAllCustomersE extends CustomerEvent {
  const GetAllCustomersE();
}
class GetCustomersE extends CustomerEvent {
  final int id;
  const GetCustomersE({required this.id});
}

class CreateCustomerE extends CustomerEvent {
  final CreateCustomerRequestEntity createCustomer;

  const CreateCustomerE({
    required this.createCustomer,
  });
}

class DeleteCustomerE extends CustomerEvent {
  final int id;

  const DeleteCustomerE({required this.id});
}

class UpdateCustomerE extends CustomerEvent {
  final int id;
  final String fish;
  final int qarzdorlik;
  final String manzil;
  final String telefon;

  const UpdateCustomerE({
    required this.id,
    required this.fish,
    required this.qarzdorlik,
    required this.manzil,
    required this.telefon,
  });
}
