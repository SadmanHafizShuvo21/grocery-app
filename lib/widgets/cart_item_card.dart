import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cart_item.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  final Function(int) onUpdateQuantity;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.cartItem,
    required this.onUpdateQuantity,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.image,
                          size: 30,
                          color: Colors.grey[400],
                        ),
                      ),
                      if (cartItem.product.hasDiscount)
                        Positioned(
                          top: 4,
                          left: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '-${cartItem.product.discount!.toInt()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartItem.product.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                cartItem.product.category,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Remove Button
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  'Remove Item',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                content: Text(
                                  'Remove ${cartItem.product.name} from your cart?',
                                  style: GoogleFonts.poppins(),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      onRemove();
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Remove'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Price and Quantity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (cartItem.product.hasDiscount)
                              Text(
                                '\$${cartItem.product.price.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            Text(
                              '\$${cartItem.product.discountedPrice.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                            Text(
                              'per ${cartItem.product.unit}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                        
                        // Quantity Controls
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (cartItem.quantity > 1) {
                                    onUpdateQuantity(cartItem.quantity - 1);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.remove,
                                    size: 18,
                                    color: cartItem.quantity > 1 
                                        ? Colors.grey[700] 
                                        : Colors.grey[400],
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Text(
                                  cartItem.quantity.toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  onUpdateQuantity(cartItem.quantity + 1);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.add,
                                    size: 18,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Item Total
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Item Total',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700],
                  ),
                ),
                Text(
                  '\$${cartItem.totalPrice.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}