import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    const Color mainColor = Color(0xFFB73BB7);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: mainColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/logo.png', height: 60),
                const SizedBox(height: 10),
                const Text(
                  'LIBRIDEX',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.library_books, color: mainColor),
            title: const Text('My Library'),
            onTap: () {
              // Cierra el drawer
              Navigator.pop(context); 
              Navigator.pushReplacementNamed(context, AppRoutes.myBooks);
            },
          ),
          ListTile(
            leading: const Icon(Icons.star, color: mainColor),
            title: const Text('Recommended'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRoutes.recommended);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: mainColor),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRoutes.settings);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info, color: mainColor),
            title: const Text('Credits'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.credits);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              }
            },
          ),
        ],
      ),
    );
  }
}
