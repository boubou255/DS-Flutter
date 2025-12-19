import 'package:flutter/material.dart';
import 'package:ds_project/services/auth_service.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  void _logout(BuildContext context) async {
    await AuthService().signOut();

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3A7BD5), Color(0xFF00D2FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(25),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.logout,
                  size: 60,
                  color: Color(0xFF3A7BD5),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Déconnexion",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Voulez-vous vraiment vous déconnecter ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 30),

                // 🔹 Logout button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _logout(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A7BD5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Se déconnecter",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Annuler",
                    style: TextStyle(color: Color(0xFF00D2FF)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
