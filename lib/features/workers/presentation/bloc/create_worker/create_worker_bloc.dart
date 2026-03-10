import 'dart:io';
import 'package:admin_panel/features/workers/domain/usecase/create_worker_use_case.dart';
import 'package:admin_panel/features/workers/presentation/bloc/create_worker/create_worker_state.dart';
import 'package:admin_panel/features/workers/presentation/bloc/worker_event.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateWorkerBloc extends Bloc<WorkerEvent, CreateWorkerState> {
  final CreateWorkerUseCase createWorkerUseCase;

  CreateWorkerBloc(this.createWorkerUseCase) : super(CreateWorkerInitial()) {
    on<CreateWorkerE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(CreateWorkerLoading());
    try {
      final result = await createWorkerUseCase(
        fish: event.fish,
        login: event.login,
        parol: event.parol,
        telefon: event.telefon,
      );
      emit(CreateWorkerSuccess(createWorkerResponseEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(CreateWorkerError( message: errorMessage));
    } catch (e) {
      emit(CreateWorkerError(message: "Noma’lum xato yuz berdi"));
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