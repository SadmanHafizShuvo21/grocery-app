import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/order.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final Order order;

  const OrderConfirmationScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Success Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 60,
                  color: Colors.green[700],
                ),
              ),

              const SizedBox(height: 24),

              // Success Message
              Text(
                'Order Placed Successfully!',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              Text(
                'Thank you for your order. We\'ll send you a confirmation email shortly.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Order Details Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
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
                    Text(
                      'Order Details',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Order ID
                    _DetailRow(
                      label: 'Order ID',
                      value: order.id.substring(0, 8).toUpperCase(),
                      icon: Icons.receipt_outlined,
                    ),

                    const SizedBox(height: 12),

                    // Tracking Number
                    if (order.trackingNumber != null)
                      _DetailRow(
                        label: 'Tracking Number',
                        value: order.trackingNumber!,
                        icon: Icons.local_shipping_outlined,
                      ),

                    if (order.trackingNumber != null) const SizedBox(height: 12),

                    // Order Date
                    _DetailRow(
                      label: 'Order Date',
                      value: _formatDate(order.orderDate),
                      icon: Icons.calendar_today_outlined,
                    ),

                    const SizedBox(height: 12),

                    // Estimated Delivery
                    if (order.estimatedDelivery != null)
                      _DetailRow(
                        label: 'Estimated Delivery',
                        value: _formatDate(order.estimatedDelivery!),
                        icon: Icons.schedule_outlined,
                      ),

                    if (order.estimatedDelivery != null) const SizedBox(height: 12),

                    // Status
                    _DetailRow(
                      label: 'Status',
                      value: order.statusDisplayName,
                      icon: Icons.info_outline,
                      valueColor: _getStatusColor(order.status),
                    ),

                    const SizedBox(height: 12),

                    // Total Amount
                    _DetailRow(
                      label: 'Total Amount',
                      value: '\$${order.total.toStringAsFixed(2)}',
                      icon: Icons.attach_money,
                      valueColor: Colors.green[700],
                      isHighlighted: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Delivery Address Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
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
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.green[700],
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Delivery Address',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      order.deliveryAddress,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Action Buttons
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/orders',
                        (route) => false,
                      );
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
                      'Track Your Order',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home',
                        (route) => false,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green[700],
                      side: BorderSide(color: Colors.green[700]!),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Continue Shopping',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Order Items Summary
              Text(
                '${order.items.length} items in this order',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
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
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;
  final bool isHighlighted;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: isHighlighted ? const EdgeInsets.all(12) : null,
      decoration: isHighlighted
          ? BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[200]!),
            )
          : null,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}