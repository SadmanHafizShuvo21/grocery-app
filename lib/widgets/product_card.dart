import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  color: Colors.grey[100],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      // Placeholder for image
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.image,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                      ),
                      
                      // Discount Badge
                      if (product.hasDiscount)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '-${product.discount!.toInt()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      
                      // Stock Status
                      if (!product.inStock)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'OUT OF STOCK',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Product Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      product.name,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Rating and Reviews
                    if (product.rating > 0)
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.amber[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${product.rating}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${product.reviewCount})',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    
                    const Spacer(),
                    
                    // Price and Add to Cart
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.hasDiscount)
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            Text(
                              '\$${product.discountedPrice.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                        
                        // Add to Cart Button
                        Consumer<CartProvider>(
                          builder: (context, cartProvider, child) {
                            final isInCart = cartProvider.isProductInCart(product.id);
                            final quantity = cartProvider.getProductQuantity(product.id);
                            
                            if (isInCart) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.green[300]!),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        final cartItem = cartProvider.getCartItem(product.id);
                                        if (cartItem != null) {
                                          await cartProvider.updateQuantity(
                                            cartItem.id,
                                            quantity - 1,
                                          );
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        child: Icon(
                                          Icons.remove,
                                          size: 16,
                                          color: Colors.green[700],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 6,
                                      ),
                                      child: Text(
                                        quantity.toString(),
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green[700],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        await cartProvider.addToCart(product);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        child: Icon(
                                          Icons.add,
                                          size: 16,
                                          color: Colors.green[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            
                            return InkWell(
                              onTap: product.inStock
                                  ? () async {
                                      await cartProvider.addToCart(product);
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('${product.name} added to cart'),
                                            duration: const Duration(seconds: 2),
                                            backgroundColor: Colors.green[700],
                                          ),
                                        );
                                      }
                                    }
                                  : null,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: product.inStock 
                                      ? Colors.green[700] 
                                      : Colors.grey[400],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.add_shopping_cart,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}