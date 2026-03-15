import 'dart:io';
import 'package:admin_panel/features/cost/domain/usecase/delete_kassa_use_case.dart';
import 'package:admin_panel/features/cost/presentation/bloc/cost_event.dart';
import 'package:admin_panel/features/cost/presentation/bloc/delete_kassa/delete_kassa_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteKassaBloc extends Bloc<CostEvent, DeleteKassaState> {
  final DeleteKassaUseCase deleteKassaUseCase;

  DeleteKassaBloc(this.deleteKassaUseCase) : super(DeleteKassaInitial()) {
    on<DeleteKassaE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(DeleteKassaLoading());
    try {
      final result = await deleteKassaUseCase(
        id: event.id,
      );
      emit(DeleteKassaSuccess(deleteCashExpenseEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(DeleteKassaError( message: errorMessage));
    } catch (e) {
      emit(DeleteKassaError(message: "Noma’lum xato yuz berdi"));
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