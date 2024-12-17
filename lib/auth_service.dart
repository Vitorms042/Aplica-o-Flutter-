import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_flutter01/eventos.dart';
import 'package:projeto_flutter01/signupPage.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  // Método de login
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Erro ao fazer login: $e');
      return null;
    }
  }

  // Método de logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Método de registro com Firestore
  Future<User?> register(
    String email,
    String password,
    String name,
    String dateOfBirth,
    String gender,
    String area,
    bool emailNotification,
    bool smsNotification,
  ) async {
    try {
      // Cria o usuário no Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        // Se o usuário foi criado no Auth, salve os dados no Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'name': name,
          'dateOfBirth': dateOfBirth,
          'gender': gender,
          'area': area,
          'emailNotification': emailNotification,
          'smsNotification': smsNotification,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return user;
    } catch (e) {
      print('Erro ao registrar usuário: $e');
      return null;
    }
  }

  Future<void> addQuestion(String question) async {
    try {
      await _firestore.collection('forum').add({
      'question': question,
      'userId': currentUser?.uid,
      'userName': 'Vitor Silva' ?? "Usuário Anônimo",  // Nome do usuário
      'timestamp': FieldValue.serverTimestamp(),  // Data da dúvida
      'answer': '',  // Resposta inicialmente vazia
      'answerBy': '',  // Resposta de quem
      'answerTimestamp': null,  // Data da resposta
});
    } catch (e) {
      print('Erro ao enviar dúvida: $e');
    }
  }

  Stream<QuerySnapshot> getQuestions() {
    return _firestore.collection('forum').orderBy('timestamp').snapshots();
  }

    Future<void> addAnswer(String questionId, String answer) async {
    try {
      await _firestore.collection('forum').doc(questionId).update({
        'answer': answer,
        'answerBy': 'Vitor Silva' ?? "Admin",  // Nome de quem respondeu
        'answerTimestamp': FieldValue.serverTimestamp(),  // Data da resposta
      });
    } catch (e) {
      print('Erro ao adicionar resposta: $e');
    }
  }

  // Método para adicionar serviço ao Firestore
  Future<void> addService(
    String title,
    String description,
    String icon,
    String category,
  ) async {
    try {
      await _firestore.collection('services').add({
        'title': title,
        'description': description,
        'icon': icon,
        'category': category,
        'createdBy': currentUser?.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Erro ao adicionar serviço: $e');
    }
  }

  // Método para editar um serviço
  Future<void> updateService(
    String serviceId,
    String title,
    String description,
    String icon,
    String category,
  ) async {
    try {
      await _firestore.collection('services').doc(serviceId).update({
        'title': title,
        'description': description,
        'icon': icon,
        'category': category,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Erro ao editar serviço: $e');
    }
  }

  // Método para recuperar todos os serviços
  Stream<QuerySnapshot> getServices() {
    return _firestore.collection('services').orderBy('createdAt').snapshots();
  }
  
Future<void> addEvento(Evento evento) async {
  try {
    // Obtendo o usuário atual
    User? user = _auth.currentUser;
    if (user != null) {
      // Adicionando evento na coleção 'eventos' no Firestore
      await _firestore.collection('eventos').add({
        'nome': evento.nome,
        'data': evento.data,  // Usando Timestamp para a data
        'descricao': evento.descricao,
        'userId': user.uid, // Associando o evento ao usuário logado
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  } catch (e) {
    print('Erro ao adicionar evento: $e');
  }
}

}