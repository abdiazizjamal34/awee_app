import 'package:awee/screens/order_mngmnt/model/order.dart';
import 'package:awee/screens/order_mngmnt/presentation/bloc/order_bloc.dart';
import 'package:awee/screens/order_mngmnt/presentation/bloc/order_event.dart';
import 'package:awee/screens/order_mngmnt/presentation/bloc/order_state.dart';
import 'package:awee/screens/order_mngmnt/presentation/create_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  String selectedStatus = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Order Management')),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => BlocProvider.value(
                        value: context.read<OrderBloc>(),
                        child: CreateOrderScreen(),
                      ),
                ),
              );
            },
            child: const Text('Create Order'),
          ),

          const SizedBox(height: 10),
          _buildFilterButtons(),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                if (state is OrderLoading) {
                  return buildLoadingShimmer();
                } else if (state is OrdersLoaded) {
                  final orders = state.orders;

                  if (orders.isEmpty) {
                    return const Center(child: Text('No Orders Found.'));
                  }

                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        elevation: 4,
                        child: ListTile(
                          title: Text('Customer: ${order.customer.name}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total: \$${order.totalAmount.toStringAsFixed(2)}',
                              ),
                              Text('Status: ${order.status}'),
                              Text(
                                'Ordered on: ${order.orderDate.toLocal().toString().split(' ')[0]}',
                              ),
                              const SizedBox(height: 5),
                              ...order.products
                                  .map(
                                    (p) => Text('- ${p.name} x${p.quantity}'),
                                  )
                                  .toList(),
                            ],
                          ),
                          trailing: _buildActionButtons(context, order),
                        ),
                      );
                    },
                  );
                } else if (state is OrderError) {
                  return buildErrorRetry(() {
                    context.read<OrderBloc>().add(FetchOrders());
                  });
                } else {
                  return buildNoData(" No Data Note loaded");
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _filterButton('All'),
        _filterButton('Pending'),
        _filterButton('Accepted'),
        _filterButton('Delivered'),
      ],
    );
  }

  Widget _filterButton(String status) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedStatus = status;
        });

        if (status == 'All') {
          context.read<OrderBloc>().add(FetchOrders());
        } else {
          context.read<OrderBloc>().add(FetchOrders(status: status));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedStatus == status ? Colors.blue : Colors.grey,
      ),
      child: Text(status),
    );
  }

  Widget _buildActionButtons(BuildContext context, Order order) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (order.status == 'Pending') ...[
          ElevatedButton(
            onPressed: () {
              context.read<OrderBloc>().add(
                UpdateOrderStatus(order.id, 'Accepted'),
              );
            },
            child: const Text('Accept'),
          ),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: () {
              context.read<OrderBloc>().add(
                UpdateOrderStatus(order.id, 'Canceled'),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cancel'),
          ),
        ] else if (order.status == 'Accepted') ...[
          ElevatedButton(
            onPressed: () {
              context.read<OrderBloc>().add(
                UpdateOrderStatus(order.id, 'Delivered'),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Deliver'),
          ),
        ] else if (order.status == 'Delivered') ...[
          const Text('Completed', style: TextStyle(color: Colors.green)),
        ] else if (order.status == 'Canceled') ...[
          const Text('Canceled', style: TextStyle(color: Colors.red)),
        ],
      ],
    );
  }
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

Widget buildErrorRetry(VoidCallback onRetry) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
        const SizedBox(height: 8),
        const Text(
          "Something went wrong",
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text("Retry"),
        ),
      ],
    ),
  );
}
