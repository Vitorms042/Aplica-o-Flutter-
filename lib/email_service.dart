import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  // Configurações do servidor SMTP
  static final String _username = 'seu.email@gmail.com'; // Seu email
  static final String _password = 'sua-senha-do-email'; // Sua senha ou app password

  // Função para enviar email
  static Future<void> sendEmail({
    required String recipientEmail,
    required String subject,
    required String body,
  }) async {
    // Configuração do servidor SMTP (Gmail neste caso)
    final smtpServer = gmail(_username, _password);

    // Criando o email
    final message = Message()
      ..from = Address(_username, 'Seu Nome ou App') // Nome que aparecerá no remetente
      ..recipients.add(recipientEmail) // Destinatário
      ..subject = subject // Assunto do email
      ..text = body; // Corpo do email

    try {
      // Envia o email
      final sendReport = await send(message, smtpServer);
      print('Email enviado com sucesso: ${sendReport.toString()}');
    } on MailerException catch (e) {
      // Captura erros no envio
      print('Erro ao enviar email: $e');
    }
  }
}
