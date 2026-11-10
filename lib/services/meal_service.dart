import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/meal.dart';

class MealService {
  static const String baseUrl =
      'https://www.themealdb.com/api/json/v1/1';

  Future<List<Meal>> buscarPratos() async {
    final response = await http.get(
      Uri.parse('$baseUrl/search.php?s='),
    );

    if (response.statusCode == 200) {
      final dados = jsonDecode(response.body);

      final List meals = dados['meals'] ?? [];

      return meals
          .map(
            (json) => Meal.fromJson(json),
          )
          .toList();
    } else {
      throw Exception(
        'Erro ao buscar pratos',
      );
    }
  }

  Future<List<Meal>> pesquisarPratos(
    String pesquisa,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/search.php?s=$pesquisa',
      ),
    );

    if (response.statusCode == 200) {
      final dados = jsonDecode(response.body);

      final List meals = dados['meals'] ?? [];

      return meals
          .map(
            (json) => Meal.fromJson(json),
          )
          .toList();
    } else {
      throw Exception(
        'Erro ao pesquisar pratos',
      );
    }
  }
}