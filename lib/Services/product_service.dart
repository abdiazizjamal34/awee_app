import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
import 'package:awee/models/product.dart';

class ProductSerice {
  final String baseUrl = 'http://localhost:5000/api/products';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Map<String, dynamic>> addProduct(
    Map<String, dynamic> productData,
  ) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(productData),
    );

    if (response.statusCode == 201) {
      return {'success': true, 'message': 'Product added successfully'};
    } else {
      final error = jsonDecode(response.body);
      return {
        'success': false,
        'message': error['message'] ?? 'Failed to add product',
      };
    }
  }

  Future<Map<String, dynamic>> updateProduct(
    String id,
    Map<String, dynamic> data,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'message': 'Product updated'};
    } else {
      return {'success': false, 'message': 'Update failed'};
    }
  }

  Future<Map<String, dynamic>> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/products/$id'));

    if (response.statusCode == 200) {
      return {'success': true, 'message': 'Product deleted'};
    } else {
      return {'success': false, 'message': 'Delete failed'};
    }
  }
}
