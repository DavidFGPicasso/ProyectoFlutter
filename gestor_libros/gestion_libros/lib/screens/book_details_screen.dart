import 'package:flutter/material.dart';

class BookDetailsScreen extends StatelessWidget {
  const BookDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color mainColor = const Color(0xFFB73BB7);
    
    // Recibe los datos del libro desde la navegación
    final book = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    // Extrae los datos del libro
    final String title = book?['title'] ?? 'Unknown Title';
    final String author = book?['author'] ?? 'Unknown Author';
    final String thumbnail = book?['thumbnail'] ?? '';
    final String description = book?['description'] ?? 'No description available.';
    final bool isFinished = book?['isFinished'] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details', 
          style: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold)
        ),
        foregroundColor: mainColor, 
        backgroundColor: Colors.transparent, 
        elevation: 0,
      ),
    
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Portada del libro
            Center( 
              child: Container(
                height: 220,
                width: 150,
                decoration: BoxDecoration(
                  color: mainColor.withValues(alpha: 0.1), 
                  borderRadius: BorderRadius.circular(12), 
                  border: Border.all(color: mainColor.withValues(alpha: 0.2)),
                ),
                child: thumbnail.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          thumbnail,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.book, 
                              size: 80, 
                              color: mainColor.withValues(alpha: 0.3)
                            );
                          },
                        ),
                      )
                    : Icon(Icons.book, 
                        size: 80, 
                        color: mainColor.withValues(alpha: 0.3)
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // Título del libro
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            
            // Autor
            Center(
              child: Text(
                author,
                style: TextStyle(
                  fontSize: 16,
                  color: mainColor.withValues(alpha:0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 24),

            // Estado de lectura
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isFinished 
                      ? Colors.green.withValues(alpha: 0.1) 
                      : mainColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isFinished 
                        ? Colors.green 
                        : mainColor,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isFinished ? Icons.check_circle : Icons.bookmark,
                      size: 16,
                      color: isFinished ? Colors.green : mainColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isFinished ? 'Finished' : 'Reading',
                      style: TextStyle(
                        color: isFinished ? Colors.green : mainColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Descripción
            Text(
              'DESCRIPTION', 
              style: TextStyle(
                color: mainColor, 
                fontWeight: FontWeight.bold, 
                letterSpacing: 1.2
              )
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 16, height: 1.5), 
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}