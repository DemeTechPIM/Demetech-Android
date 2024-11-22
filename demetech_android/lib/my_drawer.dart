import 'package:flutter/material.dart';
import 'catalog_screen.dart';
import 'cart_screen.dart';
import 'user_manual_screen.dart'; // Se você tiver essa tela
import 'globals.dart' as globals;

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = globals.jwtTokenGlobal != null;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              isLoggedIn ? globals.nomeGlobal! : 'Visitante',
              style: TextStyle(fontSize: 24),
            ),
            accountEmail: Text(
              isLoggedIn ? globals.emailGlobal! : '',
            ),
            currentAccountPicture: CircleAvatar(
              child: Icon(
                Icons.person,
                size: 40,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.green,
            ),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Catálogo de Produtos'),
            onTap: () {
              // Catálogo pode ser acessado por todos, logados ou não
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CatalogScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Carrinho'),
            onTap: () {
              // Catálogo pode ser acessado por todos, logados ou não
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Manual do Usuário'),
            onTap: () {
              // Manual pode ser acessado por todos, logados ou não
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserManualScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(isLoggedIn ? Icons.logout : Icons.login),
            title: Text(isLoggedIn ? 'Logout' : 'Login'),
            onTap: () {
              if (isLoggedIn) {
                // Realiza o logout e reseta os dados
                globals.resetUserData();
                // Retorna à tela de login
                Navigator.pushReplacementNamed(context, '/login');
              } else {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Mostrar Variáveis Globais'),
            onTap: () {
              // Exibe as variáveis globais em um AlertDialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Variáveis Globais'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        Text('CNPJ: ${globals.cnpjGlobal ?? "Não disponível"}'),
                        Text('Nome: ${globals.nomeGlobal ?? "Não disponível"}'),
                        Text('Email: ${globals.emailGlobal ?? "Não disponível"}'),
                        Text('ID do Carrinho: ${globals.carrinhoIdGlobal ?? "Não disponível"}'),
                        Text('Token JWT: ${globals.jwtTokenGlobal != null ? "Presente" : "Não disponível"}'),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Fecha o diálogo
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}