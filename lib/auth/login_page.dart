import 'package:flutter/material.dart';
import 'signup_page.dart';
import '../features/profile/profile_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      // For now, just navigate to ProfilePage without API
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Tourist Login",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter your email" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Password"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter your password" : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text("Login"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupPage()),
                    );
                  },
                  child: const Text("Don’t have an account? Sign up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
