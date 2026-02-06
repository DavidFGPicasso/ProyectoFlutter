import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    // Creamos un temporizador de 3 segundos.
    Timer(const Duration(seconds: 3), () {
      // 'mounted' es una seguridad: comprueba si el usuario no ha cerrado 
      // la app antes de que terminen los 3 segundos.
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Colores específicos para esta pantalla.
    const Color creamBackgroundColor = Color(0xFFF9F7F2);
    const Color deepPurpleAccent = Color(0xFF4A3B69);

    return Scaffold(
      backgroundColor: creamBackgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo.
            // Cargamos la imagen desde la carpeta.
            Image.asset(
              'images/logo.png',
              width: 180, 
              fit: BoxFit.contain, 
            ),

            // Espacio de 50 píxeles entre el logo y el cargador.
            const SizedBox(height: 50),

            // Indicador de Carga.
            const SizedBox(
              width: 30, 
              height: 30,
              child: CircularProgressIndicator(
                color: deepPurpleAccent, 
                strokeWidth: 3.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}