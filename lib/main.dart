import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'providers/order_provider.dart';

// Screens
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/orders/orders_screen.dart';
import 'screens/profile/profile_screen.dart';

// Navigation
import 'widgets/main_navigation.dart';

void main() {
  runApp(const GroceryApp());
}

class GroceryApp extends StatelessWidget {
  const GroceryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        title: 'Grocery App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: GoogleFonts.poppins().fontFamily,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            centerTitle: false,
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey[800],
            elevation: 0,
            titleTextStyle: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
              textStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.green[700],
              side: BorderSide(color: Colors.green[700]!),
              textStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.green[700],
              textStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green[700]!),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
        home: const AppWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const MainNavigation(),
          '/cart': (context) => const CartScreen(),
          '/orders': (context) => const OrdersScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.initializeAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_basket,
                      size: 60,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  Text(
                    'GroceryApp',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    'Fresh groceries delivered to your door',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  
                  const CircularProgressIndicator(),
                ],
              ),
            ),
          );
        }

        if (authProvider.isAuthenticated) {
          return const MainNavigation();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}