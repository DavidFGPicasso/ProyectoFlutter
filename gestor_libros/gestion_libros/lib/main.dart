import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'app_routes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializamos Firebase
  await Firebase.initializeApp();

  runApp(const LibriDexApp());
}

class LibriDexApp extends StatefulWidget {
  const LibriDexApp({super.key});

  @override
  State<LibriDexApp> createState() => _LibriDexAppState();
}

class _LibriDexAppState extends State<LibriDexApp> {
  ThemeMode _themeMode = ThemeMode.light;

  late final ValueNotifier<bool> _themeNotifier;

  bool get _isDarkMode => _themeMode == ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    _themeNotifier = ValueNotifier<bool>(_isDarkMode);
    _themeNotifier.addListener(() {
      setState(() {
        _themeMode = _themeNotifier.value ? ThemeMode.dark : ThemeMode.light;
      });
    });
  }

  @override
  void dispose() {
    _themeNotifier.removeListener(() {});
    _themeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color mainColor = Color(0xFFB73BB7);

    return MaterialApp(
      title: 'LibriDex',
      debugShowCheckedModeBanner: false,
      
      // Modo Oscuro.
      themeMode: _themeMode,
      
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
      routes: AppRoutes.getRoutes(
        themeNotifier: _themeNotifier,
      ),
    );
  }
}