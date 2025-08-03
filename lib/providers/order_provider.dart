import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../models/user.dart';
import '../services/order_service.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();
  
  List<Order> _orders = [];
  Order? _currentOrder;
  bool _isLoading = false;
  String? _error;

  List<Order> get orders => _orders;
  Order? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadOrders(String userId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _orders = await _orderService.getUserOrders(userId);
      _error = null;
    } catch (e) {
      _error = 'Failed to load orders';
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<Order?> placeOrder({
    required User user,
    required List<CartItem> items,
    required String deliveryAddress,
    String? notes,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final order = await _orderService.placeOrder(
        user: user,
        items: items,
        deliveryAddress: deliveryAddress,
        notes: notes,
      );
      
      _currentOrder = order;
      _orders.insert(0, order);
      _error = null;
      
      _isLoading = false;
      notifyListeners();
      
      return order;
    } catch (e) {
      _error = 'Failed to place order';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<Order?> getOrderById(String orderId) async {
    try {
      final order = await _orderService.getOrderById(orderId);
      if (order != null) {
        _currentOrder = order;
        notifyListeners();
      }
      return order;
    } catch (e) {
      _error = 'Failed to load order details';
      notifyListeners();
      return null;
    }
  }

  Future<void> cancelOrder(String orderId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _orderService.cancelOrder(orderId);
      
      // Update the order in the local list
      final orderIndex = _orders.indexWhere((order) => order.id == orderId);
      if (orderIndex >= 0) {
        _orders[orderIndex] = _orders[orderIndex].copyWith(
          status: OrderStatus.cancelled,
        );
      }
      
      // Update current order if it's the one being cancelled
      if (_currentOrder?.id == orderId) {
        _currentOrder = _currentOrder!.copyWith(status: OrderStatus.cancelled);
      }
      
      _error = null;
    } catch (e) {
      _error = 'Failed to cancel order';
    }

    _isLoading = false;
    notifyListeners();
  }

  List<Order> getOrdersByStatus(String userId, OrderStatus status) {
    return _orders.where((order) => 
      order.userId == userId && order.status == status
    ).toList();
  }

  List<Order> getRecentOrders(String userId, {int limit = 5}) {
    return _orders
        .where((order) => order.userId == userId)
        .take(limit)
        .toList();
  }

  void clearCurrentOrder() {
    _currentOrder = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}