import 'dart:convert';
import 'package:awee/constants/api.dart' show baseUrl;
import 'package:awee/screens/order_mngmnt/model/order.dart';
import 'package:http/http.dart' as http;

class CustomerRepository {
  Future<List<Customer>> fetchCustomers() async {
    final response = await http.get(Uri.parse('$baseUrl/customers'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Customer.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load customers');
    }
  }
}
