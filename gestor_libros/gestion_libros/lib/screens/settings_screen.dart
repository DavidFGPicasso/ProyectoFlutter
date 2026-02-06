import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Variable para controlar si el modo oscuro está activo o no.
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final Color mainColor = const Color(0xFFB73BB7);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold)),
        foregroundColor: mainColor,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // ListView.
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          const SizedBox(height: 20),
          
          // Perfil.
          CircleAvatar(
            radius: 40,
            backgroundColor: mainColor.withValues(alpha: 0.1),
            child: Icon(Icons.person, size: 45, color: mainColor),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text('Hello, Reader', 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Modo Oscuro.
          SwitchListTile(
            // El icono cambia dinámicamente según el valor de _isDarkMode
            secondary: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode, color: mainColor),
            title: const Text('Dark Mode'),
            activeThumbColor: mainColor, // Color del interruptor cuando está encendido
            value: _isDarkMode,
            // Al tocarlo, setState redibuja la pantalla con el nuevo valor.
            onChanged: (val) => setState(() => _isDarkMode = val),
          ),
          
          // Una línea fina para separar secciones
          const Divider(height: 32),
          
          // Creamos las filas de abajo.
          _buildSettingTile(Icons.account_circle, 'Account', 'Email and password', mainColor),
          _buildSettingTile(Icons.notifications, 'Reading reminders', 'Manage notifications', mainColor),
          _buildSettingTile(Icons.help_outline, 'Support', 'Contact and FAQ', mainColor),
        ],
      ),
    );
  }

  // Función para crear las filas.
  Widget _buildSettingTile(IconData icon, String title, String subtitle, Color color) {
    return ListTile(
      contentPadding: EdgeInsets.zero, 
      leading: Icon(icon, color: color), // Icono a la izquierda
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 13)),
      trailing: const Icon(Icons.chevron_right, size: 20), 
      onTap: () {
      },
    );
  }
}