import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';
import '../products/product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.searchProducts(query);
  }

  void _clearSearch() {
    _searchController.clear();
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          height: 40,
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search products...',
              hintStyle: GoogleFonts.poppins(
                color: Colors.grey[500],
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey[600],
                size: 20,
              ),
              suffixIcon: Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  if (productProvider.searchQuery.isNotEmpty) {
                    return IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      onPressed: _clearSearch,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.green[700]!),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            style: GoogleFonts.poppins(
              fontSize: 16,
            ),
          ),
        ),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          // Show search suggestions or recent searches when no query
          if (productProvider.searchQuery.isEmpty) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Popular Searches',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Apple',
                      'Banana',
                      'Milk',
                      'Bread',
                      'Eggs',
                      'Chicken',
                      'Rice',
                      'Organic',
                    ].map((suggestion) {
                      return InkWell(
                        onTap: () {
                          _searchController.text = suggestion;
                          _onSearchChanged(suggestion);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                suggestion,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Search by Category',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      'Fruits & Vegetables',
                      'Dairy & Eggs',
                      'Meat & Seafood',
                      'Bakery',
                      'Pantry',
                      'Beverages',
                    ].map((category) {
                      return InkWell(
                        onTap: () {
                          _searchController.text = category;
                          _onSearchChanged(category);
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
                          child: Column(
                            children: [
                              Icon(
                                _getCategoryIcon(category),
                                size: 24,
                                color: Colors.green[700],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                category,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }

          // Show loading
          if (productProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error
          if (productProvider.error != null) {
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
                    'Search failed',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    productProvider.error!,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Show search results
          final searchResults = productProvider.searchResults;

          if (searchResults.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No results found',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try searching for something else',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // Search Results Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${searchResults.length} results for "${productProvider.searchQuery}"',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Search Results Grid
              SliverPadding(
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
                      final product = searchResults[index];
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
                    childCount: searchResults.length,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'fruits & vegetables':
        return Icons.eco;
      case 'dairy & eggs':
        return Icons.egg;
      case 'meat & seafood':
        return Icons.set_meal;
      case 'bakery':
        return Icons.bakery_dining;
      case 'pantry':
        return Icons.kitchen;
      case 'beverages':
        return Icons.local_drink;
      default:
        return Icons.category;
    }
  }
}