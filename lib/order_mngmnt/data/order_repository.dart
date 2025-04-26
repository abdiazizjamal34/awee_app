import 'dart:convert';
import 'package:awee/order_mngmnt/model/order.dart';
import 'package:http/http.dart' as http;

class OrderRepository {
  final String baseUrl = "http://192.168.10.107:5000/api";
  // final String baseUrl = "http://localhost:5000/api";

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

  Future<Order> createOrder(Map<String, dynamic> orderData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(orderData),
    );

    if (response.statusCode == 201) {
      return Order.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create order');
    }
  }

  Future<Order> updateOrderStatus(String orderId, String status) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/orders/status/$orderId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode == 200) {
      return Order.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update order status');
    }
  }
}
