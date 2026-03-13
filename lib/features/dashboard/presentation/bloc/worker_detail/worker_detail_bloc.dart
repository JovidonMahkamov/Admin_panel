import 'dart:io';
import 'package:admin_panel/features/dashboard/domain/usecase/worker_detail_use_case.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/worker_detail/worker_detail_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkerDetailBloc extends Bloc<DashboardEvent, WorkerDetailState> {
  final WorkerDetailUseCase workerDetailUseCase;

  WorkerDetailBloc(this.workerDetailUseCase) : super(WorkerDetailInitial()) {
    on<WorkerDetailE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(WorkerDetailLoading());
    try {
      final result = await workerDetailUseCase(
        sana: event.sana,
        id: event.id,
      );
      emit(WorkerDetailSuccess(workerDetailEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(WorkerDetailError( message: errorMessage));
    } catch (e) {
      emit(WorkerDetailError(message: "Noma’lum xato yuz berdi"));
    }
  }

  String _mapDioErrorToMessage(DioException error) {
    if (error.type == DioExceptionType.unknown &&
        error.error is SocketException) {
      return "Internet ulanmagan. Iltimos, tarmoqni tekshiring.";
    } else if (error.response?.statusCode == 400) {
      return "Kiritilgan kod xato";
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return "So‘rov vaqtida javob kelmadi. Keyinroq urinib ko‘ring.";
    } else if (error.response?.statusCode == 500) {
      return "Serverda nosozlik bor. Iltimos, keyinroq urinib ko‘ring.";
    }

    return "Noma’lum xato yuz berdi. Iltimos, qayta urinib ko‘ring.";
  }}