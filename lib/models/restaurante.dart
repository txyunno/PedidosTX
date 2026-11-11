class Restaurante {
  int? id;
  String nome;
  String tipo;
  String descricao;

  Restaurante({
    this.id,
    required this.nome,
    required this.tipo,
    required this.descricao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo,
      'descricao': descricao,
    };
  }

  factory Restaurante.fromMap(Map<String, dynamic> map) {
    return Restaurante(
      id: map['id'],
      nome: map['nome'],
      tipo: map['tipo'],
      descricao: map['descricao'],
    );
  }
}