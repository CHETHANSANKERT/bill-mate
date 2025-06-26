import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../model/bill/sale.dart';

part 'create_bill_event.dart';
part 'create_bill_state.dart';

class CreateBillBloc extends Bloc<CreateBillEvent, CreateBillState> {
  CreateBillBloc() : super(CreateBillInitial()) {
    on<ProductAdded>((event, emit) {
      final currentState = state;
      if (currentState is CreateBillLoaded) {
        final updatedProducts = List<Product>.from(currentState.products)
          ..add(event.product);
        final total = updatedProducts.fold<double>(
            0, (sum, product) => sum + product.total);
        emit(CreateBillLoaded(products: updatedProducts, total: total));
      } else {
        emit(CreateBillLoaded(
            products: [event.product], total: event.product.total));
      }
    });

    on<ProductUpdated>((event, emit) {
      final currentState = state;
      if (currentState is CreateBillLoaded) {
        final updatedProducts = currentState.products.map((product) {
          return product.item.id == event.product.item.id
              ? event.product
              : product;
        }).toList();
        final total = updatedProducts.fold<double>(
            0, (sum, product) => sum + product.total);
        emit(CreateBillLoaded(products: updatedProducts, total: total));
      }
    });

    on<ProductDeleted>((event, emit) {
      final currentState = state;
      if (currentState is CreateBillLoaded) {
        final updatedProducts = currentState.products
            .where((product) => product.item.id != event.productId)
            .toList();
        final total = updatedProducts.fold<double>(
            0, (sum, product) => sum + product.total);
        emit(CreateBillLoaded(products: updatedProducts, total: total));
      }
    });

    on<ClearProducts>((event, emit) {
      emit(CreateBillLoaded(products: const [], total: 0));
    });
  }
}
