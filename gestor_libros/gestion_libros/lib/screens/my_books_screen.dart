import 'package:flutter/material.dart';
import '../app_routes.dart';

class MyBooksScreen extends StatelessWidget {
  const MyBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos el color principal.
    final Color mainColor = const Color(0xFFB73BB7);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library', 
          style: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold)
        ),
        foregroundColor: mainColor,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // Usamos GridView.
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, 
          crossAxisSpacing: 16, 
          mainAxisSpacing: 16,
          childAspectRatio: 0.75, 
        ),
        itemCount: 8, 
        itemBuilder: (context, index) {
          return GestureDetector(
            // Al tocar cualquier libro, vamos a la pantalla de detalles.
            onTap: () => Navigator.pushNamed(context, AppRoutes.bookDetails),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Contenedor para la portada del libro.
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: mainColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: mainColor.withValues(alpha: 0.1)),
                    ),
                    child: Center(
                      child: Icon(Icons.book_rounded, 
                        size: 50, 
                        color: mainColor.withValues(alpha: 0.3)
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Información del libro.
                const Text(
                  'Book Title',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, 
                ),
                Text(
                  'Author Name',
                  style: TextStyle(color: mainColor.withValues(alpha: 0.7), fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
      // Botón flotante para añadir un nuevo libro rápidamente.
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addBook),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}