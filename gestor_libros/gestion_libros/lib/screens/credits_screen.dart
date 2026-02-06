import 'package:flutter/material.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos el color principal.
    final Color mainColor = const Color(0xFFB73BB7);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About LibriDex', style: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold)),
        foregroundColor: mainColor, 
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Logo.
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: mainColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.auto_stories, size: 80, color: mainColor),
            ),
            const SizedBox(height: 32),
            
          // Datos de la app.
            _buildCreditTile(mainColor, Icons.info_outline, 'Version', '1.0.0 (Stable)'),
            _buildCreditTile(mainColor, Icons.code, 'Developed by', 'LibriDex Team'),
            _buildCreditTile(mainColor, Icons.favorite_border, 'Special Thanks', 'To the Flutter Community'),
            
            const SizedBox(height: 50),
            
            // Creditos de la app.
            Text(
              '© 2026 LibriDex Project',
              style: TextStyle(
                color: mainColor.withValues(alpha: 0.5), 
                fontSize: 12, 
                letterSpacing: 1.1
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Creamos esta función para que cada línea de crédito tenga el mismo estilo
  Widget _buildCreditTile(Color color, IconData icon, String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
              Text(content, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}