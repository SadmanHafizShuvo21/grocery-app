import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.grey[100],
                child: Stack(
                  children: [
                    // Product Image Placeholder
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.image,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                    ),
                    
                    // Discount Badge
                    if (product.hasDiscount)
                      Positioned(
                        top: 60,
                        left: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '-${product.discount!.toInt()}% OFF',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name and Category
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.category,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Stock Status
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: product.inStock ? Colors.green[50] : Colors.red[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: product.inStock ? Colors.green[300]! : Colors.red[300]!,
                          ),
                        ),
                        child: Text(
                          product.inStock ? 'In Stock' : 'Out of Stock',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: product.inStock ? Colors.green[700] : Colors.red[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),

                  // Rating and Reviews
                  if (product.rating > 0)
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < product.rating.floor()
                                  ? Icons.star
                                  : index < product.rating
                                      ? Icons.star_half
                                      : Icons.star_border,
                              color: Colors.amber[600],
                              size: 20,
                            );
                          }),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${product.rating}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${product.reviewCount} reviews)',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 20),

                  // Price
                  Row(
                    children: [
                      if (product.hasDiscount)
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.grey[500],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      if (product.hasDiscount) const SizedBox(width: 8),
                      Text(
                        '\$${product.discountedPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'per ${product.unit}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'Description',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tags
                  if (product.tags.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tags',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: product.tags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Text(
                                tag,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Add to Cart Section
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
          child: Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              final isInCart = cartProvider.isProductInCart(product.id);
              final quantity = cartProvider.getProductQuantity(product.id);

              if (isInCart) {
                return Row(
                  children: [
                    // Quantity Controls
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green[300]!),
                        borderRadius: BorderRadius.circular(12),
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
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                Icons.remove,
                                color: Colors.green[700],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Text(
                              quantity.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 18,
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
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                Icons.add,
                                color: Colors.green[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Total Price and View Cart Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/cart');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'View Cart (\$${(product.discountedPrice * quantity).toStringAsFixed(2)})',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return ElevatedButton(
                onPressed: product.inStock
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: product.inStock ? Colors.green[700] : Colors.grey[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_shopping_cart),
                    const SizedBox(width: 8),
                    Text(
                      product.inStock 
                          ? 'Add to Cart - \$${product.discountedPrice.toStringAsFixed(2)}'
                          : 'Out of Stock',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}