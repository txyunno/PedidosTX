import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../data/carrinho.dart';
import '../models/restaurante.dart';
import '../models/produto.dart';
import 'produtos_page.dart';
import 'carrinho_page.dart';

class DetalhePage extends StatefulWidget {
  final Restaurante restaurante;

  const DetalhePage({
    super.key,
    required this.restaurante,
  });

  @override
  State<DetalhePage> createState() => _DetalhePageState();
}

class _DetalhePageState extends State<DetalhePage> {
  List<Produto> produtos = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarProdutos();
  }

  Future<void> carregarProdutos() async {
    try {
      setState(() {
        carregando = true;
      });

      final dados = await DatabaseHelper.instance.listarProdutos(
        widget.restaurante.id!,
      );

      if (!mounted) return;

      setState(() {
        produtos = dados;
        carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        carregando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao carregar produtos: $e',
          ),
        ),
      );
    }
  }

  void adicionarProdutoCarrinho(Produto produto) {
    adicionarCarrinho(
      produto.nome,
      produto.preco,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${produto.nome} adicionado ao carrinho!',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void mostrarTabelaNutricional(Produto produto) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Informação nutricional',
          ),
          content: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    produto.nome,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  DataTable(
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Nutriente',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Quantidade',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          const DataCell(
                            Text('Calorias'),
                          ),
                          DataCell(
                            Text(
                              '${produto.calorias.toStringAsFixed(0)} kcal',
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(
                            Text('Carboidratos'),
                          ),
                          DataCell(
                            Text(
                              '${produto.carboidratos.toStringAsFixed(1)} g',
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(
                            Text('Proteínas'),
                          ),
                          DataCell(
                            Text(
                              '${produto.proteinas.toStringAsFixed(1)} g',
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(
                            Text('Gorduras'),
                          ),
                          DataCell(
                            Text(
                              '${produto.gorduras.toStringAsFixed(1)} g',
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(
                            Text('Sódio'),
                          ),
                          DataCell(
                            Text(
                              '${produto.sodio.toStringAsFixed(0)} mg',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.restaurante.nome,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
            ),
            tooltip: 'Gerenciar produtos',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProdutosPage(
                    restauranteId: widget.restaurante.id!,
                  ),
                ),
              );

              carregarProdutos();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
            ),
            tooltip: 'Carrinho',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CarrinhoPage(),
                ),
              );
            },
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.restaurante.nome,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  widget.restaurante.tipo,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  widget.restaurante.descricao,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Text(
              'Produtos',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: carregando
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : produtos.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhum produto cadastrado.',
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: produtos.length,
                        itemBuilder: (context, index) {
                          final produto = produtos[index];

                          return Card(
                            margin: const EdgeInsets.only(
                              bottom: 12,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(
                                14,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.purple.withOpacity(
                                        0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        12,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.fastfood,
                                      size: 30,
                                      color: Colors.purple,
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          produto.nome,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        if (produto.descricao.isNotEmpty)
                                          Text(
                                            produto.descricao,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),

                                        const SizedBox(height: 8),

                                        Text(
                                          'R\$ ${produto.preco.toStringAsFixed(2).replaceAll('.', ',')}',
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.table_chart,
                                        ),
                                        tooltip: 'Valor nutricional',
                                        onPressed: () {
                                          mostrarTabelaNutricional(
                                            produto,
                                          );
                                        },
                                      ),

                                      IconButton(
                                        icon: const Icon(
                                          Icons.add_shopping_cart,
                                        ),
                                        tooltip: 'Adicionar ao carrinho',
                                        onPressed: () {
                                          adicionarProdutoCarrinho(
                                            produto,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}