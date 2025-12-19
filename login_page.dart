import 'package:flutter/material.dart';
import 'package:ds_project/pages/registration_page.dart'; // We will create this next

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // --- PLACEHOLDER FOR ACTUAL AUTHENTICATION LOGIC (e.g., Firebase) ---
      // Here, you would call your authentication service to sign in.
      // For now, we simulate a network request delay.
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        // After successful "login" (simulated), navigate to the Home Page.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful (Simulated)!')),
        );
        // Replace current screen with Home Page using named route
        Navigator.pushReplacementNamed(context, '/home');
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3A7BD5), Color(0xFF00D2FF)], // Your gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0), // Padding for screen edges
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Adjusted shadow color
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Bienvenue 👋",
                      style: TextStyle(
                        fontSize: 28, // Slightly larger
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Connectez-vous pour continuer",
                      style: TextStyle(fontSize: 16, color: Colors.black54), // Slightly larger
                    ),
                    const SizedBox(height: 30),

                    // ---------- EMAIL FIELD ----------
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email ou Nom d'utilisateur",
                        prefixIcon: const Icon(Icons.person, color: Colors.blue), // Icon color
                        filled: true,
                        fillColor: Colors.grey[100], // Lighter fill color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none, // No border line
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF3A7BD5), width: 2), // Focused border
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre email ou nom d\'utilisateur';
                        }
                        // Basic email format validation
                        // You might want to make this optional if "username" is also allowed
                        // if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        //    return 'Veuillez entrer une adresse email valide';
                        // }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // ---------- PASSWORD FIELD ----------
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Mot de passe", // Changed to French
                        prefixIcon: const Icon(Icons.lock, color: Colors.blue), // Icon color
                        filled: true,
                        fillColor: Colors.grey[100], // Lighter fill color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none, // No border line
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF3A7BD5), width: 2), // Focused border
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre mot de passe';
                        }
                        if (value.length < 6) {
                          return 'Le mot de passe doit contenir au moins 6 caractères';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Implement forgot password functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Fonction "Mot de passe oublié" à implémenter')),
                          );
                        },
                        child: const Text(
                          "Mot de passe oublié ?",
                          style: TextStyle(color: Color(0xFF3A7BD5)), // Match button color
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ---------- LOGIN BUTTON ----------
                    _isLoading
                        ? const CircularProgressIndicator(color: Color(0xFF3A7BD5)) // Loading indicator color
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3A7BD5), // Your button background color
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 5, // Add a bit of shadow to the button
                              ),
                              child: const Text(
                                "Se connecter",
                                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                    const SizedBox(height: 25),

                    // ---------- REGISTRATION LINK ----------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Pas de compte ?",
                          style: TextStyle(color: Colors.black87),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegistrationPage(), // Navigate to RegistrationPage
                              ),
                            );
                          },
                          child: const Text(
                            "Créer un compte",
                            style: TextStyle(color: Color(0xFF00D2FF), fontWeight: FontWeight.bold), // Match a gradient color
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
