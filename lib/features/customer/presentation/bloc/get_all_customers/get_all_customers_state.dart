import 'package:admin_panel/features/customer/domain/entity/get_all_customers_entity.dart';

abstract class GetAllCustomersState {
  const GetAllCustomersState();
}

class GetAllCustomersInitial extends GetAllCustomersState {}

class GetAllCustomersLoading extends GetAllCustomersState {}

class GetAllCustomersSuccess extends GetAllCustomersState {
  final GetAllCustomersEntity getAllCustomersEntity;

  const GetAllCustomersSuccess({required this.getAllCustomersEntity});
}

class GetAllCustomersError extends GetAllCustomersState {
  final String message;

  const GetAllCustomersError({required this.message});
}
