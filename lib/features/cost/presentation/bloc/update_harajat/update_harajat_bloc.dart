import 'dart:io';
import 'package:admin_panel/features/cost/domain/usecase/update_harajat_use_case.dart';
import 'package:admin_panel/features/cost/presentation/bloc/cost_event.dart';
import 'package:admin_panel/features/cost/presentation/bloc/update_harajat/update_harajat_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateHarajatBloc extends Bloc<CostEvent, UpdateHarajatState> {
  final UpdateHarajatUseCase updateHarajatUseCase;

  UpdateHarajatBloc(this.updateHarajatUseCase) : super(UpdateHarajatInitial()) {
    on<UpdateHarajatE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(UpdateHarajatLoading());
    try {
      final result = await updateHarajatUseCase(
        id: event.id,
        ishchiId: event.ishchiId,
        izoh: event.izoh,
        sms: event.sms,
        summa: event.summa,
        tolovTuri: event.tolovTuri,
      );
      emit(UpdateHarajatSuccess(updateExpenseEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(UpdateHarajatError( message: errorMessage));
    } catch (e) {
      emit(UpdateHarajatError(message: "Noma’lum xato yuz berdi"));
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