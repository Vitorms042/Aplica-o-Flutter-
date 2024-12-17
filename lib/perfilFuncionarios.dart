import 'package:flutter/material.dart';
import 'signupPage.dart'; // Importe o arquivo UserData

class PerfilFuncionario extends StatefulWidget {
  const PerfilFuncionario({super.key});

  @override
  _PerfilFuncionarioState createState() => _PerfilFuncionarioState();
}

class _PerfilFuncionarioState extends State<PerfilFuncionario> {
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Carregar os dados do SharedPreferences
  Future<void> _loadUserData() async {
    await UserData.loadFromPreferences(); // Carrega os dados do UserData
    setState(() {}); // Atualiza a interface com os dados carregados
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
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 120,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    UserData.name.isNotEmpty ? UserData.name : 'Nome do Funcionário',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Departamento: ${UserData.area}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Divider(thickness: 1, color: Colors.grey),
            const SizedBox(height: 10),
            const Text(
              'Informações de Contato',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            _buildProfileInfoRow(Icons.email, UserData.email.isNotEmpty ? UserData.email : 'Email: '),
            const Divider(thickness: 1, color: Colors.grey),
            const SizedBox(height: 20),
            const Text(
              'Informações Pessoais',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            _buildProfileInfoRow(Icons.cake, UserData.dateOfBirth.isNotEmpty ? 'Data de Nascimento: ${UserData.dateOfBirth}' : 'Data de Nascimento: '),
            _buildProfileInfoRow(Icons.person, UserData.gender.isNotEmpty ? 'Gênero: ${UserData.gender}' : 'Gênero: '),
            const Divider(thickness: 1, color: Colors.grey),
            const SizedBox(height: 20),
            const Text(
              'Outras Informações',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            _buildProfileInfoRow(Icons.phone, 'Telefone: +55 (11) 98765-4321'),
            _buildProfileInfoRow(Icons.location_on, 'Endereço: Rua da Empresa, 123, São Paulo, SP'),
            _buildProfileInfoRow(Icons.work, 'Cargo: Desenvolvedor de Software'),
            _buildProfileInfoRow(Icons.business, 'Empresa: ABC Tecnologia Ltda'),
            const SizedBox(height: 20),
            const Divider(thickness: 1, color: Colors.grey),
            const SizedBox(height: 10),
            const Text(
              'Histórico Profissional',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            _buildProfileInfoRow(Icons.calendar_today, 'Data de Admissão: 01/01/2020'),
            _buildProfileInfoRow(Icons.access_time, 'Anos de serviço: 4 anos'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: LinearProgressIndicator(
                value: 4 / 10,
                backgroundColor: Colors.grey[300],
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}