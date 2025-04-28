import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

// Fetch Orders event already exists
class FetchOrders extends OrderEvent {
  final String? status;
  const FetchOrders({this.status});

  @override
  List<Object?> get props => [status];
}

// ✅ New CreateOrder event
class CreateOrder extends OrderEvent {
  final Map<String, dynamic> orderData;

  const CreateOrder(this.orderData);

  @override
  List<Object?> get props => [orderData];
}

// Update Status
class UpdateOrderStatus extends OrderEvent {
  final String orderId;
  final String status;

  const UpdateOrderStatus(this.orderId, this.status);

  @override
  List<Object?> get props => [orderId, status];
}
