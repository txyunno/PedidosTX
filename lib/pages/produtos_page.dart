import 'package:flutter/material.dart';

import '../data/database_helper.dart';
import '../models/produto.dart';

class ProdutosPage extends StatefulWidget {
  final int restauranteId;

  const ProdutosPage({
    super.key,
    required this.restauranteId,
  });

  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  List<Produto> produtos = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarProdutos();
  }

  Future<void> carregarProdutos() async {
    try {
      final dados = await DatabaseHelper.instance.listarProdutos(
        widget.restauranteId,
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
          content: Text('Erro ao carregar produtos: $e'),
        ),
      );
    }
  }

  Future<void> abrirFormulario({Produto? produto}) async {
    final nomeController = TextEditingController(
      text: produto?.nome ?? '',
    );

    final descricaoController = TextEditingController(
      text: produto?.descricao ?? '',
    );

    final precoController = TextEditingController(
      text: produto?.preco.toString() ?? '',
    );

    final caloriasController = TextEditingController(
      text: produto?.calorias.toString() ?? '',
    );

    final carboidratosController = TextEditingController(
      text: produto?.carboidratos.toString() ?? '',
    );

    final proteinasController = TextEditingController(
      text: produto?.proteinas.toString() ?? '',
    );

    final gordurasController = TextEditingController(
      text: produto?.gorduras.toString() ?? '',
    );

    final sodioController = TextEditingController(
      text: produto?.sodio.toString() ?? '',
    );

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            produto == null
                ? 'Novo produto'
                : 'Editar produto',
          ),
          content: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: descricaoController,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: precoController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Preço',
                      prefixText: 'R\$ ',
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Informações nutricionais',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: caloriasController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Calorias',
                      suffixText: 'kcal',
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: carboidratosController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Carboidratos',
                      suffixText: 'g',
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: proteinasController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Proteínas',
                      suffixText: 'g',
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: gordurasController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Gorduras',
                      suffixText: 'g',
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: sodioController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Sódio',
                      suffixText: 'mg',
                    ),
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
              child: const Text('Cancelar'),
            ),

            ElevatedButton(
              onPressed: () async {
                final nome = nomeController.text.trim();
                final descricao = descricaoController.text.trim();

                final preco = double.tryParse(
                  precoController.text.replaceAll(',', '.'),
                );

                final calorias = double.tryParse(
                      caloriasController.text.replaceAll(',', '.'),
                    ) ??
                    0;

                final carboidratos = double.tryParse(
                      carboidratosController.text.replaceAll(',', '.'),
                    ) ??
                    0;

                final proteinas = double.tryParse(
                      proteinasController.text.replaceAll(',', '.'),
                    ) ??
                    0;

                final gorduras = double.tryParse(
                      gordurasController.text.replaceAll(',', '.'),
                    ) ??
                    0;

                final sodio = double.tryParse(
                      sodioController.text.replaceAll(',', '.'),
                    ) ??
                    0;

                if (nome.isEmpty || preco == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Preencha o nome e o preço corretamente.',
                      ),
                    ),
                  );

                  return;
                }

                final novoProduto = Produto(
                  id: produto?.id,
                  restauranteId: widget.restauranteId,
                  nome: nome,
                  descricao: descricao,
                  preco: preco,
                  calorias: calorias,
                  carboidratos: carboidratos,
                  proteinas: proteinas,
                  gorduras: gorduras,
                  sodio: sodio,
                );

                if (produto == null) {
                  await DatabaseHelper.instance.inserirProduto(
                    novoProduto,
                  );
                } else {
                  await DatabaseHelper.instance.atualizarProduto(
                    novoProduto,
                  );
                }

                if (!context.mounted) return;

                Navigator.pop(context);

                carregarProdutos();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> excluirProduto(Produto produto) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir produto'),
          content: Text(
            'Deseja realmente excluir "${produto.nome}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    await DatabaseHelper.instance.excluirProduto(
      produto.id!,
    );

    carregarProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar produtos'),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          abrirFormulario();
        },
        icon: const Icon(Icons.add),
        label: const Text('Produto'),
      ),

      body: carregando
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
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: const Icon(
                          Icons.fastfood,
                        ),
                        title: Text(
                          produto.nome,
                        ),
                        subtitle: Text(
                          'R\$ ${produto.preco.toStringAsFixed(2).replaceAll('.', ',')}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                              ),
                              tooltip: 'Editar',
                              onPressed: () {
                                abrirFormulario(
                                  produto: produto,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                              ),
                              tooltip: 'Excluir',
                              onPressed: () {
                                excluirProduto(produto);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}