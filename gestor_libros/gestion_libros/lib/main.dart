import 'package:flutter/material.dart';
import 'app_routes.dart';

void main() {
  runApp(const LibriDexApp());
}

class LibriDexApp extends StatelessWidget {
  const LibriDexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LibriDex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromARGB(255, 172, 50, 164),
      ),
      // Configuramos las rutas.
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.getRoutes(),
    );
  }
}