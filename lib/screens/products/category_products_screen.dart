import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/category_chip.dart';
import 'product_detail_screen.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String category;

  const CategoryProductsScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  String _sortBy = 'name';
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProducts();
    });
  }

  Future<void> _loadProducts() async {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    await productProvider.loadProductsByCategory(widget.category);
  }

  List<dynamic> _getSortedProducts(List<dynamic> products) {
    final sortedProducts = List.from(products);
    
    sortedProducts.sort((a, b) {
      dynamic aValue, bValue;
      
      switch (_sortBy) {
        case 'name':
          aValue = a.name.toLowerCase();
          bValue = b.name.toLowerCase();
          break;
        case 'price':
          aValue = a.discountedPrice;
          bValue = b.discountedPrice;
          break;
        case 'rating':
          aValue = a.rating;
          bValue = b.rating;
          break;
        default:
          aValue = a.name.toLowerCase();
          bValue = b.name.toLowerCase();
      }
      
      if (_sortAscending) {
        return aValue.compareTo(bValue);
      } else {
        return bValue.compareTo(aValue);
      }
    });
    
    return sortedProducts;
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sort by',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              _SortOption(
                title: 'Name',
                value: 'name',
                isSelected: _sortBy == 'name',
                isAscending: _sortAscending,
                onTap: () {
                  setState(() {
                    if (_sortBy == 'name') {
                      _sortAscending = !_sortAscending;
                    } else {
                      _sortBy = 'name';
                      _sortAscending = true;
                    }
                  });
                  Navigator.pop(context);
                },
              ),
              _SortOption(
                title: 'Price',
                value: 'price',
                isSelected: _sortBy == 'price',
                isAscending: _sortAscending,
                onTap: () {
                  setState(() {
                    if (_sortBy == 'price') {
                      _sortAscending = !_sortAscending;
                    } else {
                      _sortBy = 'price';
                      _sortAscending = true;
                    }
                  });
                  Navigator.pop(context);
                },
              ),
              _SortOption(
                title: 'Rating',
                value: 'rating',
                isSelected: _sortBy == 'rating',
                isAscending: _sortAscending,
                onTap: () {
                  setState(() {
                    if (_sortBy == 'rating') {
                      _sortAscending = !_sortAscending;
                    } else {
                      _sortBy = 'rating';
                      _sortAscending = false; // Start with highest rating
                    }
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.category,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortOptions,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

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
                    'Error loading products',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadProducts,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final sortedProducts = _getSortedProducts(productProvider.products);

          if (sortedProducts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_basket_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No products found',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check back later for new products',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadProducts,
            child: CustomScrollView(
              slivers: [
                // Category filter chips (for All category)
                if (widget.category == 'All')
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Filter by Category',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: productProvider.categories.length,
                            itemBuilder: (context, index) {
                              final category = productProvider.categories[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: CategoryChip(
                                  category: category,
                                  isSelected: category == productProvider.selectedCategory,
                                  onTap: () {
                                    productProvider.loadProductsByCategory(category);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                // Sort info
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      children: [
                        Text(
                          '${sortedProducts.length} products',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Sorted by ${_sortBy} ${_sortAscending ? '↑' : '↓'}',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Products Grid
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
                        final product = sortedProducts[index];
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
                      childCount: sortedProducts.length,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  final String title;
  final String value;
  final bool isSelected;
  final bool isAscending;
  final VoidCallback onTap;

  const _SortOption({
    required this.title,
    required this.value,
    required this.isSelected,
    required this.isAscending,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? Colors.green[700] : Colors.grey[800],
        ),
      ),
      trailing: isSelected
          ? Icon(
              isAscending ? Icons.arrow_upward : Icons.arrow_downward,
              color: Colors.green[700],
            )
          : null,
      onTap: onTap,
    );
  }
}