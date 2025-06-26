part of 'create_bill_bloc.dart';

@immutable
sealed class CreateBillEvent {}

final class ProductAdded extends CreateBillEvent {
  final Product product;

  ProductAdded(this.product);
}

final class ProductUpdated extends CreateBillEvent {
  final Product product;

  ProductUpdated(this.product);
}

final class ProductDeleted extends CreateBillEvent {
  final String productId;

  ProductDeleted(this.productId);
}

final class ClearProducts extends CreateBillEvent {}
