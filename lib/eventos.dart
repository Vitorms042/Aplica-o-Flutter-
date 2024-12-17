import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';  

class Evento {
  final String nome;
  final Timestamp data;
  final String descricao;

  Evento({
    required this.nome,
    required this.data,
    required this.descricao,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'data': data,
      'descricao': descricao,
    };
  }

  factory Evento.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Evento(
      nome: data['nome'] ?? '',
      data: data['data'] ?? Timestamp.now(),
      descricao: data['descricao'] ?? '',
    );
  }
}

class CriarEvento extends StatefulWidget {
  const CriarEvento({super.key});

  @override
  _CriarEventoState createState() => _CriarEventoState();
}

class _CriarEventoState extends State<CriarEvento> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  DateTime _dataEvento = DateTime.now();
  final TextEditingController _dataController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dataController.text = "${_dataEvento.day}/${_dataEvento.month}/${_dataEvento.year}";
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dataEvento,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _dataEvento) {
      setState(() {
        _dataEvento = pickedDate;
        _dataController.text = "${_dataEvento.day}/${_dataEvento.month}/${_dataEvento.year}";
      });
    }
  }

  void _createEvent() {
    if (_nomeController.text.isEmpty || _descricaoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, preencha todos os campos")),
      );
      return;
    }

    Evento novoEvento = Evento(
      nome: _nomeController.text,
      data: Timestamp.fromDate(_dataEvento),
      descricao: _descricaoController.text,
    );

    AuthService().addEvento(novoEvento);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Evento criado com sucesso!")),
    );

    _nomeController.clear();
    _descricaoController.clear();
    _dataController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Criar Evento"),
        backgroundColor: const Color.fromARGB(255, 124, 124, 124),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: 'Nome do Evento',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descricaoController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _dataController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Data do Evento',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _pickDate,
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createEvent,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black12),
              child: Text("Criar Evento"),
            ),
            SizedBox(height: 32),
            // Lista de eventos
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('eventos').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar eventos'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('Nenhum evento encontrado.'));
                  }

                  final eventos = snapshot.data!.docs.map((doc) => Evento.fromFirestore(doc)).toList();

                  return ListView.builder(
                    itemCount: eventos.length,
                    itemBuilder: (context, index) {
                      final evento = eventos[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(evento.nome),
                          subtitle: Text(evento.descricao),
                          trailing: Text(
                            "${evento.data.toDate().day}/${evento.data.toDate().month}/${evento.data.toDate().year}",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}