import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'core/app_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('es_ES', null);

  await Supabase.initialize(
    url: 'https://qkppcsbnfgmgsjphopno.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFrcHBjc2JuZmdtZ3NqcGhvcG5vIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE2NTAwMjksImV4cCI6MjA3NzIyNjAyOX0.JqZwXrSSuXTzs6yCredR0JkPNAEJBJgcJB7CcuIySJw',
  );
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF004182),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0a66c2),
          primary: const Color(0xFF0a66c2),
          secondary: const Color(0xFF004182),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      routerConfig: routerApp,
    );
  }
}
