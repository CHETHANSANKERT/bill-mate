part of 'bill_bloc.dart';

abstract class BillState {}

class BillInitial extends BillState {}

class GraphState extends BillState {
  final List<MapEntry<String, double>> data;
  final double total;
  GraphState(this.data, this.total);
}

class AllSalesState extends BillState {
  final List<Map<String, dynamic>> sales;
  AllSalesState(this.sales);
}

class AllPrintableSalesState extends BillState {
  final List<Map<String, dynamic>> sales;
  AllPrintableSalesState(this.sales);
}
