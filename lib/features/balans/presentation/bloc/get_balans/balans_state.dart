import 'package:admin_panel/features/balans/domain/entity/balans_entity.dart';

abstract class GetBalansState {
  const GetBalansState();
}

class GetBalansInitial extends GetBalansState {}

class GetBalansLoading extends GetBalansState {}

class GetBalansSuccess extends GetBalansState {
  final BalansEntity balans;
  const GetBalansSuccess({required this.balans});
}

class GetBalansError extends GetBalansState {
  final String message;
  const GetBalansError({required this.message});
}