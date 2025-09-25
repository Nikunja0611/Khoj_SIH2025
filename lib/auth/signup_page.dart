import 'package:flutter/material.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  bool otpSent = false;

  void _sendOtp() {
    setState(() {
      otpSent = true;
    });
    // TODO: Trigger OTP API here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("OTP sent to your email")),
    );
  }

  void _signup() {
    if (_formKey.currentState!.validate() && otpSent) {
      // TODO: Verify OTP & Register API call
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup successful! Please login.")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
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
            child: ListView(
              shrinkWrap: true,
              children: [
                const Text("Tourist Signup",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: "Username"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter a username" : null,
                ),
                const SizedBox(height: 10),
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
                      value!.isEmpty ? "Enter a password" : null,
                ),
                const SizedBox(height: 20),
                if (otpSent)
                  TextFormField(
                    controller: otpController,
                    decoration: const InputDecoration(labelText: "Enter OTP"),
                    validator: (value) =>
                        value!.isEmpty ? "Enter the OTP" : null,
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: otpSent ? _signup : _sendOtp,
                  child: Text(otpSent ? "Verify & Signup" : "Send OTP"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                  child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
