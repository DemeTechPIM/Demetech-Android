library my_app.globals;

// Variáveis globais para armazenar dados do usuário logado
String? cnpjGlobal;
String? nomeGlobal;
String? emailGlobal;
int? carrinhoIdGlobal;
String? jwtTokenGlobal; // Armazena o token JWT

// Função para resetar os dados do usuário
void resetUserData() {
  cnpjGlobal = null;
  nomeGlobal = null;
  emailGlobal = null;
  carrinhoIdGlobal = null;
  jwtTokenGlobal = null; // Zera o token JWT ao fazer logout
}
