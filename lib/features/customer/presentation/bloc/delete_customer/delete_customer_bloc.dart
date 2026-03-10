import 'dart:io';
import 'package:admin_panel/features/customer/domain/usecase/delete_customer_use_case.dart';
import 'package:admin_panel/features/customer/presentation/bloc/customer_event.dart';
import 'package:admin_panel/features/customer/presentation/bloc/delete_customer/delete_customer_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteCustomerBloc extends Bloc<CustomerEvent, DeleteCustomerState>{
  final DeleteCustomerUseCase deleteCustomerUseCase;

  DeleteCustomerBloc(this.deleteCustomerUseCase) : super(DeleteCustomerInitial()) {
    on<DeleteCustomerE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(DeleteCustomerLoading());
    try {
      final result = await deleteCustomerUseCase(
        id: event.id,
      );
      emit(DeleteCustomerSuccess(deleteCustomerResponseEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(DeleteCustomerError( message: errorMessage));
    } catch (e) {
      emit(DeleteCustomerError(message: "Noma’lum xato yuz berdi"));
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