import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/order.dart';
import '../../widgets/order_card.dart';
import 'order_detail_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrders();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    
    if (authProvider.user != null) {
      await orderProvider.loadOrders(authProvider.user!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.green[700],
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Colors.green[700],
          labelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
            Tab(text: 'All'),
          ],
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (orderProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load orders',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadOrders,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              // Active Orders
              _OrdersList(
                orders: orderProvider.orders.where((order) => 
                  order.status != OrderStatus.delivered && 
                  order.status != OrderStatus.cancelled
                ).toList(),
                emptyMessage: 'No active orders',
                emptySubMessage: 'Your active orders will appear here',
              ),
              
              // Completed Orders
              _OrdersList(
                orders: orderProvider.orders.where((order) => 
                  order.status == OrderStatus.delivered
                ).toList(),
                emptyMessage: 'No completed orders',
                emptySubMessage: 'Your completed orders will appear here',
              ),
              
              // All Orders
              _OrdersList(
                orders: orderProvider.orders,
                emptyMessage: 'No orders yet',
                emptySubMessage: 'Start shopping to see your orders here',
                showShoppingButton: true,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OrdersList extends StatelessWidget {
  final List<Order> orders;
  final String emptyMessage;
  final String emptySubMessage;
  final bool showShoppingButton;

  const _OrdersList({
    required this.orders,
    required this.emptyMessage,
    required this.emptySubMessage,
    this.showShoppingButton = false,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              emptyMessage,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              emptySubMessage,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            if (showShoppingButton) ...[
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/home',
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
                  'Start Shopping',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final orderProvider = Provider.of<OrderProvider>(context, listen: false);
        
        if (authProvider.user != null) {
          await orderProvider.loadOrders(authProvider.user!.id);
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OrderCard(
              order: order,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OrderDetailScreen(order: order),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}