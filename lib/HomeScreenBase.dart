import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';

class HomeScreenBase extends StatefulWidget {
  final Widget child;

  const HomeScreenBase({super.key, required this.child});

  @override
  _HomeScreenBaseState createState() => _HomeScreenBaseState();
}

class _HomeScreenBaseState extends State<HomeScreenBase> {
  int _selectedIndex = 0;

  final List<String> _routes = [
    '/',
    '/eventos',
    '/ferramentas',
    '/services',
    '/perfil',
    '/signup',
  ];

  void _onItemTapped(int index) {
    Navigator.pushNamed(context, _routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              color: Colors.black,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Image.network(
                      'https://servicedesk.sydle.com/logo',
                      height: 50.0,
                      width: 100.0,
                    ),
                  ),
                  if (user != null) ...[
                    Text(
                      'Bem-Vindo, ${user.email}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: () {
                        authService.logout();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Logout realizado com sucesso!'),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      },
                    ),
                  ] else
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'Entrar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),

            // Corpo dinâmico
            Expanded(
              child: SingleChildScrollView(
                child: widget.child,
              ),
            ),

            // BottomNavigationBar
            BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
                BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Eventos'),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ferramentas'),
                BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Serviços'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
                BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'Cadastro'),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              onTap: _onItemTapped,
            ),

            // Powered by Footer
            Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                      height: 30.0,
                      width: 80.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
