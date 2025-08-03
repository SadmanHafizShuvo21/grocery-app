import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/cart_service.dart';

class CartProvider with ChangeNotifier {
  final CartService _cartService = CartService();
  
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<CartItem> get cartItems => _cartService.cartItems;
  int get itemCount => _cartService.itemCount;
  double get subtotal => _cartService.subtotal;
  double get deliveryFee => _cartService.deliveryFee;
  double get tax => _cartService.tax;
  double get total => _cartService.total;

  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _cartService.loadCart();
      _error = null;
    } catch (e) {
      _error = 'Failed to load cart';
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addToCart(Product product, {int quantity = 1}) async {
    try {
      await _cartService.addToCart(product, quantity: quantity);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add item to cart';
      notifyListeners();
    }
  }

  Future<void> removeFromCart(String cartItemId) async {
    try {
      await _cartService.removeFromCart(cartItemId);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to remove item from cart';
      notifyListeners();
    }
  }

  Future<void> updateQuantity(String cartItemId, int quantity) async {
    try {
      await _cartService.updateQuantity(cartItemId, quantity);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update quantity';
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    try {
      await _cartService.clearCart();
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to clear cart';
      notifyListeners();
    }
  }

  bool isProductInCart(String productId) {
    return _cartService.isProductInCart(productId);
  }

  int getProductQuantity(String productId) {
    return _cartService.getProductQuantity(productId);
  }

  CartItem? getCartItem(String productId) {
    return _cartService.getCartItem(productId);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}