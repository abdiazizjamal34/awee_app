import 'dart:convert';
import 'package:awee/constants/api.dart';
import 'package:awee/screens/dashbord/domain/_dashboard_entity.dart';
import 'package:http/http.dart' as http;

class DashboardRepository {
  Future<DashboardEntity> fetchDashboardSummary() async {
    final response = await http.get(Uri.parse('$baseUrl/dashboard'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return DashboardEntity(
        totalProducts: data['totalProducts'],
        totalStock: data['totalStock'],
        totalValue: (data['totalValue'] as num).toDouble(),
      );
    } else {
      throw Exception('Failed to load dashboard summary');
    }
  }
}
