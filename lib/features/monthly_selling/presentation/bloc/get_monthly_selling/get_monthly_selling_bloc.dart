import 'dart:io';
import 'package:admin_panel/features/monthly_selling/domain/usecase/get_monthly_selling_use_case.dart';
import 'package:admin_panel/features/monthly_selling/presentation/bloc/get_monthly_selling/get_monthly_selling_state.dart';
import 'package:admin_panel/features/monthly_selling/presentation/bloc/monthly_selling_event.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetMonthlySellingBloc extends Bloc<MonthlySellingEvent, GetMonthlySellingState> {
  final GetMonthlySellingUseCase getMonthlySellingUseCase;

  GetMonthlySellingBloc(this.getMonthlySellingUseCase) : super(GetMonthlySellingInitial()) {
    on<MonthlySellingE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(GetMonthlySellingLoading());
    try {
      final result = await getMonthlySellingUseCase();
      emit(GetMonthlySellingSuccess(monthlySalesEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(GetMonthlySellingError( message: errorMessage));
    } catch (e) {
      emit(GetMonthlySellingError(message: "Noma’lum xato yuz berdi"));
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