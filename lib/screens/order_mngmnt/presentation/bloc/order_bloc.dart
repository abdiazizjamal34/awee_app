import 'package:awee/screens/order_mngmnt/data/order_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository repository;

  OrderBloc(this.repository) : super(OrderInitial()) {
    on<FetchOrders>(_onFetchOrders);
    on<CreateOrder>(_onCreateOrder); // ✅ New
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
  }

  Future<void> _onFetchOrders(
    FetchOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final orders = await repository.fetchOrders(status: event.status);
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
  // feach on products

  // ✅ New Create Order Handler
  Future<void> _onCreateOrder(
    CreateOrder event,
    Emitter<OrderState> emit,
  ) async {
    try {
      await repository.createOrder(event.orderData);
      add(FetchOrders()); // ✅ Refresh orders after creation
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatus event,
    Emitter<OrderState> emit,
  ) async {
    try {
      await repository.updateOrderStatus(event.orderId, event.status);
      add(FetchOrders());
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
