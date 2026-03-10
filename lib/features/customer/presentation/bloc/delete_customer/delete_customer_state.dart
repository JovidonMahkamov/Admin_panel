import 'package:admin_panel/features/customer/domain/entity/delete_customer_response_entity.dart';

abstract class DeleteCustomerState {
  const DeleteCustomerState();
}

class DeleteCustomerInitial extends DeleteCustomerState {}

class DeleteCustomerLoading extends DeleteCustomerState {}

class DeleteCustomerSuccess extends DeleteCustomerState {
  final DeleteCustomerResponseEntity deleteCustomerResponseEntity;

  const DeleteCustomerSuccess({required this.deleteCustomerResponseEntity});
}

class DeleteCustomerError extends DeleteCustomerState {
  final String message;

  const DeleteCustomerError({required this.message});
}
