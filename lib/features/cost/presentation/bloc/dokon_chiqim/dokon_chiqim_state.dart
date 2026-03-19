import 'package:admin_panel/features/cost/domain/entity/dokon_chiqim_entity.dart';

// ===== GET =====
abstract class GetDokonChiqimState {}
class GetDokonChiqimInitial extends GetDokonChiqimState {}
class GetDokonChiqimLoading extends GetDokonChiqimState {}
class GetDokonChiqimSuccess extends GetDokonChiqimState {
  final List<DokonChiqimEntity> items;
  GetDokonChiqimSuccess({required this.items});
}
class GetDokonChiqimError extends GetDokonChiqimState {
  final String message;
  GetDokonChiqimError({required this.message});
}

// ===== POST =====
abstract class PostDokonChiqimState {}
class PostDokonChiqimInitial extends PostDokonChiqimState {}
class PostDokonChiqimLoading extends PostDokonChiqimState {}
class PostDokonChiqimSuccess extends PostDokonChiqimState {}
class PostDokonChiqimError extends PostDokonChiqimState {
  final String message;
  PostDokonChiqimError({required this.message});
}

// ===== PATCH =====
abstract class PatchDokonChiqimState {}
class PatchDokonChiqimInitial extends PatchDokonChiqimState {}
class PatchDokonChiqimLoading extends PatchDokonChiqimState {}
class PatchDokonChiqimSuccess extends PatchDokonChiqimState {}
class PatchDokonChiqimError extends PatchDokonChiqimState {
  final String message;
  PatchDokonChiqimError({required this.message});
}

// ===== DELETE =====
abstract class DeleteDokonChiqimState {}
class DeleteDokonChiqimInitial extends DeleteDokonChiqimState {}
class DeleteDokonChiqimLoading extends DeleteDokonChiqimState {}
class DeleteDokonChiqimSuccess extends DeleteDokonChiqimState {}
class DeleteDokonChiqimError extends DeleteDokonChiqimState {
  final String message;
  DeleteDokonChiqimError({required this.message});
}