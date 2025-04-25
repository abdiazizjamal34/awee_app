import 'package:awee/screens/dashbord/data/dashboard_repository.dart';
import 'package:awee/screens/dashbord/domain/dashboard_useCase.dart';
import 'package:awee/screens/dashbord/presentation/bloc/dashboard_bloc.dart';
import 'package:awee/screens/dashbord/presentation/bloc/dashboard_event.dart';
import 'package:awee/screens/dashbord/presentation/bloc/dhashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreens extends StatelessWidget {
  const DashboardScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              DashboardBloc(DashboardUseCase(DashboardRepository()))
                ..add(FetchDashboard()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Dashboard')),
        body: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DashboardLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    buildCard(
                      '📦 Total Products',
                      state.dashboard.totalProducts.toString(),
                    ),
                    const SizedBox(height: 16),
                    buildCard(
                      '📈 Total Stock',
                      state.dashboard.totalStock.toString(),
                    ),
                    const SizedBox(height: 16),
                    buildCard(
                      '💵 Total Value',
                      "\$${state.dashboard.totalValue.toStringAsFixed(2)}",
                    ),
                  ],
                ),
              );
            } else if (state is DashboardError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget buildCard(String title, String value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
