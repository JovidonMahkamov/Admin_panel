import 'dart:io';

import 'package:admin_panel/features/products/domain/usecase/create_product_use_case.dart';
import 'package:admin_panel/features/products/presentation/bloc/create_product/create_product_state.dart';
import 'package:admin_panel/features/products/presentation/bloc/products_event.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateProductBloc extends Bloc<ProductsEvent, CreateProductState> {
  final CreateProductUseCase createProductUseCase;

  CreateProductBloc(this.createProductUseCase) : super(CreateProductInitial()) {
    on<CreateProductE>(_onCreateProduct);
  }

  Future<void> _onCreateProduct(
      CreateProductE event,
      Emitter<CreateProductState> emit,
      ) async {
    emit(CreateProductLoading());

    try {
      final result = await createProductUseCase(create: event.create);
      emit(CreateProductSuccess(productEntity: result));
    } on DioException catch (e) {
      emit(CreateProductError(message: _mapDioErrorToMessage(e)));
    } catch (e) {
      emit(const CreateProductError(message: "Noma’lum xato yuz berdi"));
    }
  }

  String _mapDioErrorToMessage(DioException error) {
    if (error.type == DioExceptionType.unknown &&
        error.error is SocketException) {
      return "Internet ulanmagan. Iltimos, tarmoqni tekshiring.";
    } else if (error.response?.statusCode == 400) {
      return "Kiritilgan ma’lumot noto‘g‘ri.";
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return "So‘rov vaqtida javob kelmadi. Keyinroq urinib ko‘ring.";
    } else if (error.response?.statusCode == 500) {
      return "Serverda nosozlik bor. Keyinroq urinib ko‘ring.";
    }

    return "Noma’lum xato yuz berdi. Iltimos, qayta urinib ko‘ring.";
  }
}