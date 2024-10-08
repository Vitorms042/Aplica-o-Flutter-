import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final String nome = ModalRoute.of(context)?.settings.arguments as String? ?? 'Visitante';

    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo(a), $nome'),
      ),
      body: Center(
        child: Text(
          'Olá, $nome! Bem-vindo(a) à sua página.',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
