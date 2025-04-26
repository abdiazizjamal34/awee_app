import 'package:awee/order_mngmnt/data/order_repository.dart';
import 'package:awee/order_mngmnt/presentation/bloc/order_bloc.dart';
import 'package:awee/order_mngmnt/presentation/bloc/order_event.dart';
import 'package:awee/order_mngmnt/presentation/order_screen.dart';
import 'package:awee/screens/dashbord/data/dashboard_repository.dart';
import 'package:awee/screens/dashbord/domain/dashboard_useCase.dart';
import 'package:awee/screens/dashbord/presentation/bloc/dashboard_bloc.dart';
import 'package:awee/screens/dashbord/presentation/bloc/dashboard_event.dart';
import 'package:awee/screens/dashbord/presentation/bloc/dhashboard_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:awee/screens/products/prodect_screen.dart';
import 'package:awee/screens/comingson/comingSon.dart';
import 'package:awee/screens/profile/profilr.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String name = '';
  String email = '';
  String role = '';

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  void loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? 'User';
      email = prefs.getString('email') ?? '';
      role = prefs.getString('role') ?? '';
    });
  }

  // void _fetchDashboard() {
  //   context.read<DashboardBloc>().add(FetchDashboard());
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              DashboardBloc(DashboardUseCase(DashboardRepository()))
                ..add(FetchDashboard()),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              profile(name, email),

              const SizedBox(height: 20),

              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  buildGridItem(
                    title: "Products",
                    image: 'assets/products.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductScreen(),
                        ),
                      );
                    },
                  ),
                  buildGridItem(
                    title: "Orders",
                    image: 'assets/orders.png',
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder:
                      //         (context) => BlocProvider.value(
                      //           value: BlocProvider.of<OrderBloc>(context),
                      //           child: const OrderListScreen(),
                      //         ),
                      //   ),
                      // );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => BlocProvider(
                                create:
                                    (_) =>
                                        OrderBloc(OrderRepository())
                                          ..add(FetchOrders()),
                                child: const OrderListScreen(),
                              ),
                        ),
                      );
                    },
                  ),
                  buildGridItem(
                    title: "Sales",
                    image: 'assets/sales.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ComingSoonScreen(),
                        ),
                      );
                    },
                  ),
                  buildGridItem(
                    title: "Customers",
                    image: 'assets/customers.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ComingSoonScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),

                      // profile(name, email),
                      const SizedBox(height: 20),

                      // GridView.count(
                      //   crossAxisCount: 2,
                      //   crossAxisSpacing: 20,
                      //   mainAxisSpacing: 20,
                      //   shrinkWrap: true,
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   children: [
                      //     buildGridItem(
                      //       title: "Products",
                      //       onTap: () {
                      //         Navigator.push(
                      //           context,

                      //           MaterialPageRoute(
                      //             builder: (context) => const ProductScreen(),
                      //           ),
                      //         );
                      //       },
                      //     ),

                      //     buildGridItem(
                      //       title: "Orders",
                      //       onTap: () {
                      //         Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder:
                      //                 (context) => const ComingSoonScreen(),
                      //           ),
                      //         );
                      //       },
                      //     ),
                      //     buildGridItem(
                      //       title: "Sales",
                      //       onTap: () {
                      //         Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder:
                      //                 (context) => const ComingSoonScreen(),
                      //           ),
                      //         );
                      //       },
                      //     ),
                      //     buildGridItem(
                      //       title: "Customers",
                      //       onTap: () {
                      //         Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder:
                      //                 (context) => const ComingSoonScreen(),
                      //           ),
                      //         );
                      //       },
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 40),

                      BlocBuilder<DashboardBloc, DashboardState>(
                        builder: (context, state) {
                          if (state is DashboardLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is DashboardLoaded) {
                            /// refersh to the data from the API
                            return RefreshIndicator(
                              onRefresh: () async {
                                context.read<DashboardBloc>().add(
                                  FetchDashboard(),
                                );
                              },
                              child: Column(
                                children: [
                                  buildSummaryCard(
                                    '📦 Total Products',
                                    state.dashboard.totalProducts.toString(),
                                  ),
                                  const SizedBox(height: 16),
                                  buildSummaryCard(
                                    '📈 Total Stock',
                                    state.dashboard.totalStock.toString(),
                                  ),
                                  const SizedBox(height: 16),
                                  buildSummaryCard(
                                    '💵 Total Value',
                                    "\$${state.dashboard.totalValue.toStringAsFixed(2)}",
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Visual Chart:',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 200,
                                    child: DashboardBarChart(),
                                  ),
                                ],
                              ),
                            );
                          } else if (state is DashboardLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is DashboardError) {
                            return Center(
                              child: Text('Error: ${state.message}'),
                            );
                          }
                          return const SizedBox();
                        },
                      ),

                      const SizedBox(height: 30),

                      // GridView.count(
                      //   crossAxisCount: 2,
                      //   crossAxisSpacing: 20,
                      //   mainAxisSpacing: 20,
                      //   shrinkWrap: true,
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   children: [
                      //     buildGridItem(
                      //       title: "Products",
                      //       onTap: () {
                      //         Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) => const ProductScreen(),
                      //           ),
                      //         );
                      //       },
                      //     ),
                      //     buildGridItem(
                      //       title: "Orders",
                      //       onTap: () {
                      //         Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) => const ComingSoonScreen(),
                      //           ),
                      //         );
                      //       },
                      //     ),
                      //     buildGridItem(
                      //       title: "Sales",
                      //       onTap: () {
                      //         Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) => const ComingSoonScreen(),
                      //           ),
                      //         );
                      //       },
                      //     ),
                      //     buildGridItem(
                      //       title: "Customers",
                      //       onTap: () {
                      //         Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) => const ComingSoonScreen(),
                      //           ),
                      //         );
                      //       },
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSummaryCard(String title, String value) {
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

  Widget buildGridItem({
    required String title,
    required VoidCallback onTap,
    required String image,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 2,
        width: 2,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
          color: const Color.fromARGB(255, 24, 40, 65),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.justify,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

// class DashboardBarChart extends StatelessWidget {
//   const DashboardBarChart({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BarChart(
//       BarChartData(
//         alignment: BarChartAlignment.spaceAround,
//         maxY: 200,
//         barTouchData: BarTouchData(enabled: false),
//         titlesData: FlTitlesData(show: true),
//         borderData: FlBorderData(show: false),
//         barGroups: [
//           BarChartGroupData(
//             x: 0,
//             barRods: [BarChartRodData(toY: 150, width: 20)],
//           ),
//           BarChartGroupData(
//             x: 1,
//             barRods: [BarChartRodData(toY: 80, width: 20)],
//           ),
//           BarChartGroupData(
//             x: 2,
//             barRods: [BarChartRodData(toY: 120, width: 20)],
//           ),
//         ],
//       ),
//     );
//   }
// }

class DashboardBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [BarChartRodData(toY: 10, color: Colors.blue)],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [BarChartRodData(toY: 15, color: Colors.green)],
          ),
        ],
        titlesData: FlTitlesData(show: true),
      ),
    );
  }
}
