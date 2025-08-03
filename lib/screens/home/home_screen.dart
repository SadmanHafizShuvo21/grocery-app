import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/category_chip.dart';
import '../products/product_detail_screen.dart';
import '../products/category_products_screen.dart';
import '../search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    
    await Future.wait([
      productProvider.loadFeaturedProducts(),
      productProvider.loadCategories(),
      cartProvider.loadCart(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return Text(
                        'Hello, ${authProvider.user?.name ?? 'Guest'}!',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[800],
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                ),
                actions: [
                  // Cart Badge
                  Consumer<CartProvider>(
                    builder: (context, cartProvider, child) {
                      return Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_cart_outlined),
                            color: Colors.grey[800],
                            onPressed: () {
                              Navigator.of(context).pushNamed('/cart');
                            },
                          ),
                          if (cartProvider.itemCount > 0)
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '${cartProvider.itemCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SearchScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey[600]),
                          const SizedBox(width: 12),
                          Text(
                            'Search for products...',
                            style: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Categories
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Categories',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Consumer<ProductProvider>(
                      builder: (context, productProvider, child) {
                        if (productProvider.categories.isEmpty) {
                          return const SizedBox(
                            height: 50,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        return SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: productProvider.categories.length,
                            itemBuilder: (context, index) {
                              final category = productProvider.categories[index];
                              if (category == 'All') return const SizedBox.shrink();
                              
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: CategoryChip(
                                  category: category,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => CategoryProductsScreen(
                                          category: category,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              // Featured Products
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured Products',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CategoryProductsScreen(
                                category: 'All',
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'See All',
                          style: GoogleFonts.poppins(
                            color: Colors.green[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // Featured Products Grid
              Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  if (productProvider.isLoading && productProvider.featuredProducts.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  }

                  if (productProvider.featuredProducts.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Container(
                        height: 200,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_basket_outlined,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No featured products available',
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = productProvider.featuredProducts[index];
                          return ProductCard(
                            product: product,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    product: product,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        childCount: productProvider.featuredProducts.length,
                      ),
                    ),
                  );
                },
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }
}