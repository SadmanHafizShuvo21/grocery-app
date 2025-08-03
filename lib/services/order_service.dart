import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../models/user.dart';

class OrderService {
  static const String _ordersKey = 'user_orders';
  final Uuid _uuid = const Uuid();
  
  List<Order> _orders = [];
  
  List<Order> get orders => List.unmodifiable(_orders);

  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = prefs.getString(_ordersKey);
    
    if (ordersJson != null) {
      try {
        final List<dynamic> ordersList = jsonDecode(ordersJson);
        _orders = ordersList.map((order) => Order.fromJson(order)).toList();
        
        // Sort by order date (newest first)
        _orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      } catch (e) {
        _orders = [];
      }
    }
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = jsonEncode(_orders.map((order) => order.toJson()).toList());
    await prefs.setString(_ordersKey, ordersJson);
  }

  Future<Order> placeOrder({
    required User user,
    required List<CartItem> items,
    required String deliveryAddress,
    String? notes,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    final subtotal = items.fold(0.0, (sum, item) => sum + item.totalPrice);
    final deliveryFee = subtotal > 50 ? 0.0 : 5.99;
    final tax = subtotal * 0.08;
    final total = subtotal + deliveryFee + tax;

    final order = Order(
      id: _uuid.v4(),
      userId: user.id,
      items: List.from(items),
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      tax: tax,
      total: total,
      status: OrderStatus.pending,
      orderDate: DateTime.now(),
      estimatedDelivery: DateTime.now().add(const Duration(days: 2)),
      deliveryAddress: deliveryAddress,
      trackingNumber: _generateTrackingNumber(),
      notes: notes,
    );

    _orders.insert(0, order); // Add to beginning of list
    await _saveOrders();

    // Simulate order processing
    _simulateOrderProgress(order.id);

    return order;
  }

  Future<List<Order>> getUserOrders(String userId) async {
    await loadOrders();
    return _orders.where((order) => order.userId == userId).toList();
  }

  Future<Order?> getOrderById(String orderId) async {
    await loadOrders();
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  Future<void> cancelOrder(String orderId) async {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    
    if (orderIndex >= 0) {
      final order = _orders[orderIndex];
      
      if (order.canBeCancelled) {
        _orders[orderIndex] = order.copyWith(status: OrderStatus.cancelled);
        await _saveOrders();
      }
    }
  }

  String _generateTrackingNumber() {
    return 'GR${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
  }

  void _simulateOrderProgress(String orderId) {
    // Simulate order status updates
    Future.delayed(const Duration(minutes: 5), () async {
      await _updateOrderStatus(orderId, OrderStatus.confirmed);
    });

    Future.delayed(const Duration(minutes: 30), () async {
      await _updateOrderStatus(orderId, OrderStatus.preparing);
    });

    Future.delayed(const Duration(hours: 2), () async {
      await _updateOrderStatus(orderId, OrderStatus.shipped);
    });

    Future.delayed(const Duration(days: 1), () async {
      await _updateOrderStatus(orderId, OrderStatus.delivered);
    });
  }

  Future<void> _updateOrderStatus(String orderId, OrderStatus newStatus) async {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    
    if (orderIndex >= 0) {
      final order = _orders[orderIndex];
      DateTime? actualDelivery;
      
      if (newStatus == OrderStatus.delivered) {
        actualDelivery = DateTime.now();
      }
      
      _orders[orderIndex] = order.copyWith(
        status: newStatus,
        actualDelivery: actualDelivery,
      );
      
      await _saveOrders();
    }
  }

  List<Order> getOrdersByStatus(String userId, OrderStatus status) {
    return _orders
        .where((order) => order.userId == userId && order.status == status)
        .toList();
  }

  List<Order> getRecentOrders(String userId, {int limit = 5}) {
    return _orders
        .where((order) => order.userId == userId)
        .take(limit)
        .toList();
  }
}