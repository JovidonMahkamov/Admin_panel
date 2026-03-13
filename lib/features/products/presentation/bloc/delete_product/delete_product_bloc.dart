import 'package:admin_panel/features/products/domain/usecase/delete_product_usecase.dart';
import 'package:admin_panel/features/products/presentation/bloc/products_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'delete_product_state.dart';

class DeleteProductBloc extends Bloc<ProductsEvent, DeleteProductState> {
  final DeleteProductUseCase deleteProductUseCase;

  DeleteProductBloc(this.deleteProductUseCase)
      : super(const DeleteProductInitial()) {
    on<DeleteProductE>(_onDeleteProductByIdEvent);
  }
  Future<void> _onDeleteProductByIdEvent(
      DeleteProductE event,
      Emitter<DeleteProductState> emit,
      ) async {
    emit(const DeleteProductLoading());
    try {
      final result = await deleteProductUseCase(id:  event.id);
      emit(DeleteProductSuccess(result));
    } catch (e) {
      emit(DeleteProductError(e.toString()));
    }
  }
}