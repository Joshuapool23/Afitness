import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'profile_screen.dart';
import 'cart_screen.dart';
import 'myorders.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> cart = [];

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _loadCart();
    _pages = [
      HomeContent(onAddToCart: _addToCart),
      CartScreen(cart: cart, onCheckout: _handleCheckout),
      MyOrders(orders: []),
      const ProfileScreen(),
    ];
  }

  void _loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString('cart');
    if (cartData != null) {
      setState(() {
        cart = List<Map<String, dynamic>>.from(jsonDecode(cartData));
      });
    }
  }

  void _saveCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cart', jsonEncode(cart));
  }

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      cart.add(product);
    });
    _saveCart();
  }

  void _handleCheckout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> orders = [];
    String? ordersData = prefs.getString('orders');
    if (ordersData != null) {
      orders = List<Map<String, dynamic>>.from(jsonDecode(ordersData));
    }
    orders.addAll(cart);
    await prefs.setString('orders', jsonEncode(orders));
    setState(() {
      cart.clear();
    });
    _saveCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search here',
            hintStyle: const TextStyle(color: Colors.white70),
            prefixIcon: const Icon(Icons.menu, color: Colors.white),
            suffixIcon: const Icon(Icons.search, color: Colors.white),
            filled: true,
            fillColor: Colors.grey[700],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.green,
        selectedItemColor: const Color.fromARGB(255, 49, 244, 0),
        unselectedItemColor: const Color.fromARGB(137, 74, 192, 0),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'My Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final Function(Map<String, dynamic>) onAddToCart;

  const HomeContent({super.key, required this.onAddToCart});

  final List<Map<String, String>> products = const [
    {'name': 'Treadmill', 'image': 'assets/images/treadmill.jpg', 'price': '500'},
    {'name': 'Dumbbells', 'image': 'assets/images/dumbbells.jpg', 'price': '100'},
    {'name': 'Protein Powder', 'image': 'assets/images/protein.jpg', 'price': '60'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.75,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(
            product: products[index],
            onAddToCart: onAddToCart,
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Map<String, String> product;
  final Function(Map<String, dynamic>) onAddToCart;

  const ProductCard({super.key, required this.product, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              product: product,
              onAddToCart: onAddToCart,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[700],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.asset(product['image']!, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name']!,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${product['price']}',
                    style: const TextStyle(color: Colors.green, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailScreen extends StatefulWidget {
  final Map<String, String> product;
  final Function(Map<String, dynamic>) onAddToCart;

  const ProductDetailScreen({super.key, required this.product, required this.onAddToCart});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(widget.product['name']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Image.asset(widget.product['image']!),
            ),
            Text(
              widget.product['name']!,
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${widget.product['price']}',
              style: const TextStyle(color: Colors.green, fontSize: 18),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      if (quantity > 1) quantity--;
                    });
                  },
                ),
                Text('$quantity', style: const TextStyle(color: Colors.white, fontSize: 20)),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                widget.onAddToCart({
                  'name': widget.product['name'],
                  'price': widget.product['price'],
                  'quantity': quantity
                });
                Navigator.pop(context);
              },
              child: const Text('Add to Cart', style: TextStyle(color: Colors.black, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
