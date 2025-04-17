import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/home_screen.dart';
import '../screens/auth_screen.dart';

class AuthService {
  // Escuchar el estado de autenticación y redirigir
  Widget handleAuthState() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasData) {
          return const HomeScreen(); // Usuario autenticado
        } else {
          return const AuthScreen(); // Usuario no autenticado
        }
      },
    );
  }

  // Registro y guardar en Firestore
  Future<void> signUp(String email, String password) async {
    final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'email': email,
      'isOnline': false,
      'lastSeen': DateTime.now(),
    });
  }

  // Iniciar sesión
  Future<void> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Usuario no encontrado');
      } else if (e.code == 'wrong-password') {
        throw Exception('Contraseña incorrecta');
      } else {
        throw Exception('Error de autenticación: ${e.code}');
      }
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
