class Produto {
  int? id;
  int restauranteId;
  String nome;
  String descricao;
  double preco;

  double calorias;
  double carboidratos;
  double proteinas;
  double gorduras;
  double sodio;

  Produto({
    this.id,
    required this.restauranteId,
    required this.nome,
    required this.descricao,
    required this.preco,
    this.calorias = 0,
    this.carboidratos = 0,
    this.proteinas = 0,
    this.gorduras = 0,
    this.sodio = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'restaurante_id': restauranteId,
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'calorias': calorias,
      'carboidratos': carboidratos,
      'proteinas': proteinas,
      'gorduras': gorduras,
      'sodio': sodio,
    };
  }

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'],
      restauranteId: map['restaurante_id'],
      nome: map['nome'],
      descricao: map['descricao'] ?? '',
      preco: (map['preco'] as num).toDouble(),
      calorias: (map['calorias'] ?? 0).toDouble(),
      carboidratos: (map['carboidratos'] ?? 0).toDouble(),
      proteinas: (map['proteinas'] ?? 0).toDouble(),
      gorduras: (map['gorduras'] ?? 0).toDouble(),
      sodio: (map['sodio'] ?? 0).toDouble(),
    );
  }
}