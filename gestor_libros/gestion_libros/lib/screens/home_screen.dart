import 'package:flutter/material.dart';
import '../app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definimos el color para la app.
    final Color mainColor = const Color(0xFFB73BB7);

    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: const Text('LibriDex', 
          style: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold, fontSize: 24)
        ),
        foregroundColor: mainColor,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      // Drawer
      drawer: Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            // Cabecera del menú con el color principal
            DrawerHeader(
              decoration: BoxDecoration(color: mainColor),
              margin: EdgeInsets.zero,
              child: const Center(
                child: Text('LibriDex Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'Serif', fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Lista de opciones de navegación
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Usamos la función para el menú.
                  _drawerTile(context, Icons.book, 'My Books', AppRoutes.myBooks, mainColor),
                  _drawerTile(context, Icons.star, 'Recommended', AppRoutes.recommended, mainColor),
                  _drawerTile(context, Icons.settings, 'Settings', AppRoutes.settings, mainColor),
                  _drawerTile(context, Icons.info, 'Credits', AppRoutes.credits, mainColor),
                ],
              ),
            ),
          ],
        ),
      ),

      // Cuerpo en Grid.
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        // Definimos que haya 2 columnas.
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, 
          crossAxisSpacing: 16, 
          mainAxisSpacing: 16,
        ),
        itemCount: 6, 
        itemBuilder: (context, i) => Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: mainColor.withValues(alpha: 0.1)),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            // Al tocar un libro, vamos a sus detalles
            onTap: () => Navigator.pushNamed(context, AppRoutes.bookDetails),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu_book_rounded, size: 40, color: mainColor.withValues(alpha: 0.5)),
                const SizedBox(height: 8),
                const Text('Book Cover', style: TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ),

      // Botón para agregar libros.
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        // Al pulsar, navegamos a la pantalla de añadir libro.
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addBook),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
  // Funcón para las opciones del menú.
  Widget _drawerTile(BuildContext context, IconData icon, String title, String route, Color color) {
    return ListTile(
      leading: Icon(icon, color: color), 
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.pop(context); 
        Navigator.pushNamed(context, route); 
      },
    );
  }
}