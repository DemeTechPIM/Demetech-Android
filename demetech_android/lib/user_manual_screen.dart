import 'package:flutter/material.dart';

import 'my_drawer.dart';

class UserManualScreen extends StatelessWidget {
    
  void _showUnavailableMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Indisponível'),
          content: Text('O serviço de email de suporte está indisponível no momento.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Manual do Usuário'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bem-vindo ao Aplicativo!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Este manual irá guiá-lo através das funcionalidades do aplicativo.'),
            SizedBox(height: 24),
            Text('1. Login', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Para acessar o aplicativo, faça login utilizando seu CNPJ e senha cadastrados.'),
            SizedBox(height: 16),
            Text('2. Registro', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Se você ainda não possui uma conta, registre-se fornecendo as informações solicitadas.'),
            SizedBox(height: 16),
            Text('3. Catálogo de Produtos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Navegue pelo catálogo para visualizar os produtos disponíveis para compra.'),
            SizedBox(height: 16),
            Text('4. Adicionar ao Carrinho', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Clique no botão "Comprar" ao lado do produto desejado. Selecione a quantidade e adicione ao carrinho.'),
            SizedBox(height: 16),
            Text('5. Visualizar Carrinho', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Acesse o carrinho pelo menu lateral para ver os itens adicionados.'),
            SizedBox(height: 16),
            Text('6. Finalizar Compra', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Em breve, esta funcionalidade estará disponível.'),
            SizedBox(height: 16),
            Text('7. Logout', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Para sair do aplicativo, utilize a opção "Logout" no menu lateral.'),
            SizedBox(height: 16),
            Text('8. Manual do Usuário', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Você pode acessar este manual a qualquer momento pelo menu lateral.'),
            SizedBox(height: 24),
            Text('Precisa de ajuda?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            
            // Adicionando o link para o email de suporte
            GestureDetector(
              onTap: () {
                _showUnavailableMessage(context); // Exibe a mensagem de indisponibilidade
              },
              child: Text(
                'Entre em contato conosco através do email: demetech.suporte@gmail.com',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue, // Cor do "link"
                  decoration: TextDecoration.underline, // Sublinha o texto como um link
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
