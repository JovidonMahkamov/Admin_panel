import 'package:admin_panel/features/history/domain/entity/history_entity.dart';

abstract class GetHistoryState {
  const GetHistoryState();
}

class GetHistoryInitial extends GetHistoryState {}

class GetHistoryLoading extends GetHistoryState {}

class GetHistorySuccess extends GetHistoryState {
  final HistoryEntity historyEntity;

  const GetHistorySuccess({required this.historyEntity});
}

class GetHistoryError extends GetHistoryState {
  final String message;

  const GetHistoryError({required this.message});
}
