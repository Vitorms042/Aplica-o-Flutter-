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

class TelaEventos extends StatefulWidget {
  const TelaEventos({super.key});

  @override
  _TelaEventosState createState() => _TelaEventosState();
}

class _TelaEventosState extends State<TelaEventos> {
  String query = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildSearchHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredEventos().length,
              itemBuilder: (context, index) {
                final evento = _filteredEventos()[index];
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
          ),
          buildFooter(), // Adicionando o footer
        ],
      ),
    );
  }

  List<Evento> _filteredEventos() {
    if (query.isEmpty) {
      return eventos;
    } else {
      return eventos
          .where((evento) =>
              evento.nome.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
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

  Widget buildSearchHeader() {
    return Stack(
      children: [
        Container(
          height: 220,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://servicedesk.sydle.com/assets/657712578dbad47ce9753c5a/65b004207e928d0872e772f8'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Portal de Relacionamento',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Tire suas dúvidas agora mesmo!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Buscar',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  onChanged: (query) {
                    setState(() {
                      this.query = query;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildFooter() {
    return Container(
      color: Colors.black,
      height: 60,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Powered by ',
              style: TextStyle(color: Colors.white),
            ),
            Image.network(
              'https://servicedesk.sydle.com/logo',
              height: 30.0, // Ajuste a altura do logo conforme necessário
              width: 30.0,  // Ajuste a largura do logo conforme necessário
            ),
          ],
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
