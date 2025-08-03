import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/cart_item_card.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false).loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Shopping Cart',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              if (cartProvider.cartItems.isNotEmpty) {
                return TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          'Clear Cart',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        content: Text(
                          'Are you sure you want to remove all items from your cart?',
                          style: GoogleFonts.poppins(),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await cartProvider.clearCart();
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    'Clear',
                    style: GoogleFonts.poppins(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cartProvider.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Your cart is empty',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Add some products to get started',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Start Shopping',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Cart Items
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartProvider.cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartProvider.cartItems[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CartItemCard(
                        cartItem: cartItem,
                        onUpdateQuantity: (newQuantity) async {
                          await cartProvider.updateQuantity(
                            cartItem.id,
                            newQuantity,
                          );
                        },
                        onRemove: () async {
                          await cartProvider.removeFromCart(cartItem.id);
                        },
                      ),
                    );
                  },
                ),
              ),

              // Cart Summary
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Order Summary
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            '\$${cartProvider.subtotal.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delivery Fee',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            cartProvider.deliveryFee == 0
                                ? 'FREE'
                                : '\$${cartProvider.deliveryFee.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: cartProvider.deliveryFee == 0
                                  ? Colors.green[700]
                                  : Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tax',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            '\$${cartProvider.tax.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      
                      const Divider(height: 24),
                      
                      // Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            '\$${cartProvider.total.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                      
                      if (cartProvider.subtotal < 50 && cartProvider.deliveryFee > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green[200]!),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.local_shipping,
                                  color: Colors.green[700],
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Add \$${(50 - cartProvider.subtotal).toStringAsFixed(2)} more for FREE delivery!',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      
                      const SizedBox(height: 20),
                      
                      // Checkout Button
                      ElevatedButton(
                        onPressed: () {
                          final authProvider = Provider.of<AuthProvider>(context, listen: false);
                          if (authProvider.isAuthenticated) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CheckoutScreen(),
                              ),
                            );
                          } else {
                            Navigator.of(context).pushNamed('/login');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.shopping_bag),
                            const SizedBox(width: 8),
                            Text(
                              'Proceed to Checkout',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}