import 'package:awee/screens/dashbord/domain/_dashboard_entity.dart';

import '../data/dashboard_repository.dart';

class DashboardUseCase {
  final DashboardRepository repository;

  DashboardUseCase(this.repository);

  Future<DashboardEntity> fetchSummary() {
    return repository.fetchDashboardSummary();
  }
}
