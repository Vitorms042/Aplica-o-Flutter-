import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplicativo RH',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RHScreen(),
    );
  }
}

class RHScreen extends StatelessWidget {
  const RHScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          'Recursos Humanos',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        elevation: 8,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Serviços de RH',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildServiceCard(
              context,
              'Folha de Pagamento',
              Icons.monetization_on,
              'Consulte seu histórico de pagamentos',
              FolhaDePagamentoScreen(),
            ),
            _buildServiceCard(
              context,
              'Benefícios',
              Icons.card_giftcard,
              'Veja seus benefícios e envie dúvidas',
              BeneficiosScreen(),
            ),
            _buildServiceCard(
              context,
              'Férias',
              Icons.beach_access,
              'Solicite e acompanhe suas férias',
              FeriasScreen(),
            ),
            _buildServiceCard(
              context,
              'Ponto Eletrônico',
              Icons.access_time,
              'Registre seu ponto e veja o histórico',
              PontoEletronicoScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
      BuildContext context, String title, IconData icon, String description, Widget screen) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[800],
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }
}

class FolhaDePagamentoScreen extends StatefulWidget {
  const FolhaDePagamentoScreen({super.key});

  @override
  _FolhaDePagamentoScreenState createState() => _FolhaDePagamentoScreenState();
}

class _FolhaDePagamentoScreenState extends State<FolhaDePagamentoScreen> {
  final List<Map<String, String>> historicoPagamentos = [
    {'mes': 'Janeiro 2024', 'valor': 'R\$ 5000,00'},
    {'mes': 'Fevereiro 2024', 'valor': 'R\$ 5200,00'},
    {'mes': 'Março 2024', 'valor': 'R\$ 5100,00'},
  ];

  final TextEditingController _mesController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _contestacaoController = TextEditingController();

  // Função para adicionar um novo pagamento
  void _adicionarPagamento() {
    if (_mesController.text.isNotEmpty && _valorController.text.isNotEmpty) {
      setState(() {
        historicoPagamentos.add({
          'mes': _mesController.text,
          'valor': _valorController.text,
        });
      });

      // Limpa os campos após adicionar
      _mesController.clear();
      _valorController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pagamento adicionado com sucesso!')),
      );
    }
  }

  // Função para remover um pagamento
  void _removerPagamento(int index) {
    setState(() {
      historicoPagamentos.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pagamento removido com sucesso!')),
    );
  }

  // Função para contestar um pagamento
  void _contestarPagamento(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contestar Pagamento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Você está contestando o pagamento de ${historicoPagamentos[index]['mes']} - ${historicoPagamentos[index]['valor']}.'),
              SizedBox(height: 10),
              TextField(
                controller: _contestacaoController,
                decoration: InputDecoration(
                  labelText: 'Descreva o erro',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (_contestacaoController.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Contestado com sucesso!'),
                    ),
                  );
                  // Limpa o campo de contestação
                  _contestacaoController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Enviar Contestação'),
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
        title: Text('Folha de Pagamento'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Histórico de Pagamento',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: historicoPagamentos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      '${historicoPagamentos[index]['mes']} - ${historicoPagamentos[index]['valor']}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removerPagamento(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.report_problem, color: Colors.orange),
                          onPressed: () => _contestarPagamento(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _mesController,
              decoration: InputDecoration(
                labelText: 'Mês',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _valorController,
              decoration: InputDecoration(
                labelText: 'Valor',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _adicionarPagamento,
              child: Text('Adicionar Pagamento'),
            ),
          ],
        ),
      ),
    );
  }
}


class BeneficiosScreen extends StatelessWidget {
  const BeneficiosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Benefícios'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Benefícios Disponíveis',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('• Vale Transporte\n• Vale Alimentação\n• Plano de Saúde'),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Envie uma dúvida ou solicitação',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Solicitação enviada com sucesso!')),
                );
              },
              child: Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}

class FeriasScreen extends StatefulWidget {
  const FeriasScreen({super.key});

  @override
  _FeriasScreenState createState() => _FeriasScreenState();
}

class _FeriasScreenState extends State<FeriasScreen> {
  DateTime? dataInicio;
  DateTime? dataFim;

  Future<void> _selecionarDataInicio(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != dataInicio) {
      setState(() {
        dataInicio = picked;
      });
    }
  }

  Future<void> _selecionarDataFim(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dataInicio ?? DateTime.now(),
      firstDate: dataInicio ?? DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != dataFim) {
      setState(() {
        dataFim = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Férias'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Solicitar Férias',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _selecionarDataInicio(context),
                    child: Text(dataInicio == null
                        ? 'Data de Início'
                        : DateFormat('dd/MM/yyyy').format(dataInicio!)),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: dataInicio != null
                        ? () => _selecionarDataFim(context)
                        : null,
                    child: Text(dataFim == null
                        ? 'Data de Fim'
                        : DateFormat('dd/MM/yyyy').format(dataFim!)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: dataInicio != null && dataFim != null
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Solicitação de férias enviada!')),
                      );
                    }
                  : null,
              child: Text('Solicitar Férias'),
            ),
          ],
        ),
      ),
    );
  }
}

class PontoEletronicoScreen extends StatefulWidget {
  const PontoEletronicoScreen({super.key});

  @override
  _PontoEletronicoScreenState createState() => _PontoEletronicoScreenState();
}

class _PontoEletronicoScreenState extends State<PontoEletronicoScreen> {
  final List<String> registrosPonto = [];

  void _registrarPonto(String tipo) {
    final String registro = '${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())} - $tipo';
    setState(() {
      registrosPonto.insert(0, registro);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$tipo registrado com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ponto Eletrônico'),
              backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Registro de Ponto',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _registrarPonto('Entrada'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text('Registrar Entrada'),
                ),
                ElevatedButton(
                  onPressed: () => _registrarPonto('Saída'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('Registrar Saída'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Histórico de Registros',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: registrosPonto.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(registrosPonto[index]),
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