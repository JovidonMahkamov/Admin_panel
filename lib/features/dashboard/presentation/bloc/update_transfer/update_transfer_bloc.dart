import 'dart:io';
import 'package:admin_panel/features/dashboard/domain/usecase/update_transfer_use_case.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/update_transfer/update_transfer_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateTransferBloc extends Bloc<DashboardEvent, UpdateTransferState> {
  final UpdateTransferUseCase updateTransferUseCase;

  UpdateTransferBloc(this.updateTransferUseCase) : super(UpdateTransferInitial()) {
    on<UpdateTransferE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(UpdateTransferLoading());
    try {
      final result = await updateTransferUseCase(
        dan: event.dan,
        ga: event.ga,
        summa: event.summa,
      );
      emit(UpdateTransferSuccess(transferResponseEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(UpdateTransferError( message: errorMessage));
    } catch (e) {
      emit(UpdateTransferError(message: "Noma’lum xato yuz berdi"));
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