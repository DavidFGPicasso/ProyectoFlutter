import 'package:flutter/material.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  // TextEditingController para controlar lo que el usuario escribe en el buscador.
  final _searchController = TextEditingController();
  
  // Variable para saber si el libro está terminado o no.
  bool _isFinished = false;

  @override
  void dispose() {
    // Apagamos el controlador para ahorrar memoria.
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Color principal de la app.
    final Color mainColor = const Color(0xFFB73BB7);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Book', 
          style: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold)
        ),
        // foregroundColor hace que la flecha de volver y el título sean morados
        foregroundColor: mainColor, 
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Textfield para la búsqueda de libros o autores.
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by Title or Author',
                prefixIcon: Icon(Icons.search, color: mainColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: mainColor, width: 2),
                ),
                border: const UnderlineInputBorder(),
              ),
            ),
            
            // Usamos Spacer para empujar el contenido.
            const Spacer(),
            
            // Icono de libro para decorar.
            Icon(
              Icons.library_add, 
              size: 80, 
              color: mainColor.withValues(alpha: 0.1)
            ),
            const SizedBox(height: 10),
            Text(
              'Results will appear here', 
              style: TextStyle(color: mainColor.withValues(alpha: 0.6))
            ),
            
           
            const Spacer(),
            
            // Interruptor con texto integrado para marcar como terminado
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Finished reading?', 
                style: TextStyle(color: mainColor, fontWeight: FontWeight.w500)
              ),
            // Color del círculo.
              activeThumbColor: mainColor, 
              value: _isFinished,
              // Al tocarlo, cambiamos el estado y la pantalla se actualiza (setState).
              onChanged: (val) => setState(() => _isFinished = val),
            ),
            
            const SizedBox(height: 16),

            // Botón estirado a todo lo ancho para añadir el libro.
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                // Navigator.pop vuelve a la pantalla anterior (Home).
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                ),
                child: const Text(
                  'Add Book to Library',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}