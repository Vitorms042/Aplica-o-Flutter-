import 'package:flutter/material.dart';
import 'package:projeto_flutter01/serviceRh.dart';
import 'package:projeto_flutter01/signupPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Página Inicial | Portal de Relacionamento',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/services',
      routes: {
        '/': (context) => const ServicePage(),
        '/signup': (context) => const SignupPage(),
        '/servicesRH': (context) => RHScreen(),
      },
    );
  }
}

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ServicePage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  OverlayEntry? _notificationOverlayEntry;

  OverlayEntry _createNotificationOverlay(BuildContext context) {
    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                _closeNotificationOverlay();
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
            Positioned(
              top: 80.0,
              right: 20.0,
              child: Material(
                elevation: 8.0,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  width: 250.0,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notificações',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Divider(),
                      Text('Nenhuma notificação encontrada.'),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showNotificationOverlay() {
    _notificationOverlayEntry = _createNotificationOverlay(context);
    Overlay.of(context).insert(_notificationOverlayEntry!);
  }

  void _closeNotificationOverlay() {
    _notificationOverlayEntry?.remove();
    _notificationOverlayEntry = null;
  }

  Future<void> _showLoginDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Autenticação'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: SizedBox(
            height: 160,
            width: 350.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _loginController,
                  decoration: const InputDecoration(
                    labelText: 'Login',
                    prefixIcon: Icon(Icons.person),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _PasswordField(controller: _passwordController),
              ],
            ),
          ),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _login(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 32, 104, 199),
                  ),
                  child: const Text(
                    "Entrar",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    side: const BorderSide(color: Colors.grey, width: 0.3),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    textStyle: const TextStyle(fontSize: 15),
                  ),
                  child: const Text(
                    'Esqueceu sua senha?',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/signup');
                  },
                  style: TextButton.styleFrom(
                    side: const BorderSide(color: Colors.grey, width: 0.3),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    textStyle: const TextStyle(fontSize: 15),
                  ),
                  child: const Text(
                    'Crie Sua Conta',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _login(BuildContext context) {
    final login = _loginController.text.trim();
    final password = _passwordController.text.trim();

    if (login.isEmpty || password.isEmpty) {
      _showErrorDialog(context, 'Erro', 'Por favor, preencha todos os campos.');
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _showErrorDialog(
      BuildContext context, String title, String message) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Align(
        alignment: Alignment.centerLeft,
        child: Image.network(
          'https://servicedesk.sydle.com/logo',
          height: 100.0,
          width: 100.0,
        ),
      ),
      backgroundColor: Colors.black,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          color: Colors.white,
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          color: Colors.white,
          onPressed: () {
            if (_notificationOverlayEntry == null) {
              _showNotificationOverlay();
            } else {
              _closeNotificationOverlay();
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: ElevatedButton(
            onPressed: () {
              _showLoginDialog(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 32, 104, 199),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Entrar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    ),
    drawer: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Image.network(
              'https://servicedesk.sydle.com/logo',
              height: 10.0,
              width: 10.0,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Ajuda'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.only(bottom: 60.0), // Adicionei um padding no final do conteúdo
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildSearchHeader(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Serviços',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCard(
                    icon: Icons.work,
                    title: 'Gestão de Projetos Internos',
                    description: 'Centralize e acompanhe o progresso de todos os projetos da empresa, garantindo prazos e metas claras para a equipe.',
                    context: context,
                  ),
                  _buildCard(
                    icon: Icons.schedule,
                    title: 'Controle de Ponto e Jornada de Trabalho',
                    description: 'Solução digital para registro de ponto, acompanhamento de horas trabalhadas e gestão de banco de horas.',
                    context: context,
                  ),
                  _buildCard(
                    icon: Icons.paid,
                    title: 'Sistema de Reembolso de Despesas',
                    description: 'Facilite o envio, aprovação e controle de reembolsos de despesas, tornando o processo rápido e transparente.',
                    context: context,
                  ),
                  _buildCard(
                    icon: Icons.flight_takeoff,
                    title: 'Gestão de Benefícios e Férias',
                    description: 'Acompanhamento de benefícios, férias e licenças, garantindo transparência e organização para os funcionários.',
                    context: context,
                  ),
                  _buildCard(
                    icon: Icons.people,
                    title: 'Gestão de Recursos Humanos',
                    description: 'Organize e acompanhe todos os processos de RH, incluindo contratações, avaliações e treinamentos de equipe.',
                    context: context,
                  ),
                  _buildCard(
                    icon: Icons.task_alt,
                    title: 'Gestão de Tarefas e Produtividade',
                    description: 'Organize tarefas e acompanhe o progresso para garantir o cumprimento de metas e prazos.',
                    context: context,
                  ),
                  _buildCard(
                    icon: Icons.inventory,
                    title: 'Gestão de Estoque e Inventário',
                    description: 'Acompanhe o inventário, controle entradas e saídas de produtos e evite rupturas de estoque.',
                    context: context,
                  ),
                  _buildCard(
                    icon: Icons.support_agent,
                    title: 'Suporte ao Cliente e Feedback',
                    description: 'Gerencie solicitações de clientes e colete feedback para melhorar a experiência e satisfação.',
                    context: context,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,  // Alinha o botão à direita
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, right: 10.0),  // Baixa e ajusta o botão um pouco
                      child: OutlinedButton(
                        onPressed: () {
                          // Ação ao clicar no botão "VER MAIS"
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black, width: 2), // Borda preta
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), // Ajuste de padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Bordas arredondadas
                          ),
                          foregroundColor: Colors.black, // Cor do texto e do ícone
                          backgroundColor: Colors.white, // Cor de fundo
                          shadowColor: Colors.black.withOpacity(0.1),
                          elevation: 4, // Sombra para dar profundidade
                        ),
                        child: const Text(
                          'VER MAIS',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600, // Texto em negrito
                            letterSpacing: 1.2, // Espaçamento entre letras
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    bottomSheet: Container(
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
              height: 100.0,
              width: 100.0,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildCard({
  required IconData icon,
  required String title,
  required String description,
  required BuildContext context,
}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0), // Borda arredondada
    ),
    color: Colors.white,
    elevation: 6.0,
    shadowColor: Colors.grey.withOpacity(0.4), // Sombra sutil
    margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 30, color: Colors.blue),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            description,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        title: Text(
                          title,
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: const Text("Mais detalhes sobre o serviço."),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              "Fechar",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text("Saiba mais"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: () {
                    // Ação do botão "Acessar serviço"
                  },
                  child: const Text("Acessar serviço"),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget buildSearchHeader() {
  return Stack(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Nossos Serviços',
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Center(
            child: Text(
              'As melhores soluções para as suas necessidades',
              style: TextStyle(
                color: Colors.black54, // Cor cinza suave para o texto secundário
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100, // Fundo sutil para o campo de pesquisa
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black.withOpacity(0.2), // Borda com opacidade reduzida
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 3), // Sombra leve abaixo
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Pesquisar serviço',
                  hintStyle: TextStyle(color: Colors.black54),
                  prefixIcon: Icon(Icons.search, color: Colors.black54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

}

class _PasswordField extends StatefulWidget {
  const _PasswordField({
    required this.controller,
  });

  final TextEditingController controller;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Senha',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}