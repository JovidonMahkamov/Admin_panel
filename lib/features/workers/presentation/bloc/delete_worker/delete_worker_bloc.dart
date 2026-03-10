import 'dart:io';
import 'package:admin_panel/features/workers/domain/usecase/delete_worker_use_case.dart';
import 'package:admin_panel/features/workers/presentation/bloc/delete_worker/delete_worker_state.dart';
import 'package:admin_panel/features/workers/presentation/bloc/worker_event.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteWorkerBloc extends Bloc<WorkerEvent, DeleteWorkerState>{
  final DeleteWorkerUseCase deleteWorkerUseCase;

  DeleteWorkerBloc(this.deleteWorkerUseCase) : super(DeleteWorkerInitial()) {
    on<DeleteWorkerE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(DeleteWorkerLoading());
    try {
      final result = await deleteWorkerUseCase(
        id: event.id,
      );
      emit(DeleteWorkerSuccess(deleteWorkerResponseEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(DeleteWorkerError( message: errorMessage));
    } catch (e) {
      emit(DeleteWorkerError(message: "Noma’lum xato yuz berdi"));
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