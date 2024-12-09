import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'HomePage/home.dart';
import 'LogIn/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyMateApp());
}

class MyMateApp extends StatelessWidget {
  const MyMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyMate',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0XFFE65951),
          primary: const Color.fromRGBO(192, 77, 71, 1),
          secondary: const Color(0XFFE65951),
        ),
      ),
      routes: {
        '/': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color.fromRGBO(192, 77, 71, 1)],
          ),
        ),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 180),
              Image.asset('assets/logo.png'),
              const SizedBox(height: 60),
              Image.asset('assets/image.png'),
            ],
          ),
        ),
      ),
    );
  }
}
