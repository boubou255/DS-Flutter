import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

// Pages
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/pets_page.dart';
import 'pages/add_pet_page.dart';
import 'pages/pet_details_page.dart';
import 'pages/meetup_scheduling_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalbi - Adopt & Connect',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF3A7BD5),
          foregroundColor: Colors.white,
        ),
      ),

      home: const AuthWrapper(),

      routes: {
        '/home': (_) => const HomePage(),
        '/dashboard': (_) => const DashboardPage(),
        '/pets': (_) => const PetsPage(),
        '/add_pet': (_) => const AddPetPage(),
      },

      onGenerateRoute: (settings) {
        if (settings.name == '/pet_details') {
          final petId = settings.arguments as String?;
          return MaterialPageRoute(
            builder: (_) => PetDetailsPage(petId: petId ?? ''),
          );
        }

        if (settings.name == '/meetup_scheduling') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (_) => MeetupSchedulingPage(
              petId: args?['petId'],
              ownerId: args?['ownerId'],
            ),
          );
        }
        return null;
      },
    );
  }
}

// 🔐 Auth Wrapper (NO AppBar)
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const HomePage();
        }

        return const LoginPage();
      },
    );
  }
}
