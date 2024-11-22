import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'catalog_screen.dart';
import 'my_drawer.dart';
import 'globals.dart' as globals;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController cnpjController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  // Função para realizar o login utilizando a API
  Future<void> login(BuildContext context) async {
    final String apiUrl = "https://demetechapiapi.azure-api.net/api/Auth/Login";
    final headers = {
      'Content-Type': 'application/json',
      'Ocp-Apim-Subscription-Key': 'a5168012687a4da082be1f7795dd6dd5',
    };

    // Cria o corpo da requisição com o CNPJ e a senha
    final body = jsonEncode({
      "cnpj": cnpjController.text,
      "senha": senhaController.text,
    });

    // Mostra um indicador de carregamento
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      // Faz a requisição POST para a API
      final response = await http.post(Uri.parse(apiUrl), headers: headers, body: body);

      Navigator.of(context).pop(); // Fecha o indicador de carregamento

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Salva os dados retornados nas variáveis globais
        setState(() {
          // Não temos 'cnpj' na resposta, então podemos usar o cnpj inserido pelo usuário
          globals.cnpjGlobal = cnpjController.text;
          globals.nomeGlobal = responseData['nome'];
          globals.emailGlobal = responseData['email'];
          globals.carrinhoIdGlobal = responseData['carrinhoId'];
          globals.jwtTokenGlobal = responseData['token']; // Armazena o token JWT
        });

        // Reinicia o aplicativo com o usuário logado
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => CatalogScreen(),
          ),
          (Route<dynamic> route) => false, // Remove todas as rotas anteriores
        );
      } else {
        // Exibe uma mensagem de erro se o status não for 200
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Erro de Login'),
            content: Text('CNPJ ou senha inválidos.'),
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
      // Exibe uma mensagem de erro caso ocorra algum problema de conexão
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro de Conexão'),
          content: Text('Não foi possível conectar ao servidor. Verifique sua conexão.'),
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
        title: Text('Login'),
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
              controller: senhaController,
              decoration: InputDecoration(
                labelText: 'Senha',
                hintText: 'Digite sua senha',
              ),
              obscureText: true, // Oculta a senha durante a digitação
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                login(context); // Chama a função de login ao pressionar o botão
              },
              child: Text('Confirmar'),
            ),
            TextButton(
              onPressed: () {
                // Navega para a tela de registro
                Navigator.pushReplacementNamed(context, '/register');
              },
              child: Text('Cadastrar nova conta?'),
            ),
          ],
        ),
      ),
    );
  }
}
