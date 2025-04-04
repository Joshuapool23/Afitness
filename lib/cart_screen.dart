import 'dart:convert';
import 'package:advweb_1/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'payment_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, required List<Map<String, dynamic>> cart, required void Function() onCheckout});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cart = [];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString('cart');
    if (cartData != null) {
      setState(() {
        cart = List<Map<String, dynamic>>.from(jsonDecode(cartData));
      });
    }
  }

  Future<void> _saveCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cart', jsonEncode(cart));
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = cart.fold(0, (sum, item) {
      double price = double.tryParse(item['price'].toString()) ?? 0;
      return sum + (price * (item['quantity'] as int));
    });

   return Scaffold(
  backgroundColor: Colors.grey[800],
  appBar: AppBar(
    backgroundColor: Colors.grey[900],
    title: const Text('CART', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()), 
          (route) => false, 
        );
      },
    ),
  ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  var item = cart[index];
                  return Card(
                    color: Colors.grey[700],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: Image.asset(
                        item['image'] ?? 'assets/default_image.png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.white),
                      ),
                      title: Text(
                        item['name'] ?? 'Unknown Item',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      subtitle: Text('\$${item['price']}', style: const TextStyle(color: Colors.green)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                if (item['quantity'] > 1) {
                                  item['quantity']--;
                                  _saveCart();
                                }
                              });
                            },
                          ),
                          Text('${item['quantity']}', style: const TextStyle(color: Colors.white, fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                item['quantity']++;
                                _saveCart();
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () {
                              setState(() {
                                cart.removeAt(index);
                                _saveCart();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: cart.isNotEmpty
                    ? () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(totalAmount: totalPrice),
                          ),
                        );
                        _saveCart();
                      }
                    : null,
                child: Text(
                  'CHECKOUT  \$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}