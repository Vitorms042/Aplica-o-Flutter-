import 'package:flutter/material.dart';

class Ferramenta {
  final String nome;
  final String descricao;

  Ferramenta({required this.nome, required this.descricao});
}

List<Ferramenta> ferramentas = [
  Ferramenta(
    nome: "Notebook Dell XPS",
    descricao: "Notebook potente para desenvolvimento e tarefas de escritório.",
  ),
  Ferramenta(
    nome: "Smartphone Samsung Galaxy S21",
    descricao: "Smartphone para comunicação interna e gestão de projetos.",
  ),
  Ferramenta(
    nome: "Mesa Ergonômica",
    descricao: "Mesa ajustável para maior conforto e produtividade.",
  ),
  Ferramenta(
    nome: "Licença do Microsoft Office 365",
    descricao: "Licença para ferramentas de produtividade como Word, Excel e PowerPoint.",
  ),
];

class TelaFerramentas extends StatelessWidget {
  const TelaFerramentas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ferramentas Disponíveis'),
      ),
      body: ListView.builder(
        itemCount: ferramentas.length,
        itemBuilder: (context, index) {
          final ferramenta = ferramentas[index];
          return _buildToolCard(
            title: ferramenta.nome,
            description: ferramenta.descricao,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalhesFerramenta(ferramenta: ferramenta),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildToolCard({
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.blue.withOpacity(0.2),
      highlightColor: Colors.blue.withOpacity(0.1),
      borderRadius: BorderRadius.circular(15.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 5.0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetalhesFerramenta extends StatelessWidget {
  final Ferramenta ferramenta;

  const DetalhesFerramenta({super.key, required this.ferramenta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ferramenta.nome),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ferramenta.nome,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              ferramenta.descricao,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
