// import 'package:awee/screens/comingson/comingSon.dart';
// import 'package:awee/screens/products/prodect_screen.dart';
// import 'package:awee/screens/profile/profilr.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class DashboardScreens extends StatefulWidget {
//   const DashboardScreens({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashbordScreenState();
// }

// class _DashbordScreenState extends State<DashboardScreen> {
//   String name = '';
//   String email = '';
//   String role = '';

//   @override
//   void initState() {
//     super.initState();
//     loadUserInfo();
//   }

//   void loadUserInfo() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       name = prefs.getString('name') ?? 'User';
//       email = prefs.getString('email') ?? '';
//       role = prefs.getString('role') ?? '';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           keyboardDismissBehavior:
//               ScrollViewKeyboardDismissBehavior.onDrag, // Correct usage

//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 40),

//               profile(name, email),

//               const SizedBox(height: 20),

//               GridView.count(
//                 crossAxisCount: 2, // 2 columns
//                 crossAxisSpacing: 20,
//                 mainAxisSpacing: 20,
//                 shrinkWrap:
//                     true, // Important to make it work inside SingleChildScrollView
//                 physics:
//                     NeverScrollableScrollPhysics(), // Prevent inner scrolling
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ProductScreen(),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       height: 100,
//                       decoration: BoxDecoration(
//                         color: Colors.blue,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           'Products',
//                           style: TextStyle(color: Colors.white, fontSize: 20),
//                         ),
//                       ),
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //     builder: (context) => const ProductScreen(),
//                       //   ),
//                       // );
//                     ),
//                   ),

//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ComingSoonScreen(),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       height: 100,
//                       decoration: BoxDecoration(
//                         color: Colors.blue,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           'Orders',
//                           style: TextStyle(color: Colors.white, fontSize: 20),
//                         ),
//                       ),
//                     ),
//                   ),

//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ComingSoonScreen(),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       height: 100,
//                       decoration: BoxDecoration(
//                         color: Colors.blue,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           'Sales',
//                           style: TextStyle(color: Colors.white, fontSize: 20),
//                         ),
//                       ),
//                     ),
//                   ),

//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ComingSoonScreen(),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       height: 100,
//                       decoration: BoxDecoration(
//                         color: Colors.blue,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           'Customers',
//                           style: TextStyle(color: Colors.white, fontSize: 20),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




// // RefreshIndicator(
// //         onRefresh: () async {
// //           context.read<DashboardBloc>().add(FetchDashboard());
// //         },
// //         child: BlocBuilder<DashboardBloc, DashboardState>(
// //           builder: (context, state) {
// //             if (state is DashboardLoading) {
// //               return const Center(child: CircularProgressIndicator());
// //             } else if (state is DashboardLoaded) {
// //               return ListView(
// //                 padding: const EdgeInsets.all(16.0),
// //                 children: [
// //                   buildCard('📦 Total Products', state.dashboard.totalProducts.toString()),
// //                   const SizedBox(height: 16),
// //                   buildCard('📈 Total Stock', state.dashboard.totalStock.toString()),
// //                   const SizedBox(height: 16),
// //                   buildCard('💵 Total Value', "\$${state.dashboard.totalValue.toStringAsFixed(2)}"),
// //                   const SizedBox(height: 32),
// //                   const Text('Visual Chart:', style: TextStyle(fontSize: 18)),
// //                   const SizedBox(height: 200, child: DashboardBarChart()),
// //                 ],
// //               );
// //             } else if (state is DashboardError) {
// //               return Center(child: Text('Error: ${state.message}'));
// //             }
// //             return const SizedBox();
// //           },
// //         ),
// //       ),
// //     );
// //   }

// //   Widget buildCard(String title, String value) {
// //     return Card(
// //       elevation: 4,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       child: ListTile(
// //         title: Text(title),
// //         trailing: Text(
// //           value,
// //           style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class DashboardBarChart extends StatelessWidget {
// //   const DashboardBarChart({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return BarChart(
// //       BarChartData(
// //         alignment: BarChartAlignment.spaceAround,
// //         maxY: 200,
// //         barTouchData: BarTouchData(enabled: false),
// //         titlesData: FlTitlesData(show: true),
// //         borderData: FlBorderData(show: false),
// //         barGroups: [
// //           BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 150, width: 20)]),
// //           BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 80, width: 20)]),
// //           BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 120, width: 20)]),
// //         ],
// //       ),
// //     );
// //   }
// // }