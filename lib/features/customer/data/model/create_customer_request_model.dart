import '../../domain/entity/create_customer_request_entity.dart';

class CreateCustomerRequestModel extends CreateCustomerRequestEntity {
  const CreateCustomerRequestModel({
    required super.fish,
    required super.manzil,
    required super.telefon,
    required super.mijozTuri,
  });

  Map<String, dynamic> toJson() {
    return {
      'fish': fish,
      'manzil': manzil,
      'telefon': telefon,
      'mijoz_turi"': mijozTuri,
    };
  }
}