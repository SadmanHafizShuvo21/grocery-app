import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Shopping Cart',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: const Center(
          child: Text(
            'Please log in to view your cart.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Shopping Cart',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final cartItems = snapshot.data?.docs ?? [];

          if (cartItems.isEmpty) {
            return const Center(
              child: Text(
                'Your cart is empty 🛒',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          double subtotal = 0.0;
          for (var item in cartItems) {
            final data = item.data() as Map<String, dynamic>;
            final price = (data['price'] ?? 0.0).toDouble();
            final quantity = (data['quantity'] ?? 1).toInt();
            subtotal += price * quantity;
          }
          double deliveryFee = 2.0;
          double total = subtotal + deliveryFee;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final data = cartItems[index].data() as Map<String, dynamic>;
                    final docId = cartItems[index].id;

                    return CartItem(
                      name: data['name'] ?? 'Product',
                      price: (data['price'] ?? 0.0).toDouble(),
                      image: data['imageUrl'] ?? 'https://via.placeholder.com/150',
                      quantity: (data['quantity'] ?? 1).toInt(),
                      onIncrease: () {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .collection('cart')
                            .doc(docId)
                            .update({'quantity': FieldValue.increment(1)});
                      },
                      onDecrease: () {
                        final currentQty = (data['quantity'] ?? 1).toInt();
                        if (currentQty > 1) {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('cart')
                              .doc(docId)
                              .update({'quantity': FieldValue.increment(-1)});
                        } else {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('cart')
                              .doc(docId)
                              .delete();
                        }
                      },
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal'),
                        Text(
                          '\$${subtotal.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Delivery Fee'),
                        Text(
                          '\$${deliveryFee.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/checkout');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Proceed to Checkout',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
