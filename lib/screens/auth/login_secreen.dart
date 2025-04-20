import 'package:awee/screens/dashbord/dashbord_screen.dart';
import 'package:flutter/material.dart';
import 'package:awee/Services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    final result = await AuthService().login(email, password);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login successful"),
          backgroundColor: Colors.green,
        ),
      );
      print(result['user']);

      if (result['success']) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }

      // Navigate to dashboard
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message']), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Image.asset('assets/login.png'),
            Text(
              'Welcome back!',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',

                labelStyle: TextStyle(color: Colors.white),
              ),
              // validator: (value) => value!.isEmpty ? 'Enter a valid email' : null,
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.white),
              ),

              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                backgroundColor: Color.fromARGB(255, 182, 108, 192),
                padding: EdgeInsets.symmetric(horizontal: 102, vertical: 26),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
