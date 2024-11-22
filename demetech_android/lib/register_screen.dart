import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'my_drawer.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Capturar a entrada do usuário
  final TextEditingController cnpjController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  // Função para registrar o usuário usando a API
  Future<void> register(BuildContext context) async {
    final String apiUrl = "https://demetechapiapi.azure-api.net/api/Auth/Register";
    final headers = {
      'Content-Type': 'application/json',
      'Ocp-Apim-Subscription-Key': 'a5168012687a4da082be1f7795dd6dd5',
    };

    // Corpo da requisição JSON com os dados do formulário
    final body = jsonEncode({
      "nome": nomeController.text,
      "endereco": enderecoController.text,
      "numero": telefoneController.text,
      "senha": senhaController.text,
      "email": emailController.text,
      "cnpj": cnpjController.text,
    });

    // Mostra um indicador de carregamento
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      // Faz a requisição POST para a API de registro
      final response = await http.post(Uri.parse(apiUrl), headers: headers, body: body);

      Navigator.of(context).pop(); // Fecha o indicador de carregamento

      if (response.statusCode == 200) {
        // Exibe uma mensagem de sucesso e redireciona para a tela de login
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Registro Bem-sucedido'),
            content: Text('Registro realizado com sucesso. Por favor, faça login.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navega para a tela de login
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Se o registro falhar, captura a mensagem de erro retornada pela API
        final responseData = jsonDecode(response.body);
        final String errorMessage = responseData['mensagem'] ?? 'Erro ao registrar.';

        // Exibe a mensagem de erro retornada pela API
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Erro de Registro'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Fecha o indicador de carregamento
      // Exibe uma mensagem de erro se houver falha na conexão
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro de Conexão'),
          content: Text('Não foi possível conectar ao servidor.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(), // Inclui o menu lateral
      appBar: AppBar(
        title: Text('Registrar'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: cnpjController,
              decoration: InputDecoration(
                labelText: 'CNPJ',
                hintText: '00.000.000/0000-00',
              ),
            ),
            TextField(
              controller: nomeController,
              decoration: InputDecoration(
                labelText: 'Nome',
                hintText: 'Ex: João Silva',
              ),
            ),
            TextField(
              controller: enderecoController,
              decoration: InputDecoration(
                labelText: 'Endereço',
                hintText: 'Ex: Rua A, Nº 123',
              ),
            ),
            TextField(
              controller: telefoneController,
              decoration: InputDecoration(
                labelText: 'Número de Telefone',
                hintText: '(00) 90000-0000',
              ),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'exemplo@dominio.com',
              ),
            ),
            TextField(
              controller: senhaController,
              decoration: InputDecoration(
                labelText: 'Senha',
                hintText: 'Digite sua senha',
              ),
              obscureText: true, // Oculta a senha
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                register(context); // Chama a função de registro quando o botão é pressionado
              },
              child: Text('Confirmar'),
            ),
            TextButton(
              onPressed: () {
                // Navega para a tela de login se o usuário já tiver uma conta
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('Já tem uma conta?'),
            ),
          ],
        ),
      ),
    );
  }
}
