abstract class CustomerEvent {
  const CustomerEvent();
}

class GetAllCustomersE extends CustomerEvent {
  const GetAllCustomersE();
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

  const DeleteCustomerE({
    required this.id,
});
}