import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchOrders extends OrderEvent {
  final String? status; // ✅ Make it optional

  FetchOrders({this.status});

  @override
  List<Object> get props => [status ?? ''];
}

class CreateOrder extends OrderEvent {
  final Map<String, dynamic> orderData;

  CreateOrder(this.orderData);
}

class UpdateOrderStatus extends OrderEvent {
  final String orderId;
  final String status;

  UpdateOrderStatus(this.orderId, this.status);
}
