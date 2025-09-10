import 'package:flutter/material.dart';
import 'core/app_router.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF004182),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0a66c2),
          primary: const Color(0xFF0a66c2),
          secondary: const Color(0xFF004182),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      routerConfig: routerApp,
    );
  }
}
