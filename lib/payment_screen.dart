import 'package:advweb_1/dbhelper.dart';
import 'package:advweb_1/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class PaymentScreen extends StatefulWidget {
  final double totalAmount;

  const PaymentScreen({super.key, required this.totalAmount});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? selectedPaymentMethod;

  final List<Map<String, dynamic>> paymentMethods = [
    {"name": "Gcash", "icon": FontAwesomeIcons.mobileScreenButton},
    {"name": "Cash on Delivery", "icon": FontAwesomeIcons.moneyBillWave},
    {"name": "PayPal", "icon": FontAwesomeIcons.paypal},
    {"name": "Credit Card", "icon": FontAwesomeIcons.creditCard},
    {"name": "Bank Transfer", "icon": FontAwesomeIcons.university},
  ];

  void _processPayment() async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        selectedPaymentMethod == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please complete all payment details")),
        );
      }
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Payment"),
          content: Text(
            "Name: ${nameController.text}\n"
            "Phone: ${phoneController.text}\n"
            "Address: ${addressController.text}\n"
            "Payment Method: $selectedPaymentMethod\n\n"
            "Proceed with payment?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                // Move cart items to orders in the database
                await DBHelper.moveCartToOrders();

                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Payment Successful via $selectedPaymentMethod"),
                      ),
                    );

                    // Navigate to HomeScreen after payment
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false,
                    );
                  }
                });
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSectionTitle("Personal Information"),
                    buildTextField(nameController, "Full Name", Icons.person),
                    buildTextField(phoneController, "Phone Number", Icons.phone, keyboardType: TextInputType.phone),
                    const Divider(height: 30, thickness: 1),
                    buildSectionTitle("Delivery Address"),
                    buildTextField(addressController, "Enter your address", Icons.location_on),
                    const Divider(height: 30, thickness: 1),
                    buildSectionTitle("Payment Method"),
                    buildPaymentMethods(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Total Amount: ₱${widget.totalAmount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _processPayment,
              child: const Text(
                "Proceed to Payment",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildPaymentMethods() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: paymentMethods.map((method) {
        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(method["icon"], size: 18, color: Colors.white),
              const SizedBox(width: 8),
              Text(method["name"], style: const TextStyle(color: Colors.white)),
            ],
          ),
          selected: selectedPaymentMethod == method["name"],
          selectedColor: Colors.deepPurple,
          backgroundColor: Colors.grey[400],
          onSelected: (bool selected) {
            setState(() {
              selectedPaymentMethod = selected ? method["name"] : null;
            });
          },
        );
      }).toList(),
    );
  }
}
