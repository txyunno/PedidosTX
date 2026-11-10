class ItemCarrinho {
  final String nome;
  final double preco;
  int quantidade;

  ItemCarrinho({
    required this.nome,
    required this.preco,
    this.quantidade = 1,
  });
}

List<ItemCarrinho> carrinho = [];

void adicionarCarrinho(
  String nome,
  double preco,
) {

  final itens =
      carrinho.where(
    (e) => e.nome == nome,
  );

  if (itens.isNotEmpty) {

    itens.first.quantidade++;

    return;
  }

  carrinho.add(
    ItemCarrinho(
      nome: nome,
      preco: preco,
    ),
  );
}