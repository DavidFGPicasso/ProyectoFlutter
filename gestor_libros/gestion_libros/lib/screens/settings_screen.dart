import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el acceso al provider del tema
    final themeProvider = Provider.of<ThemeProvider>(context);
    final Color mainColor = const Color(0xFFB73BB7);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold),
        ),
        foregroundColor: mainColor,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          const SizedBox(height: 20),

          // Perfil de usuario
          CircleAvatar(
            radius: 40,
            backgroundColor: mainColor.withValues(alpha: 0.1),
            child: Icon(Icons.person, size: 45, color: mainColor),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Hello, Reader',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 40),

          // Selector de Modo Oscuro conectado al Provider
          SwitchListTile(
            secondary: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: mainColor,
            ),
            title: const Text('Dark Mode'),
            activeThumbColor: mainColor,
            value: themeProvider.isDarkMode,
            // Aquí notificamos al Provider del cambio global.
            onChanged: (val) {
              themeProvider.toggleTheme(val);
            },
          ),

          const Divider(height: 32),

          // Opciones de configuración adicionales
          _buildSettingTile(
            Icons.account_circle,
            'Account',
            'Email and password',
            mainColor,
            () {
              
            },
          ),
          _buildSettingTile(
            Icons.notifications,
            'Reading reminders',
            'Manage notifications',
            mainColor,
            () {
              
            },
          ),
          _buildSettingTile(
            Icons.help_outline,
            'Support',
            'Contact and FAQ',
            mainColor,
            () {
              
            },
          ),
          
          const SizedBox(height: 20),
          
          // Botón de Logout opcional
          TextButton.icon(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            label: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  // Función  para crear las filas con soporte para navegación.
  Widget _buildSettingTile(
      IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 13),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}