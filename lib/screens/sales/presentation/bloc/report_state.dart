import 'package:awee/screens/sales/model/sales_entery.dart';
import 'package:awee/screens/sales/presentation/bloc/reportBloc.dart';

abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportLoaded extends ReportState {
  final double totalSales;
  final int totalOrders;
  final int totalCustomers;
  final List<SalesEntry> salesEntries;
  final OrderStatusSummary orderStatusSummary; // 🔥 New field

  ReportLoaded({
    required this.totalSales,
    required this.totalOrders,
    required this.totalCustomers,
    required this.salesEntries,
    required this.orderStatusSummary,
  });
}

class ReportError extends ReportState {
  final String message;

  ReportError(this.message);
}
