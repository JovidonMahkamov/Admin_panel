import 'dart:io';
import 'package:admin_panel/features/customer/domain/usecase/create_customer_use_case.dart';
import 'package:admin_panel/features/customer/presentation/bloc/create_customer/create_customer_state.dart';
import 'package:admin_panel/features/customer/presentation/bloc/customer_event.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateCustomerBloc extends Bloc<CustomerEvent, CreateCustomerState> {
  final CreateCustomerUseCase createCustomerUseCase;

  CreateCustomerBloc(this.createCustomerUseCase) : super(CreateCustomerInitial()) {
    on<CreateCustomerE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(CreateCustomerLoading());
    try {
      final result = await createCustomerUseCase(
          createCustomer: event.createCustomer,
      );
      emit(CreateCustomerSuccess(createCustomerResponseEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(CreateCustomerError( message: errorMessage));
    } catch (e) {
      emit(CreateCustomerError(message: "Noma’lum xato yuz berdi"));
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