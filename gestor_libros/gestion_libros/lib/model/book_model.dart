// Clase con el modelo que representa el libro.
class BookModel {
  final String id;
  final String title;
  final List<String> authors;
  final String thumbnailUrl;
  final String description;

  BookModel({
    required this.id,
    required this.title,
    required this.authors,
    required this.thumbnailUrl,
    required this.description,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final info = json['volumeInfo'];
    
    // Limpieza de la URL de la imagen.
    String image = info['imageLinks']?['thumbnail'] ?? '';
    if (image.startsWith('http:')) {
      image = image.replaceFirst('http:', 'https:');
    }

    return BookModel(
      id: json['id'],
      title: info['title'] ?? 'Sin título',
      authors: List<String>.from(info['authors'] ?? ['Autor desconocido']),
      thumbnailUrl: image,
      description: info['description'] ?? 'No hay descripción disponible.',
    );
  }
}