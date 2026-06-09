part of 'create_bill_bloc.dart';

@immutable
sealed class CreateBillState {}

final class CreateBillInitial extends CreateBillState {}

final class CreateBillLoaded extends CreateBillState {
  final List<Product> products;
  final double total;

  CreateBillLoaded({required this.products, required this.total});
}

final class AllItemsLoaded extends CreateBillState {
  final List<Map<String, dynamic>> items;

  AllItemsLoaded({required this.items});
}
