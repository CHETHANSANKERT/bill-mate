part of 'bill_bloc.dart';

@immutable
sealed class BillEvent {}

class LoadThisMonthGraph extends BillEvent {}

class LoadLastMonthGraph extends BillEvent {}

class LoadAllSales extends BillEvent {}

class LoadAllPrintableSales extends BillEvent {}
