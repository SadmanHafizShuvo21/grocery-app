import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<void> initializeAuth() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _user = await _authService.getCurrentUser();
      _error = null;
    } catch (e) {
      _error = 'Failed to initialize authentication';
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.login(email, password);
      
      if (result.success) {
        _user = result.user;
        _error = null;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = result.error;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Login failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password, {
    String? phone,
    String? address,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.register(
        name,
        email,
        password,
        phone: phone,
        address: address,
      );
      
      if (result.success) {
        _user = result.user;
        _error = null;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = result.error;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Registration failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _user = null;
      _error = null;
    } catch (e) {
      _error = 'Logout failed';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateProfile(User updatedUser) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.updateProfile(updatedUser);
      
      if (result.success) {
        _user = result.user;
        _error = null;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = result.error;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Profile update failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}