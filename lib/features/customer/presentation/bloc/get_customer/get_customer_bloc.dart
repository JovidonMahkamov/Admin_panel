import 'dart:io';
import 'package:admin_panel/features/customer/domain/usecase/get_all_customers_use_case.dart';
import 'package:admin_panel/features/customer/domain/usecase/get_customer_detail_use_case.dart';
import 'package:admin_panel/features/customer/presentation/bloc/customer_event.dart';
import 'package:admin_panel/features/customer/presentation/bloc/get_customer/get_customer_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetCustomerBloc extends Bloc<CustomerEvent, GetCustomerState> {
  final GetCustomerDetailUseCase getCustomerDetailUseCase;

  GetCustomerBloc(this.getCustomerDetailUseCase) : super(GetCustomerInitial()) {
    on<GetCustomersE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(GetCustomerLoading());
    try {
      final result = await getCustomerDetailUseCase(id: event.id);
      emit(GetCustomerSuccess(getCustomerDetailEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(GetCustomerError( message: errorMessage));
    } catch (e) {
      emit(GetCustomerError(message: "Noma’lum xato yuz berdi"));
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