import 'package:flutter/material.dart';

// Imports de la pantalla.
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/my_books_screen.dart';
import 'screens/book_details_screen.dart';
import 'screens/add_book_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/credits_screen.dart';
import 'screens/recommended_books_screen.dart';

class AppRoutes {
  // Nombres de las rutas.
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String myBooks = '/my-books';
  static const String bookDetails = '/book-details';
  static const String addBook = '/add-book';
  static const String settings = '/settings';
  static const String credits = '/credits';
  static const String recommended = '/recommended';

  // El mapa de las rutas. 
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      home: (context) => const HomeScreen(),
      myBooks: (context) => const MyBooksScreen(),
      bookDetails: (context) => const BookDetailsScreen(),
      addBook: (context) => const AddBookScreen(), 
      settings: (context) => const SettingsScreen(),
      credits: (context) => const CreditsScreen(),
      recommended: (context) => const RecommendedBooksScreen(),
    };
  }
}