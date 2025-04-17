import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'core/device_id.dart'; // 👈 Agregado para identificar el dispositivo
import 'services/auth_service.dart';
import 'screens/chat_test_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await DeviceIdService.init(); // 👈 Inicializa y guarda el ID único del dispositivo
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'lluvia',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuthService().handleAuthState(),
      routes: {
        '/chat-test': (context) => const ChatTestScreen(),
        // Si agregas más rutas (como el panel admin), las pones aquí
      },
    );
  }
}
