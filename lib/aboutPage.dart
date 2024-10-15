// ignore: file_names
import 'package:flutter/material.dart';
import 'package:projeto_flutter01/main.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final List<FaqItem> _faqItems = [
    FaqItem(question: "O que é o aplicativo?", answer: "Este aplicativo permite que os usuários acessem serviços e recursos de atendimento de forma prática e intuitiva."),
    FaqItem(question: "Como posso criar uma conta?", answer: "Para criar uma conta, clique em 'Criar uma conta' na tela de login e preencha seus dados."),
    FaqItem(question: "É seguro usar este aplicativo?", answer: "Sim! Garantimos a segurança dos seus dados utilizando tecnologias de criptografia avançadas."),
    FaqItem(question: "Posso recuperar minha senha?", answer: "Sim. Se você esqueceu sua senha, pode usar a opção de recuperação de senha na tela de login."),
  ];

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
                  'https://servicedesk.sydle.com/logo',
                  height: 100,
                  width: 100,
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
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Este aplicativo foi desenvolvido para fornecer uma experiência fácil e eficiente no acesso aos serviços do Portal de Atendimento. Nele, você pode realizar login, criar uma conta, acessar suas informações e enviar feedbacks para aprimorar ainda mais o serviço.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              'Perguntas Frequentes (FAQ)',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildFaqSection(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, 
        onTap: _onItemTapped,  
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Sobre',
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 80, 82, 84),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
      ),
    );
  }

  Widget _buildFaqSection() {
    return Column(
      children: _faqItems.map((faq) => FaqWidget(faq: faq)).toList(),
    );
  }
}

class FaqItem {
  final String question;
  final String answer;
  bool isExpanded;

  FaqItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}

class FaqWidget extends StatefulWidget {
  final FaqItem faq;

  const FaqWidget({super.key, required this.faq});

  @override
  // ignore: library_private_types_in_public_api
  _FaqWidgetState createState() => _FaqWidgetState();
}

class _FaqWidgetState extends State<FaqWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.faq.isExpanded = !widget.faq.isExpanded;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.faq.question,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              AnimatedCrossFade(
                firstChild: Container(),  
                secondChild: Text(
                  widget.faq.answer,
                  style: const TextStyle(fontSize: 16),
                ),
                crossFadeState: widget.faq.isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
