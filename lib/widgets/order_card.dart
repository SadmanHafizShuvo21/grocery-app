import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback? onTap;

  const OrderCard({
    super.key,
    required this.order,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.receipt_outlined,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Order #${order.id.substring(0, 8).toUpperCase()}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getStatusColor(order.status).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    order.statusDisplayName,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(order.status),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Order Date and Items Count
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 6),
                Text(
                  _formatDate(order.orderDate),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 16,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 6),
                Text(
                  '${order.items.length} items',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Order Items Preview
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: order.items.take(3).length,
                      itemBuilder: (context, index) {
                        final item = order.items[index];
                        return Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              // Product Image Placeholder
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.image,
                                  size: 16,
                                  color: Colors.grey[400],
                                ),
                              ),
                              
                              // Quantity Badge
                              if (item.quantity > 1)
                                Positioned(
                                  top: -2,
                                  right: -2,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.green[700],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: Text(
                                      '${item.quantity}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                if (order.items.length > 3)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '+${order.items.length - 3}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Total Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '\$${order.total.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),

                // Action Buttons
                Row(
                  children: [
                    if (order.canBeCancelled)
                      OutlinedButton(
                        onPressed: () {
                          _showCancelDialog(context, order);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: BorderSide(color: Colors.red[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    
                    if (order.canBeCancelled) const SizedBox(width: 8),
                    
                    ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      child: Text(
                        'View Details',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cancel Order',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to cancel this order?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              // Handle order cancellation
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order cancelled successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.purple;
      case OrderStatus.shipped:
        return Colors.indigo;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}