import 'package:flutter/material.dart';

class Ferramenta {
  final String nome;
  final String descricao;

  Ferramenta({required this.nome, required this.descricao});
}

// Lista de ferramentas e itens fornecidos pela empresa
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

class TelaFerramentas extends StatefulWidget {
  const TelaFerramentas({super.key});

  @override
  _TelaFerramentasState createState() => _TelaFerramentasState();
}

class _TelaFerramentasState extends State<TelaFerramentas> {
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
              itemCount: _filteredFerramentas().length,
              itemBuilder: (context, index) {
                final ferramenta = _filteredFerramentas()[index];
                return _buildToolCard(
                  title: ferramenta.nome,
                  description: ferramenta.descricao,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetalhesFerramenta(ferramenta: ferramenta),
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

  List<Ferramenta> _filteredFerramentas() {
    if (query.isEmpty) {
      return ferramentas;
    } else {
      return ferramentas
          .where((ferramenta) =>
              ferramenta.nome.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
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
