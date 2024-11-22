import 'package:flutter/material.dart';
import 'catalog_screen.dart';
import 'login_screen.dart';
import 'cart_screen.dart';
import 'register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Produtos',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => CatalogScreen(), // Visitantes podem acessar o catálogo diretamente
        '/login': (context) => LoginScreen(),
        '/cart': (context) => CartScreen(),
        '/register': (context) => RegisterScreen(), // Rota de registro adicionada
      },
    );
  }
}
