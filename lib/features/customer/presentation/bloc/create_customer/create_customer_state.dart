import 'package:admin_panel/features/customer/domain/entity/create_customer_response_entity.dart';

abstract class CreateCustomerState {
  const CreateCustomerState();
}

class CreateCustomerInitial extends CreateCustomerState {}

class CreateCustomerLoading extends CreateCustomerState {}

class CreateCustomerSuccess extends CreateCustomerState {
  final CreateCustomerResponseEntity createCustomerResponseEntity;

  const CreateCustomerSuccess({required this.createCustomerResponseEntity});
}

class CreateCustomerError extends CreateCustomerState {
  final String message;

  const CreateCustomerError({required this.message});
}
