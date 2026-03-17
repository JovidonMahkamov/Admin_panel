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
  final String fish;
  final String manzil;
  final String telefon;

  const CreateCustomerE({
    required this.fish,
    required this.manzil,
    required this.telefon,
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
