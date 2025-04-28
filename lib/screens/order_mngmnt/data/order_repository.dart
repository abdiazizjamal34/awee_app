import 'dart:convert';
import 'package:awee/constants/api.dart';
import 'package:awee/screens/order_mngmnt/model/order.dart';
import 'package:http/http.dart' as http;

class OrderRepository {
  Future<List<Order>> fetchOrders({String? status}) async {
    String url = '$baseUrl/orders';
    if (status != null && status != 'All') {
      url += '?status=$status';
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  // ✅ New Create Order function
  Future<void> createOrder(Map<String, dynamic> orderData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(orderData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create order');
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/orders/status/$orderId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"status": status}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update order');
    }
  }
}
