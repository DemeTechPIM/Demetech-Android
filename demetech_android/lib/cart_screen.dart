import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'my_drawer.dart';
import 'globals.dart' as globals;

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<dynamic> cartItems = [];
  Map<String, dynamic>? carrinhoInfo;

  @override
  void initState() {
    super.initState();
    if (globals.jwtTokenGlobal == null) {
      // Se o usuário não estiver logado, redireciona para a tela de login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    } else {
      fetchCartItems(); // Carrega os itens do carrinho
    }
  }

  Future<void> fetchCartItems() async {
    final String apiUrl =
        "https://demetechapiapi.azure-api.net/api/Carrinho/${globals.carrinhoIdGlobal}";
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${globals.jwtTokenGlobal}',
      'Ocp-Apim-Subscription-Key': 'a5168012687a4da082be1f7795dd6dd5',
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          cartItems = responseData['itens'];  // Ajustado para letras minúsculas
          carrinhoInfo = responseData['carrinho'];
        });
      } else {
        // Inclui detalhes do erro
        String errorMessage =
            'Falha ao carregar itens do carrinho.\nStatus Code: ${response.statusCode}\nResposta: ${response.body}';
        showErrorDialog(errorMessage);
      }
    } catch (e) {
      showErrorDialog('Erro ao buscar itens do carrinho: $e');
    }
  }

  Future<void> removeFromCart(String codAliVendas) async {
    final String apiUrl =
        "https://demetechapiapi.azure-api.net/api/Alimentos/RemoverItem";
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${globals.jwtTokenGlobal}',
      'Ocp-Apim-Subscription-Key': 'a5168012687a4da082be1f7795dd6dd5',
    };

    final body = jsonEncode({
      "carrinhoId": globals.carrinhoIdGlobal,
      "codAliVendas": codAliVendas,
    });

    try {
      final response =
          await http.delete(Uri.parse(apiUrl), headers: headers, body: body);

      if (response.statusCode == 200) {
        setState(() {
          cartItems.removeWhere((item) => item['codAliVendas'] == codAliVendas);
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Sucesso!'),
            content: Text('Item removido do carrinho com sucesso.'),
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
        String errorMessage =
            'Não foi possível remover o item do carrinho.\nStatus Code: ${response.statusCode}\nResposta: ${response.body}';
        showErrorDialog(errorMessage);
      }
    } catch (e) {
      showErrorDialog('Erro ao tentar remover item: $e');
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
    if (globals.jwtTokenGlobal == null) {
      // Exibe uma tela de carregamento enquanto redireciona para o login
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Carrinho'),
      ),
      body: cartItems.isEmpty
          ? Center(child: Text('Carrinho vazio'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        title: Text(item['alimentoNome'] ?? 'Nome não disponível'),
                        subtitle:
                            Text('Preço: R\$ ${item['alimentoPreco'] ?? '0.00'}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            removeFromCart(item['codAliVendas']);
                          },
                        ),
                      );
                    },
                  ),
                ),
                if (carrinhoInfo != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text('Total de Itens: ${carrinhoInfo!['quantidade']}'),
                        Text('Preço Total: R\$ ${carrinhoInfo!['precoTotal']}'),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
