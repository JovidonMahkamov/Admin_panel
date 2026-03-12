import 'dart:io';
import 'package:admin_panel/features/customer/domain/usecase/get_all_customers_use_case.dart';
import 'package:admin_panel/features/customer/domain/usecase/update_customer_use_case.dart';
import 'package:admin_panel/features/customer/presentation/bloc/customer_event.dart';
import 'package:admin_panel/features/customer/presentation/bloc/get_all_customers/get_all_customers_state.dart';
import 'package:admin_panel/features/customer/presentation/bloc/update_customer/update_customer_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateCustomerBloc extends Bloc<CustomerEvent, UpdateCustomerState> {
  final UpdateCustomerUseCase updateCustomerUseCase;

  UpdateCustomerBloc(this.updateCustomerUseCase) : super(UpdateCustomersInitial()) {
    on<UpdateCustomerE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(UpdateCustomersLoading());
    try {
      final result = await updateCustomerUseCase(
        id: event.id,
        fish: event.fish,
        manzil: event.manzil,
        qarzdorlik: event.qarzdorlik,
        telefon: event.telefon,
      );
      emit(UpdateCustomersSuccess(updateCustomerEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(UpdateCustomersError( message: errorMessage));
    } catch (e) {
      emit(UpdateCustomersError(message: "Noma’lum xato yuz berdi"));
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