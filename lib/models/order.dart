import 'package:json_annotation/json_annotation.dart';
import 'cart_item.dart';

part 'order.g.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  shipped,
  delivered,
  cancelled,
}

@JsonSerializable()
class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final OrderStatus status;
  final DateTime orderDate;
  final DateTime? estimatedDelivery;
  final DateTime? actualDelivery;
  final String deliveryAddress;
  final String? trackingNumber;
  final String? notes;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.status,
    required this.orderDate,
    this.estimatedDelivery,
    this.actualDelivery,
    required this.deliveryAddress,
    this.trackingNumber,
    this.notes,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);

  String get statusDisplayName {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get canBeCancelled {
    return status == OrderStatus.pending || status == OrderStatus.confirmed;
  }

  Order copyWith({
    String? id,
    String? userId,
    List<CartItem>? items,
    double? subtotal,
    double? deliveryFee,
    double? tax,
    double? total,
    OrderStatus? status,
    DateTime? orderDate,
    DateTime? estimatedDelivery,
    DateTime? actualDelivery,
    String? deliveryAddress,
    String? trackingNumber,
    String? notes,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      actualDelivery: actualDelivery ?? this.actualDelivery,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      notes: notes ?? this.notes,
    );
  }
}