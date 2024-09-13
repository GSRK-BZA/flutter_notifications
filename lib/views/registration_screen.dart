// lib/views/registration_screen.dart
import 'package:flutter/material.dart';
import '../models/auth_model.dart';
import '../controllers/auth_controller.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController _authController = AuthController(AuthModel());
  String email = '';
  String password = '';
  String errorMessage = '';

  void _register() async {
    await _authController.register(
      context,
      email,
      password,
      (successMessage) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      },
      (error) {
        setState(() {
          errorMessage = error;
        });
      },
    );
  }

  void _login() async {
    await _authController.login(
      context,
      email,
      password,
      (successMessage) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      },
      (error) {
        setState(() {
          errorMessage = error;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register or Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                email = value;
              },
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  fontSize: 16.0,  // Font size of the label
                  color: Colors.grey[600],  // Color of the label
                ),
                hintText: 'Enter your email',
                hintStyle: TextStyle(
                  fontSize: 16.0,  // Font size of the hint text
                  color: Colors.grey[400],  // Color of the hint text
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),  // Rounded corners
                  borderSide: BorderSide(
                    color: Colors.blue,  // Border color
                    width: 2.0,  // Border width
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),  // Rounded corners
                  borderSide: BorderSide(
                    color: Colors.blueGrey,  // Border color when enabled
                    width: 1.5,  // Border width when enabled
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),  // Rounded corners
                  borderSide: BorderSide(
                    color: Colors.blueAccent,  // Border color when focused
                    width: 2.0,  // Border width when focused
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),  // Padding inside the field
              ),
            ),

            SizedBox(height: 15.0),  // Margin at the top
            TextField(
              onChanged: (value) {
                password = value;
              },
              obscureText: true,  // Hides the password text
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                  fontSize: 16.0,  // Font size of the label
                  color: Colors.grey[600],  // Color of the label
                ),
                hintText: 'Enter your password',
                hintStyle: TextStyle(
                  fontSize: 16.0,  // Font size of the hint text
                  color: Colors.grey[400],  // Color of the hint text
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),  // Rounded corners
                  borderSide: BorderSide(
                    color: Colors.blue,  // Border color
                    width: 2.0,  // Border width
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),  // Rounded corners
                  borderSide: BorderSide(
                    color: Colors.blueGrey,  // Border color when enabled
                    width: 1.5,  // Border width when enabled
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),  // Rounded corners
                  borderSide: BorderSide(
                    color: Colors.blueAccent,  // Border color when focused
                    width: 2.0,  // Border width when focused
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),  // Padding inside the field
              ),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
