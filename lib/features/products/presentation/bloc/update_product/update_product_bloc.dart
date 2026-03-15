import 'dart:io';
import 'package:admin_panel/features/products/domain/usecase/update_product_use_case.dart';
import 'package:admin_panel/features/products/presentation/bloc/products_event.dart';
import 'package:admin_panel/features/products/presentation/bloc/update_product/update_product_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateProductBloc extends Bloc<ProductsEvent, UpdateProductState> {
  final UpdateProductUseCase updateProductUseCase;

  UpdateProductBloc(this.updateProductUseCase) : super(UpdateProductInitial()) {
    on<UpdateProductE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(UpdateProductLoading());
    try {
      final result = await updateProductUseCase(
        id: event.id,
        nomi: event.nomi,
        narxDona: event.narxDona,
        narxMetr: event.narxMetr,
        narxPochka: event.narxPochka,
        pochka: event.pochka,
        metr: event.metr,
        miqdor: event.miqdor,
        kelganNarx: event.kelganNarx,
        jamiNarx: event.jamiNarx,
        rasm: event.rasm,
      );
      emit(UpdateProductSuccess(updateProductEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(UpdateProductError( message: errorMessage));
    } catch (e) {
      emit(UpdateProductError(message: "Noma’lum xato yuz berdi"));
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