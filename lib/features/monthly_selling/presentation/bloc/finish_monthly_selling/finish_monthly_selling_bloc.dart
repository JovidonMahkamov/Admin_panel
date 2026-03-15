import 'dart:io';
import 'package:admin_panel/features/monthly_selling/domain/usecase/finish_monthly_sales_use_case.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../monthly_selling_event.dart';
import 'finish_monthly_selling_state.dart';

class FinishMonthlySellingBloc
    extends Bloc<MonthlySellingEvent, FinishMonthlySellingState> {
  final FinishMonthlySalesUseCase finishMonthlySalesUseCase;

  FinishMonthlySellingBloc(this.finishMonthlySalesUseCase)
      : super(FinishMonthlySellingInitial()) {
    on<FinishMonthlySellingE>(onFinishMonthlySelling);
  }

  Future<void> onFinishMonthlySelling(
      FinishMonthlySellingE event,
      Emitter<FinishMonthlySellingState> emit,
      ) async {
    emit(FinishMonthlySellingLoading());

    try {
      final result = await finishMonthlySalesUseCase(
        oy: event.oy,
      );

      emit(
        FinishMonthlySellingSuccess(
          finishMonthlySalesEntity: result,
        ),
      );
    } on DioException catch (e) {
      final message = _mapDioErrorToMessage(e);
      emit(FinishMonthlySellingError(message: message));
    } catch (e, s) {
      debugPrint('FinishMonthlySelling error: $e');
      debugPrintStack(stackTrace: s);
      emit(FinishMonthlySellingError(message: e.toString()));
    }
  }

  String _mapDioErrorToMessage(DioException error) {
    if (error.type == DioExceptionType.unknown &&
        error.error is SocketException) {
      return "Internet ulanmagan. Iltimos, tarmoqni tekshiring.";
    } else if (error.response?.statusCode == 400) {
      return error.response?.data?['message']?.toString() ??
          "Ma'lumot noto‘g‘ri yuborildi";
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return "So‘rov vaqtida javob kelmadi. Keyinroq urinib ko‘ring.";
    } else if (error.response?.statusCode == 500) {
      return "Serverda nosozlik bor. Iltimos, keyinroq urinib ko‘ring.";
    }

    return error.response?.data?['message']?.toString() ??
        "Noma’lum xato yuz berdi. Iltimos, qayta urinib ko‘ring.";
  }
}