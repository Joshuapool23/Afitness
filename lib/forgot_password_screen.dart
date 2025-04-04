import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? message;

  Future<void> resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text.trim());
      setState(() {
        message = "Password reset email sent! Check your inbox.";
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        message = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(title: Text('Forgot Password')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Reset Password',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email Address', filled: true, fillColor: Colors.black),
            ),
            SizedBox(height: 10),
            if (message != null)
              Text(message!, style: TextStyle(color: message!.contains("sent") ? Colors.green : Colors.red)),
            SizedBox(height: 10),
            ElevatedButton(onPressed: resetPassword, child: Text('Reset Password')),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
