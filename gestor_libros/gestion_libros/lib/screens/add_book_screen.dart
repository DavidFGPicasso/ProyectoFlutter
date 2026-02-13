import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


// Modelo de los libros.
class BookModel {
  final String title;
  final String authors;
  final String thumbnail;

  BookModel({required this.title, required this.authors, required this.thumbnail});

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final info = json['volumeInfo'];
    String img = info['imageLinks']?['thumbnail'] ?? '';
    // forzamos el https.
    if (img.startsWith('http:')) {
      img = img.replaceFirst('http:', 'https:');
    }
    return BookModel(
      title: info['title'] ?? 'Sin título',
      authors: (info['authors'] as List?)?.join(', ') ?? 'Autor desconocido',
      thumbnail: img,
    );
  }
}

// Pantalla AddBook.
class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _searchController = TextEditingController();
  bool _isFinished = false;
  bool _isLoading = false;
  List<BookModel> _searchResults = [];
   // Aquí guardamos el libro que el usuario toca
  BookModel? _selectedBook;

  final Color mainColor = const Color(0xFFB73BB7);

  // 1. Buscamos en Google Books API
  Future<void> _searchBooks(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      // Reiniciamos  al buscar algo nuevo.
      _selectedBook = null; 
    });

    final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query&maxResults=10');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List items = data['items'] ?? [];
        setState(() {
          _searchResults = items.map((i) => BookModel.fromJson(i)).toList();
        });
      }
    } catch (e) {
      _showSnackBar('Error de conexión con Google Books');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Guardamos el libro en fireStore.
  Future<void> _saveBookToFirebase() async {
    if (_selectedBook == null) {
      _showSnackBar('Por favor, selecciona un libro de la lista');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showSnackBar('Error: Usuario no identificado');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('books').add({
        // Vinculamos el libro al usuario.
        'userId': user.uid, 
        'title': _selectedBook!.title,
        'author': _selectedBook!.authors,
        'thumbnail': _selectedBook!.thumbnail,
        'isFinished': _isFinished,
        // Fecha exacta del servidor
        'addedAt': FieldValue.serverTimestamp(), 
      });

      if (mounted) {
        _showSnackBar('¡Libro añadido a tu biblioteca!');
        // Volvemos al Home.
        Navigator.pop(context); 
      }
    } catch (e) {
      _showSnackBar('Error al guardar en la base de datos');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  // Snackbar para mostrar mensajes.
  void _showSnackBar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Book', style: TextStyle(fontWeight: FontWeight.bold)),
        foregroundColor: mainColor,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Buscador.
            TextField(
              controller: _searchController,
              onSubmitted: (value) => _searchBooks(value),
              decoration: InputDecoration(
                hintText: 'Search by Title or Author',
                prefixIcon: Icon(Icons.search, color: mainColor),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: mainColor),
                  onPressed: () => _searchBooks(_searchController.text),
                ),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: mainColor, width: 2)),
              ),
            ),
            
            const SizedBox(height: 10),

            // Lista con los resultados.
            Expanded(
              child: _isLoading && _searchResults.isEmpty
                  ? Center(child: CircularProgressIndicator(color: mainColor))
                  : _searchResults.isEmpty
                      ? Center(child: Text('Results will appear here', style: TextStyle(color: mainColor.withValues(alpha: 0.5))))
                      : ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final book = _searchResults[index];
                            final bool isSelected = _selectedBook == book;

                            return Card(
                              elevation: isSelected ? 4 : 0,
                              color: isSelected ? mainColor.withValues(alpha: 0.15) : Colors.grey.shade50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: isSelected ? mainColor : Colors.transparent),
                              ),
                              child: ListTile(
                                leading: book.thumbnail.isNotEmpty
                                    ? Image.network(book.thumbnail, width: 40, fit: BoxFit.cover)
                                    : Icon(Icons.book, color: mainColor),
                                title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(book.authors),
                                trailing: isSelected ? Icon(Icons.check_circle, color: mainColor) : null,
                                onTap: () => setState(() => _selectedBook = book),
                              ),
                            );
                          },
                        ),
            ),

            const Divider(),

            // Botón de marcar como leído.
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Finished reading?', style: TextStyle(color: mainColor, fontWeight: FontWeight.w500)),
              activeThumbColor: mainColor,
              value: _isFinished,
              onChanged: (val) => setState(() => _isFinished = val),
            ),

            const SizedBox(height: 16),

            // Botón para guardar.
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: (_isLoading || _selectedBook == null) ? null : _saveBookToFirebase,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: _isLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Add Book to Library', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}