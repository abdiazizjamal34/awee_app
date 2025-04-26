class Order {
  final String id;
  final Customer customer;
  final List<OrderItem> products;
  final double totalAmount;
  final String status;
  final DateTime orderDate;

  Order({
    required this.id,
    required this.customer,
    required this.products,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      customer: Customer.fromJson(json['customerId']),
      products:
          (json['products'] as List)
              .map((item) => OrderItem.fromJson(item))
              .toList(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? 'Pending',
      orderDate: DateTime.parse(json['orderDate']),
    );
  }
}

class Customer {
  final String id;
  final String name;

  Customer({required this.id, required this.name});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(id: json['_id'], name: json['name'] ?? 'Unknown');
  }
}

class OrderItem {
  final String id;
  final String name;
  final double price;
  final int quantity;

  OrderItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['productId']['_id'],
      name: json['productId']['name'] ?? 'Unknown',
      price: (json['productId']['price'] ?? 0).toDouble(),
      quantity: json['quantity'],
    );
  }
}
