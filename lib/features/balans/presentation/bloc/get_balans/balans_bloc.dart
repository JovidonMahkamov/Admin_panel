import 'dart:io';
import 'package:admin_panel/features/balans/domain/usecase/balans_use_case.dart';
import 'package:admin_panel/features/balans/presentation/bloc/balans_event.dart';
import 'package:admin_panel/features/balans/presentation/bloc/get_balans/balans_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class GetBalansBloc extends Bloc<BalansEvent, GetBalansState> {
  final GetBalansUseCase getBalansUseCase;

  GetBalansBloc(this.getBalansUseCase) : super(GetBalansInitial()) {
    on<GetBalansE>(_onGetBalans);
  }

  Future<void> _onGetBalans(GetBalansE event, Emitter<GetBalansState> emit) async {
    emit(GetBalansLoading());
    try {
      final result = await getBalansUseCase();
      emit(GetBalansSuccess(balans: result));
    } on DioException catch (e) {
      emit(GetBalansError(message: _mapError(e)));
    } catch (e) {
      emit(const GetBalansError(message: "Noma'lum xato yuz berdi"));
    }
  }

  String _mapError(DioException error) {
    if (error.type == DioExceptionType.unknown && error.error is SocketException) {
      return "Internet ulanmagan.";
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return "So'rov vaqtida javob kelmadi.";
    } else if (error.response?.statusCode == 500) {
      return "Serverda nosozlik bor.";
    }
    return "Noma'lum xato yuz berdi.";
  }
}