import 'package:awee/screens/sales/model/sales_entery.dart';
import 'package:awee/screens/sales/presentation/bloc/reportBloc.dart';
import 'package:awee/screens/sales/presentation/bloc/report_event.dart';
import 'package:awee/screens/sales/presentation/bloc/report_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReportBloc()..add(FetchReportData()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Reports')),
        body: BlocBuilder<ReportBloc, ReportState>(
          builder: (context, state) {
            if (state is ReportLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ReportLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ReportBloc>().add(FetchReportData());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _buildSummaryCard(
                              'Total Sales',
                              "\$${state.totalSales.toStringAsFixed(2)}",
                            ),
                            const SizedBox(width: 10),
                            _buildSummaryCard(
                              'Total Orders',
                              state.totalOrders.toString(),
                            ),
                            const SizedBox(width: 10),
                            _buildSummaryCard(
                              'Customers',
                              state.totalCustomers.toString(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Sales Trend',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 250,
                          child: _buildSalesLineChart(state.salesEntries),
                        ),

                        const SizedBox(height: 30),
                        const Text(
                          'Order Status Breakdown',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 200,
                          child: _buildOrderStatusPieChart(
                            state.orderStatusSummary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (state is ReportError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(title, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSalesLineChart(List<SalesEntry> salesEntries) {
    if (salesEntries.isEmpty) {
      return const Center(child: Text('No sales data.'));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            spots:
                salesEntries
                    .map(
                      (e) => FlSpot(
                        salesEntries.indexOf(e).toDouble(),
                        e.totalSales,
                      ),
                    )
                    .toList(),
            barWidth: 4,
            color: Colors.blue,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}

Widget _buildOrderStatusPieChart(OrderStatusSummary summary) {
  return PieChart(
    PieChartData(
      sections: [
        PieChartSectionData(
          value: summary.pending.toDouble(),
          title: 'Pending',
          color: Colors.orange,
          radius: 50,
          titleStyle: const TextStyle(fontSize: 14, color: Colors.white),
        ),
        PieChartSectionData(
          value: summary.accepted.toDouble(),
          title: 'Accepted',
          color: Colors.blue,
          radius: 50,
          titleStyle: const TextStyle(fontSize: 14, color: Colors.white),
        ),
        PieChartSectionData(
          value: summary.delivered.toDouble(),
          title: 'Delivered',
          color: Colors.green,
          radius: 50,
          titleStyle: const TextStyle(fontSize: 14, color: Colors.white),
        ),
      ],
    ),
  );
}
