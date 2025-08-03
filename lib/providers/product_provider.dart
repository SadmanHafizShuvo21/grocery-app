import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  
  List<Product> _products = [];
  List<Product> _featuredProducts = [];
  List<Product> _searchResults = [];
  List<String> _categories = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  List<Product> get featuredProducts => _featuredProducts;
  List<Product> get searchResults => _searchResults;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _products = await _productService.getAllProducts();
      _error = null;
    } catch (e) {
      _error = 'Failed to load products';
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadFeaturedProducts() async {
    try {
      _featuredProducts = await _productService.getFeaturedProducts();
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load featured products';
      notifyListeners();
    }
  }

  Future<void> loadCategories() async {
    try {
      _categories = await _productService.getCategories();
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load categories';
      notifyListeners();
    }
  }

  Future<void> loadProductsByCategory(String category) async {
    _isLoading = true;
    _selectedCategory = category;
    notifyListeners();
    
    try {
      _products = await _productService.getProductsByCategory(category);
      _error = null;
    } catch (e) {
      _error = 'Failed to load products for category';
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchProducts(String query) async {
    _searchQuery = query;
    
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    
    _isLoading = true;
    notifyListeners();
    
    try {
      _searchResults = await _productService.searchProducts(query);
      _error = null;
    } catch (e) {
      _error = 'Search failed';
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<Product?> getProductById(String id) async {
    try {
      return await _productService.getProductById(id);
    } catch (e) {
      _error = 'Failed to load product details';
      notifyListeners();
      return null;
    }
  }

  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}