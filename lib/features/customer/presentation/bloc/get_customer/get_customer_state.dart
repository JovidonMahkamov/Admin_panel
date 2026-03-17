import 'package:admin_panel/features/customer/domain/entity/get_customer_detail_entity.dart';

abstract class GetCustomerState {
  const GetCustomerState();
}

class GetCustomerInitial extends GetCustomerState {}

class GetCustomerLoading extends GetCustomerState {}

class GetCustomerSuccess extends GetCustomerState {
  final GetCustomerDetailEntity getCustomerDetailEntity;

  const GetCustomerSuccess({required this.getCustomerDetailEntity});
}

class GetCustomerError extends GetCustomerState {
  final String message;

  const GetCustomerError({required this.message});
}
