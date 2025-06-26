part of 'store_bloc.dart';

@immutable
sealed class StoreState {}

final class StoreInitial extends StoreState {}

class AllStoresState extends StoreState {
  final List<Map<String, dynamic>> stores;
  AllStoresState(this.stores);
}