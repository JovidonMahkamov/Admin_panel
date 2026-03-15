import 'dart:io';
import 'package:admin_panel/features/cost/domain/usecase/post_kassa_use_case.dart';
import 'package:admin_panel/features/cost/presentation/bloc/cost_event.dart';
import 'package:admin_panel/features/cost/presentation/bloc/post_kassa/post_kassa_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostKassaBloc extends Bloc<CostEvent, PostKassaState> {
  final PostKassaUseCase postKassaUseCase;

  PostKassaBloc(this.postKassaUseCase) : super(PostKassaInitial()) {
    on<PostKassaE>(onPostKassa);
  }

  Future<void> onPostKassa(
      PostKassaE event,
      Emitter<PostKassaState> emit,
      ) async {
    emit(PostKassaLoading());

    try {
      final result = await postKassaUseCase(
        doKon: event.doKon,
        izoh: event.izoh,
        mahsulotNomi: event.mahsulotNomi,
        sms: event.sms,
        summa: event.summa,
        tolovTuri: event.tolovTuri,
      );

      emit(PostKassaSuccess(expense: result));
    } on DioException catch (e) {
      final errorMessage = _mapDioErrorToMessage(e);
      emit(PostKassaError(message: errorMessage));
    } catch (e) {
      emit(const PostKassaError(message: "Noma’lum xato yuz berdi"));
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