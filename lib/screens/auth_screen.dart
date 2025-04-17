import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLogin = true;
  bool isLoading = false;

  void toggleForm() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  Future<void> submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final auth = AuthService();
    final messenger = ScaffoldMessenger.of(context);

    if (email.isEmpty || password.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text("Todos los campos son obligatorios")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      if (isLogin) {
        await auth.signIn(email, password);
      } else {
        await auth.signUp(email, password);
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _resetPassword(BuildContext context) async {
    final email = _emailController.text.trim();
    final messenger = ScaffoldMessenger.of(context);

    if (email.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text("Ingresa tu correo para restablecer la contraseña")),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      messenger.showSnackBar(
        const SnackBar(content: Text("Correo de recuperación enviado")),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? "Iniciar sesión" : "Registrarse")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: submit,
              child: Text(isLogin ? "Iniciar sesión" : "Registrarse"),
            ),
            TextButton(
              onPressed: toggleForm,
              child: Text(isLogin
                  ? "¿No tienes cuenta? Regístrate"
                  : "¿Ya tienes cuenta? Inicia sesión"),
            ),
            if (isLogin)
              TextButton(
                onPressed: () => _resetPassword(context),
                child: const Text("¿Olvidaste tu contraseña?"),
              ),
          ],
        ),
      ),
    );
  }
}
