import 'dart:io';
import 'package:admin_panel/features/cost/domain/usecase/delete_harajat_use_case.dart';
import 'package:admin_panel/features/cost/presentation/bloc/cost_event.dart';
import 'package:admin_panel/features/cost/presentation/bloc/delete_harajat/delete_harajat_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteHarajatBloc extends Bloc<CostEvent, DeleteHarajatState> {
  final DeleteHarajatUseCase deleteHarajatUseCase;

  DeleteHarajatBloc(this.deleteHarajatUseCase) : super(DeleteHarajatInitial()) {
    on<DeleteHarajatE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(DeleteHarajatLoading());
    try {
      final result = await deleteHarajatUseCase(
        id: event.id,
      );
      emit(DeleteHarajatSuccess(deleteExpenseEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(DeleteHarajatError( message: errorMessage));
    } catch (e) {
      emit(DeleteHarajatError(message: "Noma’lum xato yuz berdi"));
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