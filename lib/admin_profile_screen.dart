import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import your login screen for logout functionality

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  void _logout(BuildContext context) {
    // Navigate back to the login screen (you can add Firebase Auth if needed)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Admin Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 34, 150, 34), // Dark Green
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/admin_avatar.png'), // Update with actual image
            ),
            const SizedBox(height: 10),
            const Text(
              'Admin Name',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const Text(
              'admin@example.com',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            
            // Edit Profile Button
            _buildProfileButton(Icons.edit, "Edit Profile", () {
              // Navigate to edit profile screen (create this later if needed)
            }),

            // Change Password Button
            _buildProfileButton(Icons.lock, "Change Password", () {
              // Navigate to change password screen (create this later if needed)
            }),

            // Logout Button
            _buildProfileButton(Icons.logout, "Logout", () {
              _logout(context);
            }, color: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileButton(IconData icon, String title, VoidCallback onTap, {Color color = Colors.green}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
