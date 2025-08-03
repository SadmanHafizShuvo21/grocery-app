import '../models/product.dart';

class ProductService {
  // Mock data for demonstration
  static final List<Product> _products = [
    // Fruits & Vegetables
    Product(
      id: '1',
      name: 'Fresh Apples',
      description: 'Crisp red apples, perfect for snacking',
      price: 3.99,
      category: 'Fruits & Vegetables',
      imageUrl: 'https://images.unsplash.com/photo-1567306301408-9b74779a11af',
      unit: 'kg',
      discount: 10,
      tags: ['fresh', 'organic', 'healthy'],
      rating: 4.5,
      reviewCount: 124,
      stockQuantity: 50,
    ),
    Product(
      id: '2',
      name: 'Bananas',
      description: 'Fresh yellow bananas, rich in potassium',
      price: 2.49,
      category: 'Fruits & Vegetables',
      imageUrl: 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e',
      unit: 'kg',
      tags: ['fresh', 'tropical'],
      rating: 4.3,
      reviewCount: 89,
      stockQuantity: 75,
    ),
    Product(
      id: '3',
      name: 'Organic Spinach',
      description: 'Fresh organic spinach leaves',
      price: 4.99,
      category: 'Fruits & Vegetables',
      imageUrl: 'https://images.unsplash.com/photo-1576045057995-568f588f82fb',
      unit: 'bunch',
      tags: ['organic', 'leafy', 'healthy'],
      rating: 4.7,
      reviewCount: 67,
      stockQuantity: 30,
    ),
    
    // Dairy & Eggs
    Product(
      id: '4',
      name: 'Fresh Milk',
      description: 'Whole milk, 1 liter bottle',
      price: 2.99,
      category: 'Dairy & Eggs',
      imageUrl: 'https://images.unsplash.com/photo-1550583724-b2692b85b150',
      unit: 'liter',
      tags: ['dairy', 'calcium'],
      rating: 4.6,
      reviewCount: 203,
      stockQuantity: 45,
    ),
    Product(
      id: '5',
      name: 'Free Range Eggs',
      description: 'Farm fresh free-range eggs, dozen',
      price: 5.49,
      category: 'Dairy & Eggs',
      imageUrl: 'https://images.unsplash.com/photo-1518569656558-1f25e69d93d7',
      unit: 'dozen',
      discount: 5,
      tags: ['free-range', 'protein'],
      rating: 4.8,
      reviewCount: 156,
      stockQuantity: 60,
    ),
    
    // Meat & Seafood
    Product(
      id: '6',
      name: 'Chicken Breast',
      description: 'Fresh boneless chicken breast',
      price: 8.99,
      category: 'Meat & Seafood',
      imageUrl: 'https://images.unsplash.com/photo-1604503468506-a8da13d82791',
      unit: 'kg',
      tags: ['protein', 'lean'],
      rating: 4.4,
      reviewCount: 78,
      stockQuantity: 25,
    ),
    Product(
      id: '7',
      name: 'Atlantic Salmon',
      description: 'Fresh Atlantic salmon fillet',
      price: 12.99,
      category: 'Meat & Seafood',
      imageUrl: 'https://images.unsplash.com/photo-1544943910-4c1dc44aab44',
      unit: 'kg',
      discount: 15,
      tags: ['omega-3', 'fresh', 'premium'],
      rating: 4.7,
      reviewCount: 92,
      stockQuantity: 15,
    ),
    
    // Bakery
    Product(
      id: '8',
      name: 'Whole Wheat Bread',
      description: 'Fresh baked whole wheat bread loaf',
      price: 3.49,
      category: 'Bakery',
      imageUrl: 'https://images.unsplash.com/photo-1549931319-a545dcf3bc73',
      unit: 'loaf',
      tags: ['whole-grain', 'fresh'],
      rating: 4.2,
      reviewCount: 145,
      stockQuantity: 40,
    ),
    Product(
      id: '9',
      name: 'Croissants',
      description: 'Buttery French croissants, pack of 4',
      price: 4.99,
      category: 'Bakery',
      imageUrl: 'https://images.unsplash.com/photo-1555507036-ab794f575ca7',
      unit: 'pack',
      tags: ['pastry', 'buttery'],
      rating: 4.6,
      reviewCount: 88,
      stockQuantity: 20,
    ),
    
    // Pantry
    Product(
      id: '10',
      name: 'Basmati Rice',
      description: 'Premium basmati rice, 2kg bag',
      price: 7.99,
      category: 'Pantry',
      imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e31c',
      unit: '2kg bag',
      tags: ['grain', 'aromatic'],
      rating: 4.5,
      reviewCount: 167,
      stockQuantity: 80,
    ),
  ];

  static final List<String> _categories = [
    'All',
    'Fruits & Vegetables',
    'Dairy & Eggs',
    'Meat & Seafood',
    'Bakery',
    'Pantry',
    'Beverages',
    'Snacks',
    'Frozen Foods',
    'Personal Care',
  ];

  Future<List<Product>> getAllProducts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_products);
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (category == 'All') {
      return List.from(_products);
    }
    
    return _products.where((product) => product.category == category).toList();
  }

  Future<List<String>> getCategories() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_categories);
  }

  Future<Product?> getProductById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));
    
    if (query.isEmpty) {
      return List.from(_products);
    }
    
    final lowercaseQuery = query.toLowerCase();
    
    return _products.where((product) {
      return product.name.toLowerCase().contains(lowercaseQuery) ||
             product.description.toLowerCase().contains(lowercaseQuery) ||
             product.category.toLowerCase().contains(lowercaseQuery) ||
             product.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  Future<List<Product>> getFeaturedProducts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Return products with discounts or high ratings
    return _products.where((product) => 
      product.hasDiscount || product.rating >= 4.5
    ).take(6).toList();
  }

  Future<List<Product>> getRecommendedProducts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Return products with high ratings
    return _products.where((product) => product.rating >= 4.0).take(8).toList();
  }
}