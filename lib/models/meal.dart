class Meal {
  final String id;
  final String nome;
  final String categoria;
  final String origem;
  final String imagem;
  final String instrucoes;

  Meal({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.origem,
    required this.imagem,
    required this.instrucoes,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'] ?? '',
      nome: json['strMeal'] ?? '',
      categoria: json['strCategory'] ?? '',
      origem: json['strArea'] ?? '',
      imagem: json['strMealThumb'] ?? '',
      instrucoes: json['strInstructions'] ?? '',
    );
  }
}