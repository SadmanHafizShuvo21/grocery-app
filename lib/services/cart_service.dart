import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartService {
  static const String _cartKey = 'cart_items';
  final Uuid _uuid = const Uuid();
  
  List<CartItem> _cartItems = [];
  
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  
  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  
  double get subtotal => _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  
  double get deliveryFee => subtotal > 50 ? 0.0 : 5.99;
  
  double get tax => subtotal * 0.08; // 8% tax
  
  double get total => subtotal + deliveryFee + tax;

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString(_cartKey);
    
    if (cartJson != null) {
      try {
        final List<dynamic> cartList = jsonDecode(cartJson);
        _cartItems = cartList.map((item) => CartItem.fromJson(item)).toList();
      } catch (e) {
        _cartItems = [];
      }
    }
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = jsonEncode(_cartItems.map((item) => item.toJson()).toList());
    await prefs.setString(_cartKey, cartJson);
  }

  Future<void> addToCart(Product product, {int quantity = 1}) async {
    final existingItemIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex >= 0) {
      // Update existing item
      final existingItem = _cartItems[existingItemIndex];
      final newQuantity = existingItem.quantity + quantity;
      
      _cartItems[existingItemIndex] = existingItem.copyWith(
        quantity: newQuantity,
      );
    } else {
      // Add new item
      final cartItem = CartItem(
        id: _uuid.v4(),
        product: product,
        quantity: quantity,
        addedAt: DateTime.now(),
      );
      
      _cartItems.add(cartItem);
    }

    await _saveCart();
  }

  Future<void> removeFromCart(String cartItemId) async {
    _cartItems.removeWhere((item) => item.id == cartItemId);
    await _saveCart();
  }

  Future<void> updateQuantity(String cartItemId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(cartItemId);
      return;
    }

    final itemIndex = _cartItems.indexWhere((item) => item.id == cartItemId);
    
    if (itemIndex >= 0) {
      _cartItems[itemIndex] = _cartItems[itemIndex].copyWith(
        quantity: quantity,
      );
      await _saveCart();
    }
  }

  Future<void> clearCart() async {
    _cartItems.clear();
    await _saveCart();
  }

  bool isProductInCart(String productId) {
    return _cartItems.any((item) => item.product.id == productId);
  }

  int getProductQuantity(String productId) {
    try {
      final item = _cartItems.firstWhere((item) => item.product.id == productId);
      return item.quantity;
    } catch (e) {
      return 0;
    }
  }

  CartItem? getCartItem(String productId) {
    try {
      return _cartItems.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }
}