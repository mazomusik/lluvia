import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.account_circle, size: 100),
            const SizedBox(height: 20),
            Text("UID: ${user?.uid ?? 'No disponible'}"),
            const SizedBox(height: 8),
            Text("Email: ${user?.email ?? 'No disponible'}"),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () async {
                await AuthService().signOut();
              },
              icon: const Icon(Icons.logout),
              label: const Text("Cerrar sesión"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            )
          ],
        ),
      ),
    );
  }
}
