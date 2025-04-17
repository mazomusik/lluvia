import 'dart:async';
import 'package:flutter/material.dart';

class EmitterService {
  static Future<void> start(BuildContext context) async {

    // Aquí irá lógica de captura automática y subida a Firebase Storage
    // Por ahora solo muestra un mensaje simulado

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Modo emisor activado (simulado)')),
    );
  }
}
