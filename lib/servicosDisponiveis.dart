import 'package:flutter/material.dart';
import 'package:projeto_flutter01/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  final AuthService _authService = AuthService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _iconController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  void _showCreateServiceDialog([DocumentSnapshot? service]) {
    if (service != null) {
      _titleController.text = service['title'];
      _descriptionController.text = service['description'];
      _iconController.text = service['icon'];
      _categoryController.text = service['category'];
    } else {
      _clearControllers();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: Text(service == null ? 'Criar Serviço' : 'Editar Serviço', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextFormField(
                controller: _titleController,
                label: 'Título',
                icon: Icons.title,
                hint: 'Digite o título do serviço',
                iconColor: Colors.white,
              ),
              _buildTextFormField(
                controller: _descriptionController,
                label: 'Descrição',
                icon: Icons.description,
                hint: 'Digite uma descrição breve',
                maxLines: 3,
                iconColor: Colors.white,
              ),
              _buildTextFormField(
                controller: _iconController,
                label: 'Ícone (ex: Icons.work)',
                icon: Icons.iron,
                hint: 'Digite o nome do ícone',
                iconColor: Colors.white,
              ),
              _buildTextFormField(
                controller: _categoryController,
                label: 'Categoria',
                icon: Icons.category,
                hint: 'Digite a categoria do serviço',
                iconColor: Colors.white,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              if (service == null) {
                _authService.addService(
                  _titleController.text,
                  _descriptionController.text,
                  _iconController.text,
                  _categoryController.text,
                );
              } else {
                _authService.updateService(
                  service.id,
                  _titleController.text,
                  _descriptionController.text,
                  _iconController.text,
                  _categoryController.text,
                );
              }
              Navigator.of(context).pop();
              _clearControllers();
            },
            child: Text(service == null ? 'Criar' : 'Salvar', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    int? maxLines,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(color: Colors.white70),
          hintStyle: TextStyle(color: Colors.white54),
          prefixIcon: Icon(icon, color: iconColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white54, width: 1.5),
          ),
          filled: true,
          fillColor: Colors.black54,
        ),
        maxLines: maxLines,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void _clearControllers() {
    _titleController.clear();
    _descriptionController.clear();
    _iconController.clear();
    _categoryController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Serviços', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _authService.getServices(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            var services = snapshot.data!.docs;
            return ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                var service = services[index];
                return _buildServiceCard(service);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateServiceDialog(),
        child: const Icon(Icons.add),
        tooltip: 'Adicionar Novo Serviço',
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildServiceCard(QueryDocumentSnapshot service) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.black45,
      child: InkWell(
        onTap: () {
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.work, 
                size: 40,
                color: Colors.blue,
              ),
              const SizedBox(height: 10),
              Text(
                service['title'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                service['description'],
                style: const TextStyle(
                  color: Colors.white70,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      _showCreateServiceDialog(service);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}