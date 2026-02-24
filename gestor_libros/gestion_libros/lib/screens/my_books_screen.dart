import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app_routes.dart';
import '../widgets/app_drawer.dart';

class MyBooksScreen extends StatelessWidget {
  const MyBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color mainColor = const Color(0xFFB73BB7);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library', 
          style: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold)
        ),
        foregroundColor: mainColor,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: user == null
          ? Center(
              child: Text(
                'Please log in to view your books',
                style: TextStyle(color: mainColor, fontSize: 16),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('books')
                  .where('userId', isEqualTo: user.uid)
                  .orderBy('addedAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                // Mientras carga
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: mainColor),
                  );
                }

                // Si hay error
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading books',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  );
                }

                // Si no hay libros
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.book_outlined, 
                          size: 80, 
                          color: mainColor.withValues(alpha: 0.3)
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No books yet',
                          style: TextStyle(
                            color: mainColor.withValues(alpha: 0.7),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap + to add your first book',
                          style: TextStyle(
                            color: mainColor.withValues(alpha: 0.5),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Si hay libros, mostrarlos
                final books = snapshot.data!.docs;

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index].data() as Map<String, dynamic>;
                    final String title = book['title'] ?? 'Unknown Title';
                    final String author = book['author'] ?? 'Unknown Author';
                    final String thumbnail = book['thumbnail'] ?? '';

                    return GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.bookDetails,
                        arguments: book,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Portada del libro
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: mainColor.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: mainColor.withValues(alpha: 0.1),
                                ),
                              ),
                              child: thumbnail.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        thumbnail,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Center(
                                            child: Icon(
                                              Icons.book_rounded,
                                              size: 50,
                                              color: mainColor.withValues(alpha: 0.3),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Center(
                                      child: Icon(
                                        Icons.book_rounded,
                                        size: 50,
                                        color: mainColor.withValues(alpha: 0.3),
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Información del libro
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            author,
                            style: TextStyle(
                              color: mainColor.withValues(alpha: 0.7),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addBook),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}