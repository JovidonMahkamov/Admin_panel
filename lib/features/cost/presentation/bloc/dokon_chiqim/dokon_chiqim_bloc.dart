import 'dart:io';
import 'package:admin_panel/features/cost/domain/usecase/dokon_chiqim_use_case.dart';
import 'package:admin_panel/features/cost/presentation/bloc/cost_event.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dokon_chiqim_state.dart';

String _mapError(DioException e) {
  if (e.type == DioExceptionType.unknown && e.error is SocketException) {
    return 'Internet ulanmagan.';
  } else if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout) {
    return "So'rov vaqtida javob kelmadi.";
  } else if (e.response?.statusCode == 400) {
    return e.response?.data?['message']?.toString() ?? "Ma'lumot noto'g'ri.";
  } else if (e.response?.statusCode == 500) {
    return 'Serverda nosozlik bor.';
  }
  return "Noma'lum xato yuz berdi.";
}

// ===== GET =====
class GetDokonChiqimBloc extends Bloc<DokonChiqimEvent, GetDokonChiqimState> {
  final GetDokonChiqimUseCase useCase;

  GetDokonChiqimBloc(this.useCase) : super(GetDokonChiqimInitial()) {
    on<GetDokonChiqimE>((event, emit) async {
      emit(GetDokonChiqimLoading());
      try {
        final result = await useCase(tolovTuri: event.tolovTuri);
        emit(GetDokonChiqimSuccess(items: result));
      } on DioException catch (e) {
        emit(GetDokonChiqimError(message: _mapError(e)));
      } catch (_) {
        emit(GetDokonChiqimError(message: "Noma'lum xato yuz berdi."));
      }
    });
  }
}

// ===== POST =====
class PostDokonChiqimBloc extends Bloc<DokonChiqimEvent, PostDokonChiqimState> {
  final PostDokonChiqimUseCase useCase;

  PostDokonChiqimBloc(this.useCase) : super(PostDokonChiqimInitial()) {
    on<PostDokonChiqimE>((event, emit) async {
      emit(PostDokonChiqimLoading());
      try {
        await useCase(
          tolovTuri: event.tolovTuri,
          summa: event.summa,
          izoh: event.izoh,
          tavsif: event.tavsif,
        );
        emit(PostDokonChiqimSuccess());
      } on DioException catch (e) {
        emit(PostDokonChiqimError(message: _mapError(e)));
      } catch (_) {
        emit(PostDokonChiqimError(message: "Noma'lum xato yuz berdi."));
      }
    });
  }
}

// ===== PATCH =====
class PatchDokonChiqimBloc extends Bloc<DokonChiqimEvent, PatchDokonChiqimState> {
  final PatchDokonChiqimUseCase useCase;

  PatchDokonChiqimBloc(this.useCase) : super(PatchDokonChiqimInitial()) {
    on<PatchDokonChiqimE>((event, emit) async {
      emit(PatchDokonChiqimLoading());
      try {
        await useCase(
          id: event.id,
          tolovTuri: event.tolovTuri,
          summa: event.summa,
          izoh: event.izoh,
          tavsif: event.tavsif,
        );
        emit(PatchDokonChiqimSuccess());
      } on DioException catch (e) {
        emit(PatchDokonChiqimError(message: _mapError(e)));
      } catch (_) {
        emit(PatchDokonChiqimError(message: "Noma'lum xato yuz berdi."));
      }
    });
  }
}

// ===== DELETE =====
class DeleteDokonChiqimBloc extends Bloc<DokonChiqimEvent, DeleteDokonChiqimState> {
  final DeleteDokonChiqimUseCase useCase;

  DeleteDokonChiqimBloc(this.useCase) : super(DeleteDokonChiqimInitial()) {
    on<DeleteDokonChiqimE>((event, emit) async {
      emit(DeleteDokonChiqimLoading());
      try {
        await useCase(id: event.id);
        emit(DeleteDokonChiqimSuccess());
      } on DioException catch (e) {
        emit(DeleteDokonChiqimError(message: _mapError(e)));
      } catch (_) {
        emit(DeleteDokonChiqimError(message: "Noma'lum xato yuz berdi."));
      }
    });
  }
}