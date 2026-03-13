import 'dart:io';
import 'package:admin_panel/features/cost/domain/usecase/post_harajat_use_case.dart';
import 'package:admin_panel/features/cost/presentation/bloc/cost_event.dart';
import 'package:admin_panel/features/cost/presentation/bloc/post_harajat/post_harajat_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostCostBloc extends Bloc<CostEvent, PostHarajatState> {
  final PostHarajatUseCase postHarajatUseCase;

  PostCostBloc(this.postHarajatUseCase) : super(PostHarajatInitial()) {
    on<PostHarajatE>(onPostHarajat);
  }

  Future<void> onPostHarajat(
      PostHarajatE event,
      Emitter<PostHarajatState> emit,
      ) async {
    emit(PostHarajatLoading());

    try {
      final result = await postHarajatUseCase(request:  event.request);
      emit(PostHarajatSuccess(expense: result));
    } on DioException catch (e) {
      final errorMessage = _mapDioErrorToMessage(e);
      emit(PostHarajatError(message: errorMessage));
    } catch (e) {
      emit(const PostHarajatError(message: "Noma’lum xato yuz berdi"));
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