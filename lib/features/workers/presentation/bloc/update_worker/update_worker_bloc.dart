import 'dart:io';
import 'package:admin_panel/features/workers/domain/entity/update_worker_request_entity.dart';
import 'package:admin_panel/features/workers/domain/usecase/update_worker_use_case.dart';
import 'package:admin_panel/features/workers/presentation/bloc/update_worker/update_worker_state.dart';
import 'package:admin_panel/features/workers/presentation/bloc/worker_event.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateWorkerBloc extends Bloc<WorkerEvent, UpdateWorkerState> {
  final UpdateWorkerUseCase updateWorkerUseCase;

  UpdateWorkerBloc(this.updateWorkerUseCase) : super(UpdateWorkerInitial()) {
    on<UpdateWorkerE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(UpdateWorkerLoading());
    try {
      final result = await updateWorkerUseCase(
        UpdateWorkerRequestEntity(
        id: event.id,
        fish: event.fish,
        login: event.login,
        parol: event.parol,
        telefon: event.telefon,
        ),
      );
      emit(UpdateWorkerSuccess(updateWorkerResponseEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(UpdateWorkerError( message: errorMessage));
    } catch (e) {
      emit(UpdateWorkerError(message: "Noma’lum xato yuz berdi"));
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