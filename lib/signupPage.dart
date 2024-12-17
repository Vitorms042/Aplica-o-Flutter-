// ignore: file_names
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_flutter01/auth_service.dart';
import 'package:projeto_flutter01/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastra-se',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  String? _selectedGender;
  bool _emailNotification = false;
  bool _smsNotification = false;
  String? _selectedArea;
  final List<String> _areas = ['RH', 'Comercial', 'Tecnologia', 'Financeiro', 'Suporte', 'Design', 'SEO', 'Jurídico'];
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.addListener(_formatDate);
  }

  @override
  void dispose() {
    _dateController.removeListener(_formatDate);
    _dateController.dispose();
    super.dispose();
  }

  void _formatDate() {
    String text = _dateController.text;
    text = text.replaceAll(RegExp(r'[^0-9]'), ''); 
    if (text.length > 8) text = text.substring(0, 8); 

    if (text.length >= 3 && text.length <= 4) {
      text = '${text.substring(0, 2)}/${text.substring(2)}';
    } else if (text.length > 4) {
      text = '${text.substring(0, 2)}/${text.substring(2, 4)}/${text.substring(4)}';
    }

    if (text != _dateController.text) {
      _dateController.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    final RegExp dateRegExp = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!dateRegExp.hasMatch(value)) {
      return 'Formato de data inválido';
    }
    try {
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      formatter.parseStrict(value);
    } catch (e) {
      return 'Data inválida';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Crie sua conta agora mesmo',
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Nome Completo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Digite seu nome',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Data de nascimento',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _dateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'DD/MM/AAAA',
                ),
                validator: _validateDate,
              ),
              const SizedBox(height: 20),
              const Text(
                'E-mail',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Digite seu e-mail',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Senha',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Digite sua senha',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Gênero',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: 'Masculino',
                    groupValue: _selectedGender,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                  const Text('Masculino'),
                  Radio<String>(
                    value: 'Feminino',
                    groupValue: _selectedGender,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                  const Text('Feminino'),
                  Radio<String>(
                    value: 'Outros',
                    groupValue: _selectedGender,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                  const Text('Outros'),
                ],
              ),
              if (_selectedGender == null)
                const Text(
                  'Campo obrigatório',
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              const Text(
                'Área de Atuação',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedArea,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Selecione sua área'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedArea = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
                items: _areas.map((String area) {
                  return DropdownMenuItem<String>(
                    value: area,
                    child: Text(area),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text('Notificações'),
              CheckboxListTile(
                title: const Text('Receber notificações por e-mail'),
                value: _emailNotification,
                onChanged: (bool? value) {
                  setState(() {
                    _emailNotification = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Receber notificações por SMS'),
                value: _smsNotification,
                onChanged: (bool? value) {
                  setState(() {
                    _smsNotification = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {

                      bool isRegistered = await _registerUser();

                      if (isRegistered) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Erro ao cadastrar o usuário')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text('Cadastrar', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
 Future<bool> _registerUser() async {
  try {
    // Coleta os dados do formulário e salva nas variáveis globais
    UserData.name = _nameController.text;
    UserData.dateOfBirth = _dateController.text;
    UserData.email = _emailController.text;
    UserData.password = _passwordController.text;
    UserData.gender = _selectedGender ?? '';
    UserData.area = _selectedArea ?? '';
    UserData.emailNotification = _emailNotification;
    UserData.smsNotification = _smsNotification;

    // Coleta as informações do formulário
    final email = _emailController.text;
    final password = _passwordController.text;
    final name = _nameController.text;
    final dateOfBirth = _dateController.text;

    // Chama o método de registro (usando o AuthService)
    final user = await AuthService().register(
      email,
      password,
      name,
      dateOfBirth,
      UserData.gender,
      UserData.area,
      UserData.emailNotification,
      UserData.smsNotification,
    );

    if (user != null) {
      // Cadastro bem-sucedido
      return true;
    }
    return false;
  } catch (e) {
    print('Erro ao registrar usuário: $e');
    return false;
  }
}
}

class UserData {
  static String name = '';
  static String dateOfBirth = '';
  static String email = '';
  static String password = '';
  static String gender = '';
  static String area = '';
  static bool emailNotification = false;
  static bool smsNotification = false;

  static Future<void> saveToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
    prefs.setString('dateOfBirth', dateOfBirth);
    prefs.setString('email', email);
    prefs.setString('password', password);
    prefs.setString('gender', gender);
    prefs.setString('area', area);
    prefs.setBool('emailNotification', emailNotification);
    prefs.setBool('smsNotification', smsNotification);
  }

  static Future<void> loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ?? '';
    dateOfBirth = prefs.getString('dateOfBirth') ?? '';
    email = prefs.getString('email') ?? '';
    password = prefs.getString('password') ?? '';
    gender = prefs.getString('gender') ?? '';
    area = prefs.getString('area') ?? '';
    emailNotification = prefs.getBool('emailNotification') ?? false;
    smsNotification = prefs.getBool('smsNotification') ?? false;
  }
}