import 'dart:convert';

import 'package:http/http.dart' as http;

class ViaCepService {
  static const String baseUrl = 'https://viacep.com.br/ws';

  Future<Map<String, dynamic>> consultarCep(String cep) async {
    final cepLimpo = cep.replaceAll(RegExp(r'\D'), '');

    if (cepLimpo.length != 8) {
      throw Exception('Digite um CEP válido com 8 números.');
    }

    final response = await http
        .get(Uri.parse('$baseUrl/$cepLimpo/json/'))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Não foi possível consultar o CEP. Tente novamente.');
    }

    final dados = jsonDecode(response.body) as Map<String, dynamic>;

    if (dados['erro'] == true) {
      throw Exception('CEP não encontrado. Confira os números digitados.');
    }

    return dados;
  }
}
