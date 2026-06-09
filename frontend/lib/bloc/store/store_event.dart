part of 'store_bloc.dart';

@immutable
sealed class StoreEvent {}

class LoadAllStores extends StoreEvent {}