import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';

class AuthService {
  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';
  
  final Uuid _uuid = const Uuid();

  // Simulated user database (in real app, this would be a backend service)
  static final Map<String, Map<String, dynamic>> _users = {};

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    
    if (!isLoggedIn) return null;
    
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;
    
    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return User.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<AuthResult> login(String email, String password) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Simple validation
    if (email.isEmpty || password.isEmpty) {
      return AuthResult(
        success: false,
        error: 'Email and password are required',
      );
    }

    // Check if user exists in our simulated database
    final user = _users[email.toLowerCase()];
    if (user == null) {
      return AuthResult(
        success: false,
        error: 'User not found',
      );
    }

    if (user['password'] != password) {
      return AuthResult(
        success: false,
        error: 'Invalid password',
      );
    }

    // Create user object (excluding password)
    final userData = Map<String, dynamic>.from(user);
    userData.remove('password');
    final userObj = User.fromJson(userData);

    // Save to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(userObj.toJson()));
    await prefs.setBool(_isLoggedInKey, true);

    return AuthResult(success: true, user: userObj);
  }

  Future<AuthResult> register(String name, String email, String password, {
    String? phone,
    String? address,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Simple validation
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      return AuthResult(
        success: false,
        error: 'Name, email, and password are required',
      );
    }

    if (password.length < 6) {
      return AuthResult(
        success: false,
        error: 'Password must be at least 6 characters',
      );
    }

    // Check if user already exists
    if (_users.containsKey(email.toLowerCase())) {
      return AuthResult(
        success: false,
        error: 'User already exists with this email',
      );
    }

    // Create new user
    final userId = _uuid.v4();
    final user = User(
      id: userId,
      email: email.toLowerCase(),
      name: name,
      phone: phone,
      address: address,
      createdAt: DateTime.now(),
    );

    // Store in simulated database
    _users[email.toLowerCase()] = {
      ...user.toJson(),
      'password': password,
    };

    // Save to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    await prefs.setBool(_isLoggedInKey, true);

    return AuthResult(success: true, user: user);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  Future<AuthResult> updateProfile(User updatedUser) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Update in simulated database
    final userData = _users[updatedUser.email];
    if (userData != null) {
      _users[updatedUser.email] = {
        ...updatedUser.toJson(),
        'password': userData['password'],
      };
    }

    // Save to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(updatedUser.toJson()));

    return AuthResult(success: true, user: updatedUser);
  }
}

class AuthResult {
  final bool success;
  final User? user;
  final String? error;

  AuthResult({
    required this.success,
    this.user,
    this.error,
  });
}