import 'dart:convert';
import 'package:http/http.dart' as http;
import 'book_model.dart';

class GoogleBooksService {
  // API Key de Google Books
  static const String apiKey = 'AIzaSyC_q9uk3EbCmsbZAleJLoFha1TAWlXQFcU';

  Future<List<BookModel>> searchBooks(String query) async {
    if (query.isEmpty) return [];

    // URL de Google Books con API Key
    final url = Uri.https('www.googleapis.com', '/books/v1/volumes', {
      'q': query.trim(),
      'maxResults': '15',
      'key': apiKey,
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List items = data['items'] ?? [];
        return items.map((item) => BookModel.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}