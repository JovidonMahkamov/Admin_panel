import 'package:admin_panel/features/customer/domain/entity/update_customer_entity.dart';

abstract class UpdateCustomerState {
  const UpdateCustomerState();
}

class UpdateCustomersInitial extends UpdateCustomerState {}

class UpdateCustomersLoading extends UpdateCustomerState {}

class UpdateCustomersSuccess extends UpdateCustomerState {
  final UpdateCustomerEntity updateCustomerEntity;

  const UpdateCustomersSuccess({required this.updateCustomerEntity});
}

class UpdateCustomersError extends UpdateCustomerState {
  final String message;

  const UpdateCustomersError({required this.message});
}
