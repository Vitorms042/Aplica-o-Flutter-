import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portal de Relacionamento',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portal de Relacionamento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black87,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.account_circle, size: 100, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Bem-vindo!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Início'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Perfil'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'Catálogos',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildCatalogItem(
                    icon: Icons.info,
                    title: 'Sobre o Portal',
                    subtitle: 'Entenda como funciona o Portal da SYDLE e como ter acesso às informações.',
                  ),
                  _buildCatalogItem(
                    icon: Icons.build,
                    title: 'Serviços',
                    subtitle: 'Solucione rapidamente as suas demandas com os nossos serviços.',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ServicesPage(),
                        ),
                      );
                    },
                  ),
                  _buildCatalogItem(
                    icon: Icons.cloud,
                    title: 'SYDLE ONE',
                    subtitle: 'Acesse a documentação do SYDLE ONE e entenda como explorar todos os seus recursos.',
                  ),
                  _buildCatalogItem(
                    icon: Icons.shopping_bag,
                    title: 'Produtos',
                    subtitle: 'Saiba mais sobre as soluções já existentes e documentadas agora mesmo.',
                  ),
                  _buildCatalogItem(
                    icon: Icons.event,
                    title: 'Próximos Eventos',
                    subtitle: 'Acesse e inscreva-se nos próximos eventos disponíveis para você.',
                  ),
                  _buildCatalogItem(
                    icon: Icons.school,
                    title: 'Universidade SYDLE',
                    subtitle: 'Programa de formação e treinamento de profissionais.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_page),
            label: 'Contatos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 80, 82, 84),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        onTap: (index) {
          if (index == 1) {
            _showContacts(context);
          } else if (index == 2) {
            _showSettings(context);
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://source.unsplash.com/random/800x600'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Portal de Relacionamento',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(0.7),
              hintText: 'Buscar...',
              prefixIcon: const Icon(Icons.search, color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatalogItem({
    required IconData icon,
    required String title,
    required String subtitle,
    void Function()? onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.blue),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }

  void _showContacts(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Contatos'),
          content: const Text('Lista de contatos disponíveis.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Configurações'),
          content: const Text('Opções de configuração do aplicativo.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Serviços'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Pesquisar...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Classificar por',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Padrão', child: Text('Padrão')),
                DropdownMenuItem(value: 'A-Z', child: Text('A-Z')),
                DropdownMenuItem(value: 'Z-A', child: Text('Z-A')),
              ],
              onChanged: (value) {},
              value: 'Padrão',
            ),
            const SizedBox(height: 20),
            _buildServiceItem(
              icon: Icons.handshake,
              title: 'Comercial',
              subtitle: 'Entre em contato direto com o nosso Comercial sempre que precisar de algum apoio.',
            ),
            _buildServiceItem(
              icon: Icons.support_agent,
              title: 'Suporte',
              subtitle: 'Abra um chamado para o suporte da SYDLE e solucione sua demanda.',
            ),
            _buildServiceItem(
              icon: Icons.lightbulb,
              title: 'Sugestão de Conteúdo',
              subtitle: 'Sugira um conteúdo para ser desenvolvido e publicado nas mídias da SYDLE.',
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(10.0),
        child: const Text(
          'Powered by SYDLE',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildServiceItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.blue),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}