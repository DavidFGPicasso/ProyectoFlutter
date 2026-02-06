import 'package:flutter/material.dart';

class RecommendedBooksScreen extends StatelessWidget {
  const RecommendedBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Color de la app principal.
    final Color mainColor = const Color(0xFFB73BB7);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended', 
          style: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold)
        ),
        foregroundColor: mainColor,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Usamos SingleChildScrollView con scroll horizontal para las etiquetas.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              // .map convierte nuestra lista de palabras en widgets para las secciones.
              children: ['Science', 'Story', 'Fantasy', 'History']
                  .map((cat) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ActionChip(
                          label: Text(cat),
                          labelStyle: TextStyle(color: mainColor, fontWeight: FontWeight.bold),
                          side: BorderSide(color: mainColor.withValues(alpha: 0.2)),
                          backgroundColor: mainColor.withValues(alpha: 0.05),
                          onPressed: () {
                          },
                        ),
                      ))
                  // Convertimos el mapa de nuevo a una lista de widgets
                  .toList(), 
            ),
          ),

          // Recomendaciones en GridView.
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 6, 
              itemBuilder: (context, index) => Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: mainColor.withValues(alpha: 0.1)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icono de estrella para diferenciar que son recomendados.
                    Icon(Icons.star_outline_rounded, 
                      size: 40, 
                      color: mainColor.withValues(alpha: 0.4)
                    ),
                    const SizedBox(height: 8),
                    const Text('Recommendation', 
                      style: TextStyle(fontWeight: FontWeight.w500)
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        onPressed: () {
        },
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}