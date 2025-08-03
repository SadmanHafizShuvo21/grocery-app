import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../orders/order_confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isPlacingOrder = false;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user?.address != null) {
      _addressController.text = authProvider.user!.address!;
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isPlacingOrder = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);

      final order = await orderProvider.placeOrder(
        user: authProvider.user!,
        items: cartProvider.cartItems,
        deliveryAddress: _addressController.text.trim(),
        notes: _notesController.text.trim().isNotEmpty 
            ? _notesController.text.trim() 
            : null,
      );

      if (order != null) {
        // Clear cart after successful order
        await cartProvider.clearCart();

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => OrderConfirmationScreen(order: order),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(orderProvider.error ?? 'Failed to place order'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to place order. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPlacingOrder = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Summary',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...cartProvider.cartItems.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.image,
                                    color: Colors.grey[400],
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.product.name,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${item.quantity} x \$${item.product.discountedPrice.toStringAsFixed(2)}',
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '\$${item.totalPrice.toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green[700],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Subtotal',
                              style: GoogleFonts.poppins(color: Colors.grey[600]),
                            ),
                            Text(
                              '\$${cartProvider.subtotal.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delivery Fee',
                              style: GoogleFonts.poppins(color: Colors.grey[600]),
                            ),
                            Text(
                              cartProvider.deliveryFee == 0
                                  ? 'FREE'
                                  : '\$${cartProvider.deliveryFee.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: cartProvider.deliveryFee == 0
                                    ? Colors.green[700]
                                    : Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tax',
                              style: GoogleFonts.poppins(color: Colors.grey[600]),
                            ),
                            Text(
                              '\$${cartProvider.tax.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${cartProvider.total.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Delivery Information
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Information',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Delivery Address
                        TextFormField(
                          controller: _addressController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Delivery Address *',
                            hintText: 'Enter your full delivery address',
                            prefixIcon: const Icon(Icons.location_on_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your delivery address';
                            }
                            if (value.trim().length < 10) {
                              return 'Please enter a complete address';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Delivery Notes
                        TextFormField(
                          controller: _notesController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            labelText: 'Delivery Notes (Optional)',
                            hintText: 'Special instructions for delivery',
                            prefixIcon: const Icon(Icons.note_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Estimated Delivery Time
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                color: Colors.green[700],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Estimated delivery: 1-2 business days',
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          );
        },
      ),

      // Place Order Button
      bottomSheet: Container(
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
          child: ElevatedButton(
            onPressed: _isPlacingOrder ? null : _placeOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isPlacingOrder
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Placing Order...',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : Consumer<CartProvider>(
                    builder: (context, cartProvider, child) {
                      return Text(
                        'Place Order - \$${cartProvider.total.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}