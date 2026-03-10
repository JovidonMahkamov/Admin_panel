import 'dart:io';
import 'package:admin_panel/features/customer/domain/usecase/get_all_customers_use_case.dart';
import 'package:admin_panel/features/customer/presentation/bloc/customer_event.dart';
import 'package:admin_panel/features/customer/presentation/bloc/get_all_customers/get_all_customers_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetAllCustomersBloc extends Bloc<CustomerEvent, GetAllCustomersState> {
  final GetAllCustomersUseCase getAllCustomersUseCase;

  GetAllCustomersBloc(this.getAllCustomersUseCase) : super(GetAllCustomersInitial()) {
    on<GetAllCustomersE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(GetAllCustomersLoading());
    try {
      final result = await getAllCustomersUseCase();
      emit(GetAllCustomersSuccess(getAllCustomersEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(GetAllCustomersError( message: errorMessage));
    } catch (e) {
      emit(GetAllCustomersError(message: "Noma’lum xato yuz berdi"));
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