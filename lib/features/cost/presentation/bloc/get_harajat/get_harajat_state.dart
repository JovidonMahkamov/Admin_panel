import 'package:admin_panel/features/cost/domain/entity/cost_entity.dart';

abstract class GetHarajatState {
  const GetHarajatState();
}

class GetHarajatInitial extends GetHarajatState {}

class GetHarajatLoading extends GetHarajatState {}

class GetHarajatSuccess extends GetHarajatState {
  final CostEntity costEntity;

  const GetHarajatSuccess({required this.costEntity});
}

class GetHarajatError extends GetHarajatState {
  final String message;

  const GetHarajatError({required this.message});
}
