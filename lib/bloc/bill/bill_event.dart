part of 'bill_bloc.dart';

@immutable
sealed class BillEvent {}

class LoadDayGraph extends BillEvent {}

class LoadWeekGraph extends BillEvent {}

class LoadMonthGraph extends BillEvent {}

class ViewAllGraph extends BillEvent {}

class LoadAllSales extends BillEvent {}

class LoadAllPrintableSales extends BillEvent {}
