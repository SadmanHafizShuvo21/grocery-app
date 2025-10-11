import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/category_card.dart';
import '../widgets/product_card.dart';
import 'category_products_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _bannerController = PageController();
  int _currentBanner = 0;
  bool _navigatedToAdmin = false;
  String? _cachedRole;
  bool _isRefreshing = false;

  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'Fresh Vegetables',
      'subtitle': 'Get 20% OFF on your first order',
      'color1': const Color(0xFF4CAF50),
      'color2': const Color(0xFF8BC34A),
      'image': 'images/logo.jpg',
      'route': '/categories',
    },
    {
      'title': 'Organic Fruits',
      'subtitle': 'Premium quality organic produce',
      'color1': const Color(0xFFFF9800),
      'color2': const Color(0xFFFFB74D),
      'image': 'images/logo.jpg',
      'route': '/categories',
    },
    {
      'title': 'Dairy Products',
      'subtitle': 'Fresh from local farms',
      'color1': const Color(0xFF2196F3),
      'color2': const Color(0xFF64B5F6),
      'image': 'images/logo.jpg',
      'route': '/categories',
    },
    {
      'title': 'Bakery Products',
      'subtitle': 'Baked fresh every day!',
      'color1': const Color(0xFF795548),
      'color2': const Color(0xFFA1887F),
      'image': 'images/logo.jpg',
      'route': '/categories',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    _startBannerTimer();
  }

  Future<void> _loadUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final role = doc.data()?['role'];
    if (mounted) {
      setState(() => _cachedRole = role);
    }
  }

  void _startBannerTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _currentBanner = (_currentBanner + 1) % _banners.length);
        _bannerController.animateToPage(
          _currentBanner,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        _startBannerTimer();
      }
    });
  }

  void _handleNav(int index) {
    setState(() => _currentIndex = index);
    switch (index) {
      case 1:
        Navigator.pushNamed(context, '/categories');
        break;
      case 2:
        Navigator.pushNamed(context, '/cart');
        break;
      case 3:
        final user = FirebaseAuth.instance.currentUser;
        Navigator.pushNamed(context, user == null ? '/login' : '/profile');
        break;
    }
  }

  Future<void> _refreshHome() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 1));
    await _loadUserRole();
    setState(() => _isRefreshing = false);
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 👇 Redirect admin users
    if (_cachedRole == 'Admin' && !_navigatedToAdmin) {
      _navigatedToAdmin = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/admin-dashboard');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'FreshGrocer',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.grey.shade700),
            onPressed: () => Navigator.pushNamed(context, '/search'),
          ),
          IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.grey.shade700,
            ),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshHome,
        child: SafeArea(
          child: HomeContent(
            banners: _banners,
            pageController: _bannerController,
            currentBanner: _currentBanner,
          ),
        ),
      ),
      floatingActionButton: _cachedRole == 'Admin'
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF4CAF50),
              onPressed: () => Navigator.pushNamed(context, '/add-product'),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _handleNav,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF4CAF50),
      unselectedItemColor: Colors.grey.shade600,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: 'Categories',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}

class HomeContent extends StatelessWidget {
  final List<Map<String, dynamic>> banners;
  final PageController pageController;
  final int currentBanner;

  const HomeContent({
    super.key,
    required this.banners,
    required this.pageController,
    required this.currentBanner,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeHeader(),
          const SizedBox(height: 20),
          _buildBannerCarousel(context),
          const SizedBox(height: 10),
          _buildBannerIndicators(),
          const SizedBox(height: 25),
          _buildCategoriesSection(context),
          const SizedBox(height: 25),
          _buildProductsSection(),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final name = user?.displayName ?? user?.email?.split('@')[0] ?? 'Guest';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $name 👋',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'What would you like to buy today?',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBannerCarousel(BuildContext context) {
    return SizedBox(
      height: 160,
      child: PageView.builder(
        controller: pageController,
        itemCount: banners.length,
        itemBuilder: (context, index) {
          final banner = banners[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [banner['color1'], banner['color2']],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Image.asset(banner['image'], width: 100, height: 100),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        banner['title'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        banner['subtitle'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, banner['route']),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF4CAF50),
                        ),
                        child: const Text('Shop Now'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBannerIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        banners.length,
        (index) => Container(
          margin: const EdgeInsets.all(3),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentBanner
                ? const Color(0xFF4CAF50)
                : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              CategoryCard(
                icon: Icons.apple_outlined,
                title: 'Fruits',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const CategoryProductsScreen(category: 'Fruits'),
                  ),
                ),
              ),
              CategoryCard(
                icon: Icons.grass_outlined,
                title: 'Vegetables',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const CategoryProductsScreen(category: 'Vegetables'),
                  ),
                ),
              ),
              CategoryCard(
                icon: Icons.local_drink_outlined,
                title: 'Dairy',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const CategoryProductsScreen(category: 'Dairy'),
                  ),
                ),
              ),
              CategoryCard(
                icon: Icons.bakery_dining_outlined,
                title: 'Bakery',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const CategoryProductsScreen(category: 'Bakery'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 🔥 Fetch products from Firestore
  Widget _buildProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Latest Products',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('products')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final products = snapshot.data?.docs ?? [];
            if (products.isEmpty) {
              return const Center(child: Text('No products available'));
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final product = products[index].data() as Map<String, dynamic>;
                return ProductCard(
                  name: product['name'] ?? 'Unnamed',
                  price: (product['price'] ?? 0).toDouble(),
                  image: product['imageUrl'] ?? '',
                  category: product['category'] ?? 'General',
                  onTap: () {},
                );
              },
            );
          },
        ),
      ],
    );
  }
}
