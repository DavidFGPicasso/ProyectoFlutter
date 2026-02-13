import 'package:flutter/material.dart';

class BookDetailsScreen extends StatelessWidget {
  const BookDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos el color principal de la app.
    final Color mainColor = const Color(0xFFB73BB7);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details', style: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold)),
        // Ponemos la flecha de color morado.
        foregroundColor: mainColor, 
        backgroundColor: Colors.transparent, 
        elevation: 0,
      ),
    
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contenedor para la portada del libro.
            Center( 
              child: Container(
                height: 220,
                width: 150,
                decoration: BoxDecoration(
                  // Fondo morado
                  color: mainColor.withValues(alpha: 0.1), 
                  borderRadius: BorderRadius.circular(12), 
                  border: Border.all(color: mainColor.withValues(alpha: 0.2)),
                ),
                child: Icon(Icons.book, size: 80, color: mainColor.withValues(alpha: 0.3)),
              ),
            ),
            const SizedBox(height: 24),

            // Resumen de los libros.
            Text('SUMMARY', style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            const SizedBox(height: 8),
            const Text(
              'A brief and engaging summary of the book content goes here to inspire the reader.',
              style: TextStyle(fontSize: 16, height: 1.5), 
            ),
            
            const SizedBox(height: 24),

            // Progreso de la lectura.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: [
                const Text('Reading Progress', style: TextStyle(fontWeight: FontWeight.w500)),
                Text('40%', style: TextStyle(color: mainColor, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            // ClipRRect sirve para que la barra de progreso también tenga esquinas redondeadas
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                // Indica el progreso de la barra.
                value: 0.4, 
                // Grosor de la barra
                minHeight: 8, 
                backgroundColor: mainColor.withValues(alpha: 0.1),
                color: mainColor,
              ),
            ),

            const SizedBox(height: 24),

            // Detalles
            Text('DETAILS', style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            const SizedBox(height: 8),
            const Text('Author: Jane Doe\nPages: 320\nPublisher: LibriDex Press', 
              style: TextStyle(fontSize: 15, height: 1.8) 
            ),
          ],
        ),
      ),
    );
  }
}