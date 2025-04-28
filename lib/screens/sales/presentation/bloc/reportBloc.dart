import 'package:awee/constants/api.dart';
import 'package:awee/screens/sales/model/sales_entery.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(ReportInitial()) {
    on<FetchReportData>((event, emit) async {
      emit(ReportLoading());

      try {
        // Fetch KPI Summary
        final summaryRes = await http.get(Uri.parse('$baseUrl/reports'));
        final summaryData = jsonDecode(summaryRes.body);

        print('Summary Response Body: ${summaryRes.body}');

        // Fetch Sales-by-Date
        final salesRes = await http.get(
          Uri.parse('$baseUrl/reports/sales-by-date'),
        );
        final List<dynamic> salesList = jsonDecode(salesRes.body);

        final salesEntries =
            salesList.map((e) => SalesEntry.fromJson(e)).toList();

        print('Sales Response Body: ${salesRes.body}');

        // Fetch Order Status Summary
        final orderStatusRes = await http.get(
          Uri.parse('$baseUrl/reports/order-status-summary'),
        );
        final orderStatusData = jsonDecode(orderStatusRes.body);
        final orderStatusSummary = OrderStatusSummary.fromJson(orderStatusData);

        // Emit loaded
        emit(
          ReportLoaded(
            totalSales: (summaryData['totalSales'] ?? 0).toDouble(),
            totalOrders: (summaryData['totalOrders'] ?? 0).toInt(),
            totalCustomers: (summaryData['totalCustomers'] ?? 0).toInt(),
            salesEntries: salesEntries,
            orderStatusSummary: orderStatusSummary, // pass it!
          ),
        );
      } catch (e) {
        emit(ReportError(e.toString()));
      }
    });
  }
}

class OrderStatusSummary {
  final int pending;
  final int accepted;
  final int delivered;

  OrderStatusSummary({
    required this.pending,
    required this.accepted,
    required this.delivered,
  });

  factory OrderStatusSummary.fromJson(Map<String, dynamic> json) {
    return OrderStatusSummary(
      pending: json['pending'] ?? 0,
      accepted: json['accepted'] ?? 0,
      delivered: json['delivered'] ?? 0,
    );
  }
}
