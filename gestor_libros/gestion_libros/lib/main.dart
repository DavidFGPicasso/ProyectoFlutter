import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'package:provider/provider.dart';
import 'app_routes.dart';
import 'model/theme_provider.dart'; 


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializamos Firebase
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const LibriDexApp(),
    ),
  );
}

class LibriDexApp extends StatelessWidget {
  const LibriDexApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el estado del tema
    final themeProvider = Provider.of<ThemeProvider>(context);
    const Color mainColor = Color(0xFFB73BB7);

    return MaterialApp(
      title: 'LibriDex',
      debugShowCheckedModeBanner: false,
      
      // Modo Oscuro.
      themeMode: themeProvider.themeMode, 
      
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: mainColor,
      ),
      
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: mainColor,
      ),

      initialRoute: AppRoutes.splash,
      routes: AppRoutes.getRoutes(),
    );
  }
}