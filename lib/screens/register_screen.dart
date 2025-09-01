import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final api = ApiService();
  String message = "";

  void register() async {
    try {
      final res = await api.register(
        nameController.text,
        emailController.text,
        passwordController.text,
        confirmController.text,
      );
      setState(() => message = "Compte créé : ${res['user']['email']}");
    } catch (e) {
      setState(() => message = "Erreur d'inscription : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscription")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nom")),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: "Mot de passe"), obscureText: true),
            TextField(controller: confirmController, decoration: const InputDecoration(labelText: "Confirmer mot de passe"), obscureText: true),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: register, child: const Text("S'inscrire")),
            const SizedBox(height: 16),
            Text(message, style: const TextStyle(color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
