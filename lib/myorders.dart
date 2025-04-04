import 'package:advweb_1/dbhelper.dart';
import 'package:flutter/material.dart';


class MyOrders extends StatefulWidget {
  const MyOrders({super.key, required List orders});

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final dbOrders = await DBHelper.instance.getOrders();
    setState(() {
      orders = dbOrders;
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Preparing":
        return Colors.orange;
      case "Shipped Out":
        return Colors.blue;
      case "Delivered":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MY ORDERS",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: orders.isEmpty
          ? const Center(
              child: Text("No orders yet!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];

                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[300],
                              ),
                              child: const Icon(Icons.shopping_bag, size: 40),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(order["productName"],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Text("Status: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Chip(
                              label: Text(order["status"]),
                              backgroundColor: _getStatusColor(order["status"]),
                              labelStyle: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        Text("Order Date: ${order["orderDate"]}",
                            style: const TextStyle(fontSize: 14)),
                        Text("Order ID: ${order["orderId"]}",
                            style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 8),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text("Possible Shipping Date:",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold)),
                              Text(order["shippingDate"],
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              
                            },
                            child: const Text("View Details"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
