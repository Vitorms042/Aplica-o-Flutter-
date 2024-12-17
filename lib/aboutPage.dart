import 'package:flutter/material.dart';
import 'package:projeto_flutter01/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  final AuthService _authService = AuthService();

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.grey],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Sobre o Aplicativo',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Image.network(
                  'https://servicedesk.sydle.com/logo',  // Atualize o link para o logo real
                  height: 80,
                  width: 80,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Sobre o Aplicativo',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Este aplicativo foi desenvolvido para fornecer uma experiência fácil e eficiente no acesso aos serviços do Portal de Atendimento. Nele, você pode realizar login, criar uma conta, acessar suas informações e enviar feedbacks para aprimorar ainda mais o serviço.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white54),
            const SizedBox(height: 20),
            const Text(
              'Serviços Oferecidos',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'O Service Desk oferece uma gama de serviços para facilitar o atendimento e a resolução de problemas dos usuários.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white54),
            const SizedBox(height: 20),
            const Text(
              'Perguntas Frequentes (FAQ)',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            _buildFaqSection(),
            const SizedBox(height: 20),
            const Divider(color: Colors.white54),
            const SizedBox(height: 20),
            const Text(
              'Fórum de Dúvidas',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Se você tem alguma dúvida não respondida aqui, envie sua pergunta abaixo.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                labelText: 'Digite sua dúvida aqui',
                border: OutlineInputBorder(),
                hintText: 'Escreva sua pergunta...',
                filled: true,
                fillColor: Colors.grey[200],
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                // Salva a dúvida no Firestore
                await _authService.addQuestion(_questionController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dúvida enviada com sucesso!')),
                );
                _questionController.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Enviar Dúvida',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white54),
            const SizedBox(height: 20),
            const Text(
              'Todas as Dúvidas',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: _authService.getQuestions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('Nenhuma dúvida enviada.');
                }

                final questions = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final question = questions[index];
                    final questionText = question['question'];
                    final userName = question['userName'];
                    final timestamp = question['timestamp']?.toDate();
                    final answer = question['answer'];
                    final answerBy = question['answerBy'];
                    final answerTimestamp = question['answerTimestamp']?.toDate();

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      child: ListTile(
                        title: Text(questionText),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Pergunta por: $userName'),
                            Text('Data: ${timestamp != null ? timestamp.toLocal().toString() : 'Sem data'}'),
                            if (answer.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text('Resposta por: $answerBy'),
                              Text('Data da resposta: ${answerTimestamp != null ? answerTimestamp.toLocal().toString() : 'Sem data'}'),
                              Text('Resposta: $answer'),
                            ],
                            TextField(
                              controller: _answerController,
                              decoration: InputDecoration(
                                labelText: 'Responda aqui',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await _authService.addAnswer(question.id, _answerController.text);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Resposta enviada com sucesso!')),
                                );
                                _answerController.clear();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Enviar Resposta',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqSection() {
    return Column(
      children: [
        // Coloque as perguntas frequentes aqui
      ],
    );
  }
}