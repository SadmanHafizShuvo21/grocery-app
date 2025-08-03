import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/order.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Status Card
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order #${order.id.substring(0, 8).toUpperCase()}',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _getStatusColor(order.status).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          order.statusDisplayName,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(order.status),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Order Progress
                  _OrderProgress(order: order),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Order Information
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
                    'Order Information',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _InfoRow(
                    label: 'Order Date',
                    value: _formatDate(order.orderDate),
                    icon: Icons.calendar_today_outlined,
                  ),
                  
                  if (order.trackingNumber != null) ...[
                    const SizedBox(height: 12),
                    _InfoRow(
                      label: 'Tracking Number',
                      value: order.trackingNumber!,
                      icon: Icons.local_shipping_outlined,
                    ),
                  ],
                  
                  if (order.estimatedDelivery != null) ...[
                    const SizedBox(height: 12),
                    _InfoRow(
                      label: 'Estimated Delivery',
                      value: _formatDate(order.estimatedDelivery!),
                      icon: Icons.schedule_outlined,
                    ),
                  ],
                  
                  if (order.actualDelivery != null) ...[
                    const SizedBox(height: 12),
                    _InfoRow(
                      label: 'Delivered On',
                      value: _formatDate(order.actualDelivery!),
                      icon: Icons.check_circle_outline,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Order Items
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
                    'Order Items (${order.items.length})',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  ...order.items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.image,
                                color: Colors.grey[400],
                                size: 24,
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item.quantity} x \$${item.product.discountedPrice.toStringAsFixed(2)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '\$${item.totalPrice.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                        if (index < order.items.length - 1) ...[
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                        ],
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Delivery Address
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
                  if (order.notes != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery Notes:',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.notes!,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Order Summary
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
                    'Order Summary',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _SummaryRow(
                    label: 'Subtotal',
                    value: '\$${order.subtotal.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 8),
                  _SummaryRow(
                    label: 'Delivery Fee',
                    value: order.deliveryFee == 0 
                        ? 'FREE' 
                        : '\$${order.deliveryFee.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 8),
                  _SummaryRow(
                    label: 'Tax',
                    value: '\$${order.tax.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
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
                        '\$${order.total.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
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

class _OrderProgress extends StatelessWidget {
  final Order order;

  const _OrderProgress({required this.order});

  @override
  Widget build(BuildContext context) {
    final steps = [
      _ProgressStep(
        title: 'Order Placed',
        subtitle: _formatDateTime(order.orderDate),
        isCompleted: true,
        isCurrent: false,
      ),
      _ProgressStep(
        title: 'Confirmed',
        subtitle: order.status.index >= OrderStatus.confirmed.index ? 'Confirmed' : 'Pending',
        isCompleted: order.status.index >= OrderStatus.confirmed.index,
        isCurrent: order.status == OrderStatus.confirmed,
      ),
      _ProgressStep(
        title: 'Preparing',
        subtitle: order.status.index >= OrderStatus.preparing.index ? 'In Progress' : 'Waiting',
        isCompleted: order.status.index >= OrderStatus.preparing.index,
        isCurrent: order.status == OrderStatus.preparing,
      ),
      _ProgressStep(
        title: 'Shipped',
        subtitle: order.status.index >= OrderStatus.shipped.index ? 'On the way' : 'Waiting',
        isCompleted: order.status.index >= OrderStatus.shipped.index,
        isCurrent: order.status == OrderStatus.shipped,
      ),
      _ProgressStep(
        title: 'Delivered',
        subtitle: order.status == OrderStatus.delivered 
            ? (order.actualDelivery != null ? _formatDateTime(order.actualDelivery!) : 'Delivered')
            : 'Pending',
        isCompleted: order.status == OrderStatus.delivered,
        isCurrent: false,
      ),
    ];

    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        return Column(
          children: [
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: step.isCompleted 
                        ? Colors.green[700] 
                        : step.isCurrent 
                            ? Colors.blue[700] 
                            : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    step.isCompleted 
                        ? Icons.check 
                        : step.isCurrent 
                            ? Icons.radio_button_unchecked 
                            : Icons.radio_button_unchecked,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: step.isCompleted || step.isCurrent 
                              ? Colors.grey[800] 
                              : Colors.grey[500],
                        ),
                      ),
                      Text(
                        step.subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (index < steps.length - 1)
              Container(
                margin: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                child: Container(
                  width: 2,
                  height: 32,
                  color: step.isCompleted ? Colors.green[700] : Colors.grey[300],
                ),
              ),
          ],
        );
      }).toList(),
    );
  }

  String _formatDateTime(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${months[date.month - 1]} ${date.day}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _ProgressStep {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isCurrent;

  _ProgressStep({
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.isCurrent,
  });
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}