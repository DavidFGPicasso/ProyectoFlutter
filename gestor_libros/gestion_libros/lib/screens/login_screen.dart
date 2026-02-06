import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const Color mainColor = Color(0xFFB73BB7);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const SizedBox(height: 60),
            
            // Logo
            Image.asset('images/logo.png', height: 100),
            
            const SizedBox(height: 20),
            const Text('LIBRIDEX', 
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: mainColor, letterSpacing: 2)
            ),
            
            const SizedBox(height: 50),

            // Campos de texto.
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email, color: mainColor)),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock, color: mainColor)),
            ),
            
            const SizedBox(height: 50),

            // Botón principal.
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                style: ElevatedButton.styleFrom(backgroundColor: mainColor, foregroundColor: Colors.white),
                child: const Text('LOGIN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}