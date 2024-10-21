import 'package:flutter/material.dart';
import 'package:projeto_flutter01/eventos.dart';
import 'package:projeto_flutter01/ferramentas.dart';
import 'package:projeto_flutter01/perfilFuncionarios.dart';
import 'package:projeto_flutter01/servicosDisponiveis.dart';
import 'package:projeto_flutter01/signupPage.dart';
import 'package:projeto_flutter01/AuthProvider.dart';
import 'package:provider/provider.dart'; 

void main() {
  runApp(
     MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
     ),
     );
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
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/signup': (context) => const SignupPage(),
        '/services': (context) => const ServicePage(),
        '/perfil': (context) => const perfilFuncionario(),
        '/ferramentas': (context) => const TelaFerramentas(),
        '/eventos': (context) => const TelaEventos(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _errorMessage;
  bool _isLoggedIn = false;
  OverlayEntry? _notificationOverlayEntry;

  @override
  void initState() {
    super.initState();
    filteredCatalogItems = List.from(originalCatalogItems);
  }

  List<Map<String, dynamic>> originalCatalogItems = [
    {
      'title': 'Sobre o Portal',
      'subtitle': 'Entenda como funciona o Portal da SYDLE.',
      'icon': Icons.info,
      'route': '/',
    },
    {
      'title': 'Serviços',
      'subtitle': 'Soluções para suas demandas com nossos serviços.',
      'icon': Icons.build,
      'route': '/services',
    },
    {
      'title': 'Próximos Eventos',
      'subtitle': 'Acesse e inscreva-se nos próximos eventos.',
      'icon': Icons.event,
      'route': '/eventos',
    },
    {
      'title': 'Reservar Itens',
      'subtitle': 'Reserve salas, materiais, máquinas, e outros utilitários.',
      'icon': Icons.storage,
      'route': '/ferramentas',
    },
  ];

  List<Map<String, dynamic>> filteredCatalogItems = [];

  void _filterCatalogItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCatalogItems = List.from(originalCatalogItems);
      } else {
        List<String> searchTerms = query.toLowerCase().split(' ');

        filteredCatalogItems = originalCatalogItems.where((item) {
          final title = item['title']!.toLowerCase();
          final subtitle = item['subtitle']!.toLowerCase();

          query.toLowerCase();

          return searchTerms
              .every((term) => title.contains(term) || subtitle.contains(term));
        }).toList();
      }
    });
  }

  void _checkLogin(BuildContext context) {
    if (!_isLoggedIn) {
      _showLoginDialog(context);
    } else {
      _showProfilePage(context);
    }
  }

  void _showProfilePage(BuildContext context) {
     Navigator.pushNamed(context, '/perfil');
  }

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
    Overlay.of(context)?.insert(_notificationOverlayEntry!);
  }

  void _closeNotificationOverlay() {
    _notificationOverlayEntry?.remove();
    _notificationOverlayEntry = null;
  }

  Future<void> _showLoginDialog(BuildContext context) async {
    setState(() {
      _errorMessage = null;
    });

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
                  decoration: InputDecoration(
                    labelText: 'Login',
                    errorText:
                        _loginController.text.isEmpty && _errorMessage != null
                            ? _errorMessage
                            : null,
                    prefixIcon: const Icon(Icons.person),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _PasswordField(
                  controller: _passwordController,
                  errorText:
                      _passwordController.text.isEmpty && _errorMessage != null
                          ? _errorMessage
                          : null,
                ),
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
                    _showForgotPasswordDialog(context);
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

    setState(() {
      final List<String> missingFields = [];

      if (login.isEmpty) missingFields.add('LOGIN');
      if (password.isEmpty) missingFields.add('SENHA');

      if (missingFields.isNotEmpty) {
        final String errorMessage =
            'Preencha o(s) campo(s): ${missingFields.join(' e ')} para prosseguir!';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        Provider.of<AuthProvider>(context, listen: false).login(login);
        _isLoggedIn = true;

        _loginController.clear();
        _passwordController.clear();

        Navigator.of(context).pop();

      }
    });
  }

  Future<void> _showForgotPasswordDialog(BuildContext context) async {
    // ignore: no_leading_underscores_for_local_identifiers
    final TextEditingController _emailController = TextEditingController();
    // ignore: no_leading_underscores_for_local_identifiers
    String? _emailError;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Esqueceu sua senha?'),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            content: SizedBox(
              height: 140,
              width: 350.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Por favor, insira seu e-mail abaixo para receber as instruções de redefinição de senha.',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      errorText: _emailError,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_emailController.text.isEmpty) {
                        setState(() {
                          _emailError = 'Este campo é obrigatório';
                        });
                      } else {
                        setState(() {
                          _emailError = null;
                        });
                        Navigator.of(context).pop();
                        _showConfirmationDialog(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 32, 104, 199),
                    ),
                    child: const Text(
                      "Enviar",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showLoginDialog(context);
                    },
                    style: TextButton.styleFrom(
                      side: const BorderSide(color: Colors.grey, width: 0.3),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text(
                      "Voltar",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content:
              const Text('Email de redefinição de senha enviado com sucesso!'),
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
    final authProvider = Provider.of<AuthProvider>(context);
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
            child: authProvider.isLoggedIn ? 
              Row(children: [
                Text(
                  'Bem-Vindo, ${authProvider.userName}',
                  style: const TextStyle(color: Colors.white),
                ),
                IconButton(
                        icon: const Icon(Icons.logout),
                        color: Colors.white,
                        onPressed: () {
                          authProvider.logout();
                        },
                      ),
              ],
              )
            : ElevatedButton(
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
                _checkLogin(context);
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
      body: Column(
        children: [
          Expanded(
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
                            'Catálogos',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: filteredCatalogItems.map((item) {
                              IconData iconData = item['icon'] as IconData;
                              return _buildCatalogCard(
                                icon: iconData,
                                title: item['title']!,
                                subtitle: item['subtitle']!,
                                onTap: () {
                                   Navigator.pushNamed(context, item['route']);
                                },
                              );
                            }).toList(),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ),
          Container(
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
        ],
      ),
    );
  }

  Widget _buildCatalogCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      // onHighlightChanged: (isHighlighted) {},
      splashColor: Colors.blue.withOpacity(0.2),
      highlightColor: Colors.blue.withOpacity(0.1),
      borderRadius: BorderRadius.circular(15.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: 100,
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
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Icon(icon, size: 30, color: Colors.blue),
              const SizedBox(width: 15),
              Expanded(
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
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
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
                    _filterCatalogItems(query);
                  },
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
  final TextEditingController controller;
  final String? errorText;

  const _PasswordField({
    required this.controller,
    this.errorText,
  });

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
        errorText: widget.errorText,
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