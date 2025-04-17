import 'package:flutter/material.dart';
import 'package:lluvia/features/receiver/receiver_page.dart';
import 'package:android_intent_plus/android_intent.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  void abrirConfiguracionAccesibilidad() {
    final intent = AndroidIntent(
      action: 'android.settings.ACCESSIBILITY_SETTINGS',
    );
    intent.launch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modo Administrador')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                abrirConfiguracionAccesibilidad();
              },
              child: const Text('Activar modo EMISOR'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReceiverPage()),
                );
              },
              child: const Text('Ver como RECEPTOR'),
            ),
          ],
        ),
      ),
    );
  }
}
