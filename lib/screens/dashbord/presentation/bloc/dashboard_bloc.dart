import 'package:awee/screens/dashbord/domain/dashboard_useCase.dart';
import 'package:awee/screens/dashbord/presentation/bloc/dashboard_event.dart';
import 'package:awee/screens/dashbord/presentation/bloc/dhashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardUseCase useCase;

  DashboardBloc(this.useCase) : super(DashboardInitial()) {
    on<FetchDashboard>((event, emit) async {
      emit(DashboardLoading());
      try {
        final dashboard = await useCase.fetchSummary();
        emit(DashboardLoaded(dashboard));
      } catch (e) {
        emit(DashboardError(e.toString()));
      }
    });
  }
}
