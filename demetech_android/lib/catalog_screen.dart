import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'my_drawer.dart';
import 'globals.dart' as globals;

class CatalogScreen extends StatefulWidget {
  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Carrega os produtos da API
  }

  Future<void> fetchProducts() async {
    final String apiUrl = "https://demetechapiapi.azure-api.net/api/Alimentos";
    final headers = {
      'Content-Type': 'application/json',
      'Ocp-Apim-Subscription-Key': 'a5168012687a4da082be1f7795dd6dd5',
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        setState(() {
          products = jsonDecode(response.body);
        });
      } else {
        print('Falha ao carregar produtos');
      }
    } catch (e) {
      print('Erro ao buscar produtos: $e');
    }
  }

  // Mostrar diálogo de adicionar ao carrinho
  void showAddToCartDialog(dynamic product) {
    if (globals.jwtTokenGlobal == null) {
      // Se o usuário não estiver logado, redireciona para a tela de login
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar ao Carrinho'),
          content: Text('Deseja adicionar "${product['nome']}" ao carrinho?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                addToCart(product['codAliVendas']); // Passa o código do alimento
                Navigator.of(context).pop();
              },
              child: Text('Adicionar ao Carrinho'),
            ),
          ],
        );
      },
    );
  }

  Future<void> addToCart(String codAliVendas) async {
    final String apiUrl = "https://demetechapiapi.azure-api.net/api/Alimentos/AdicionarItem"; // Endpoint correto
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${globals.jwtTokenGlobal}',
      'Ocp-Apim-Subscription-Key': 'a5168012687a4da082be1f7795dd6dd5',
    };

    final body = jsonEncode({
      "carrinhoId": globals.carrinhoIdGlobal ?? 0, // Usa o carrinhoId global, ou 0 se for nulo
      "codAliVendas": codAliVendas // Envia o código do alimento
    });

    try {
      final response = await http.post(Uri.parse(apiUrl), headers: headers, body: body);

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Sucesso!'),
            content: Text('Item adicionado ao carrinho com sucesso.'),
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
      } else {
        showErrorDialog('Não foi possível adicionar ao carrinho.');
      }
    } catch (e) {
      showErrorDialog('Ocorreu um erro ao adicionar ao carrinho.');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Erro'),
        content: Text(message),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Catálogo de Produtos'),
      ),
      body: products.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product['nome']),
                  subtitle: Text('Preço: ${product['preco']}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      showAddToCartDialog(product);
                    },
                    child: Text('Comprar'),
                  ),
                );
              },
            ),
    );
  }
}
