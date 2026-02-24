import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/google_books_service.dart';
import '../model/book_model.dart';
import '../widgets/app_drawer.dart';

// Pantalla de libros recomendados por categoría
class RecommendedBooksScreen extends StatefulWidget {
  const RecommendedBooksScreen({super.key});

  @override
  State<RecommendedBooksScreen> createState() => _RecommendedBooksScreenState();
}

class _RecommendedBooksScreenState extends State<RecommendedBooksScreen> {
  // Color principal de la aplicación
  final Color mainColor = const Color(0xFFB73BB7);
  
  // Servicio para consultar la API de Google Books
  final GoogleBooksService _booksService = GoogleBooksService();
  
  // Lista de libros recomendados
  List<BookModel> _recommendedBooks = [];
  
  // Indicador de carga
  bool _isLoading = false;
  
  // Categoría seleccionada actualmente
  String _selectedCategory = 'Science';
  
  // Mapa de categorías con sus consultas de búsqueda
  final Map<String, String> _categoryQueries = {
    'Science': 'subject:science',
    'Story': 'subject:fiction',
    'Fantasy': 'subject:fantasy',
    'History': 'subject:history',
  };

  @override
  void initState() {
    super.initState();
    // Cargamos libros de la categoría por defecto al iniciar
    _loadBooksByCategory(_selectedCategory);
  }

  // Método para cargar libros según la categoría seleccionada
  Future<void> _loadBooksByCategory(String category) async {
    // Activamos el indicador de carga
    setState(() {
      _isLoading = true;
      _selectedCategory = category;
    });

    try {
      // Obtenemos la consulta correspondiente a la categoría
      final query = _categoryQueries[category] ?? category;
      
      // Buscamos libros usando el servicio de Google Books
      final books = await _booksService.searchBooks(query);
      
      // Actualizamos la lista de libros y desactivamos la carga
      setState(() {
        _recommendedBooks = books;
        _isLoading = false;
      });
    } catch (e) {
      // Si hay un error, desactivamos la carga
      setState(() {
        _isLoading = false;
      });
      
      // Mostramos mensaje de error al usuario
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading books: $e')),
        );
      }
    }
  }

  // Método para añadir un libro a la biblioteca del usuario
  Future<void> _addBookToLibrary(BookModel book) async {
    // Obtenemos el usuario actual
    final user = FirebaseAuth.instance.currentUser;
    
    // Si no hay usuario logueado, mostramos mensaje
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login first')),
      );
      return;
    }

    try {
      // Guardamos el libro en Firestore vinculado al usuario
      await FirebaseFirestore.instance.collection('books').add({
        'userId': user.uid,
        'title': book.title,
        'author': book.authors.join(', '),
        'thumbnail': book.thumbnailUrl,
        'description': book.description,
        'isFinished': false,
        'addedAt': FieldValue.serverTimestamp(),
      });

      // Mostramos mensaje de éxito
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${book.title} added to your library!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Mostramos mensaje de error si falla
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding book: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior
      appBar: AppBar(
        title: const Text('Recommended', 
          style: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold)
        ),
        foregroundColor: mainColor,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      
      // Menú lateral
      drawer: const AppDrawer(),
      
      body: Column(
        children: [
          // Barra horizontal de categorías
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _categoryQueries.keys
                  .map((cat) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        // Chip de categoría
                        child: ActionChip(
                          label: Text(cat),
                          labelStyle: TextStyle(
                            // Color blanco si está seleccionada, morado si no
                            color: _selectedCategory == cat ? Colors.white : mainColor,
                            fontWeight: FontWeight.bold,
                          ),
                          side: BorderSide(color: mainColor.withValues(alpha: 0.2)),
                          // Fondo morado si está seleccionada
                          backgroundColor: _selectedCategory == cat
                              ? mainColor
                              : mainColor.withValues(alpha: 0.05),
                          onPressed: () => _loadBooksByCategory(cat),
                        ),
                      ))
                  .toList(), 
            ),
          ),

          // Grid de libros recomendados
          Expanded(
            child: _isLoading
                // Mostramos indicador de carga
                ? Center(child: CircularProgressIndicator(color: mainColor))
                : _recommendedBooks.isEmpty
                    // Mensaje si no hay libros
                    ? const Center(
                        child: Text('No books found'),
                      )
                    // Grid con los libros
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        // Configuración del grid: 2 columnas
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, 
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.58,
                        ),
                        itemCount: _recommendedBooks.length,
                        itemBuilder: (context, index) {
                          final book = _recommendedBooks[index];
                          
                          // Tarjeta de libro
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            clipBehavior: Clip.antiAlias,
                            // LayoutBuilder para calcular dimensiones dinámicamente
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Portada del libro (62% de la altura)
                                    SizedBox(
                                      height: constraints.maxHeight * 0.62,
                                      child: book.thumbnailUrl.isNotEmpty
                                          // Cargamos la imagen desde internet
                                          ? Image.network(
                                              book.thumbnailUrl,
                                              fit: BoxFit.cover,
                                              // Icono de respaldo si falla la carga
                                              errorBuilder: (_, __, ___) => Container(
                                                color: mainColor.withValues(alpha: 0.1),
                                                child: Icon(Icons.book, 
                                                  size: 40, 
                                                  color: mainColor.withValues(alpha: 0.4),
                                                ),
                                              ),
                                            )
                                          // Icono si no hay imagen
                                          : Container(
                                              color: mainColor.withValues(alpha: 0.1),
                                              child: Icon(Icons.book, 
                                                size: 40, 
                                                color: mainColor.withValues(alpha: 0.4),
                                              ),
                                            ),
                                    ),
                                    
                                    // Información del libro (38% de la altura)
                                    Container(
                                      height: constraints.maxHeight * 0.38,
                                      padding: const EdgeInsets.all(6.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Título del libro
                                          Flexible(
                                            child: Text(
                                              book.title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                                height: 1.1,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          
                                          // Autor del libro
                                          Text(
                                            book.authors.join(', '),
                                            style: TextStyle(
                                              fontSize: 8.5,
                                              color: Colors.grey[600],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const Spacer(),
                                          
                                          // Botón para añadir a la biblioteca
                                          SizedBox(
                                            width: double.infinity,
                                            height: 26,
                                            child: ElevatedButton.icon(
                                              onPressed: () => _addBookToLibrary(book),
                                              icon: const Icon(Icons.add, size: 12),
                                              label: const Text('Add', 
                                                style: TextStyle(fontSize: 9),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: mainColor,
                                                foregroundColor: Colors.white,
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 0,
                                                  horizontal: 6,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      
      // Botón flotante para recargar la categoría actual
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        onPressed: () => _loadBooksByCategory(_selectedCategory),
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}