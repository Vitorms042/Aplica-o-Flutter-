import 'package:flutter/material.dart';

class Evento {
  final String nome;
  final String data;
  final String descricao;

  Evento({required this.nome, required this.data, required this.descricao});
}

List<Evento> eventos = [
  Evento(
    nome: "Lançamento de Produto",
    data: "12 de Outubro de 2024",
    descricao: "Lançamento de nosso novo produto inovador.",
  ),
  Evento(
    nome: "Conferência Anual",
    data: "25 de Outubro de 2024",
    descricao: "Conferência sobre tendências de mercado.",
  ),
  Evento(
    nome: "Treinamento Interno",
    data: "5 de Novembro de 2024",
    descricao: "Treinamento de equipes internas para novas tecnologias.",
  ),
];

class TelaEventos extends StatelessWidget {
  const TelaEventos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Próximos Eventos'),
      ),
      body: ListView.builder(
        itemCount: eventos.length,
        itemBuilder: (context, index) {
          final evento = eventos[index];
          return _buildEventCard(
            date: evento.data,
            title: evento.nome,
            description: evento.descricao,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalhesEvento(evento: evento),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEventCard({
    required String date,
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
        height: 130,
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
                date,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
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

class DetalhesEvento extends StatelessWidget {
  final Evento evento;

  const DetalhesEvento({super.key, required this.evento});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(evento.nome),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              evento.data,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              evento.descricao,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
