import 'dart:io';
import 'package:admin_panel/features/products/domain/usecase/get_products_use_case.dart';
import 'package:admin_panel/features/products/presentation/bloc/get_products/get_products_state.dart';
import 'package:admin_panel/features/products/presentation/bloc/products_event.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetProductsBloc extends Bloc<ProductsEvent, GetProductsState> {
  final GetProductUseCase getProductUseCase;

  GetProductsBloc(this.getProductUseCase) : super(GetProductsInitial()) {
    on<GetProductsE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(GetProductsLoading());
    try {
      final result = await getProductUseCase();
      emit(GetProductsSuccess(productEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(GetProductsError( message: errorMessage));
    } catch (e) {
      emit(GetProductsError(message: "Noma’lum xato yuz berdi"));
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