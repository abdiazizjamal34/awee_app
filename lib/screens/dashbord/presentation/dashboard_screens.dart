import 'package:awee/screens/order_mngmnt/data/order_repository.dart';
import 'package:awee/screens/order_mngmnt/presentation/bloc/order_bloc.dart';
import 'package:awee/screens/order_mngmnt/presentation/bloc/order_event.dart';
import 'package:awee/screens/order_mngmnt/presentation/order_screen.dart';
import 'package:awee/screens/dashbord/data/dashboard_repository.dart';
import 'package:awee/screens/dashbord/domain/dashboard_useCase.dart';
import 'package:awee/screens/dashbord/presentation/bloc/dashboard_bloc.dart';
import 'package:awee/screens/dashbord/presentation/bloc/dashboard_event.dart';
import 'package:awee/screens/dashbord/presentation/bloc/dhashboard_state.dart';
import 'package:awee/screens/sales/presentation/report_screen.dart';
import 'package:awee/them/them.dart';
import 'package:awee/wideget/screenSlide/screenSlide.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:awee/screens/products/prodect_screen.dart';
import 'package:awee/screens/comingson/comingSon.dart';
import 'package:awee/screens/profile/profilr.dart';
import 'package:shimmer/shimmer.dart';

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
              // SwitchListTile(
              //   value:
              //       Provider.of<ThemeProvider>(context).themeMode ==
              //       ThemeMode.dark,
              //   title: const Text('Dark Mode'),
              //   onChanged: (value) {
              //     Provider.of<ThemeProvider>(
              //       context,
              //       listen: false,
              //     ).toggleTheme(value);
              //   },
              // ),
              Row(
                children: [
                  const Text(
                    'Dashboard',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {
                      // Handle notification action
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      // Handle settings action
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      // Handle logout action
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ComingSoonScreen(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Provider.of<ThemeProvider>(context).themeMode ==
                              ThemeMode.dark
                          ? Icons.dark_mode
                          : Icons.light_mode,
                    ),
                    onPressed: () {
                      final isDark =
                          Provider.of<ThemeProvider>(
                            context,
                            listen: false,
                          ).themeMode ==
                          ThemeMode.dark;
                      Provider.of<ThemeProvider>(
                        context,
                        listen: false,
                      ).toggleTheme(!isDark);
                    },
                    tooltip: 'Toggle Theme',
                  ),
                ],
              ),

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
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const ProductScreen(),
                      //   ),
                      // );
                      Navigator.push(
                        context,
                        slideRoute(const ProductScreen()),
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
                          builder: (context) => const ReportScreen(),
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
                            return Center(child: buildLoadingShimmer());
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
                          } else if (state is DashboardError) {
                            return buildNoData("Failed to load Data.");
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

Widget profile(String name, String email) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: ListTile(
      leading: const Icon(Icons.person),
      title: Text(name),
      subtitle: Text(email),
      trailing: const Icon(Icons.arrow_forward_ios),
    ),
  );
}

Widget buildLoadingShimmer() {
  return ListView.builder(
    itemCount: 5,
    itemBuilder: (_, __) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[800]!,
          highlightColor: Colors.grey[600]!,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    },
  );
}

Widget buildNoData(String message) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.inbox, size: 64, color: Colors.grey),
        const SizedBox(height: 12),
        Text(message, style: const TextStyle(color: Colors.white54)),
      ],
    ),
  );
}
