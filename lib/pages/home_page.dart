import 'package:flutter/material.dart';

import '../data/database_helper.dart';
import '../data/initial_data.dart';
import '../models/restaurante.dart';
import 'detalhe_page.dart';
import 'form_restaurante_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String filtro = 'todos';

  String pesquisa = '';

  List<Restaurante> restaurantes = [];

  bool carregando = true;

  @override
  void initState() {
    super.initState();

    carregarDados();
  }

  Future<void> carregarDados() async {
  try {
    setState(() {
      carregando = true;
    });

    await inicializarBanco();

    final dados =
        await DatabaseHelper.instance.listarRestaurantes();

    if (!mounted) return;

    setState(() {
      restaurantes = dados;
      carregando = false;
    });
  } catch (e) {
    print('ERRO AO CARREGAR RESTAURANTES: $e');

    if (!mounted) return;

    setState(() {
      carregando = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Erro ao carregar banco: $e',
        ),
      ),
    );
  }
}

  List<Restaurante> get filtrados {

    List<Restaurante> lista = restaurantes;

    if (filtro != 'todos') {
      lista = lista
          .where((r) => r.tipo == filtro)
          .toList();
    }

    if (pesquisa.isNotEmpty) {
      lista = lista
          .where(
            (r) => r.nome
                .toLowerCase()
                .contains(
                  pesquisa.toLowerCase(),
                ),
          )
          .toList();
    }

    return lista;
  }

  Future<void> abrirFormulario({
    Restaurante? restaurante,
  }) async {

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormRestaurantePage(
          restaurante: restaurante,
        ),
      ),
    );

    carregarDados();
  }

  Future<void> excluirRestaurante(
    Restaurante restaurante,
  ) async {

    await DatabaseHelper.instance
        .excluirRestaurante(restaurante.id!);

    carregarDados();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Restaurante excluído!',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Pedidos TX'),

        actions: [

          IconButton(
            icon: const Icon(Icons.add_business),

            tooltip: 'Criar restaurante',

            onPressed: () {
              abrirFormulario();
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(

        onPressed: () {
          abrirFormulario();
        },

        icon: const Icon(Icons.add),

        label: const Text(
          'Restaurante',
        ),
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(12),

            child: TextField(

              decoration: InputDecoration(
                hintText: 'Pesquisar loja...',

                prefixIcon: const Icon(
                  Icons.search,
                ),

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),

              onChanged: (value) {

                setState(() {
                  pesquisa = value;
                });

              },
            ),
          ),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              filtroBotao('todos'),

              filtroBotao('doce'),

              filtroBotao('salgado'),
            ],
          ),

          Expanded(

            child: carregando

                ? const Center(
                    child:
                        CircularProgressIndicator(),
                  )

                : filtrados.isEmpty

                    ? const Center(
                        child: Text(
                          'Nenhum restaurante encontrado.',
                        ),
                      )

                    : RefreshIndicator(

                        onRefresh: carregarDados,

                        child: ListView.builder(

                          itemCount:
                              filtrados.length,

                          itemBuilder:
                              (context, index) {

                      final restaurante =
                        filtrados[index];

                    return Card(

            margin:
          const EdgeInsets
              .symmetric(
        horizontal: 12,
        vertical: 6,
      ),

        child: ListTile(

    leading:
        const Icon(
      Icons.store,
    ),

    title: Text(
      restaurante.nome,
    ),

    subtitle: Text(
      restaurante.descricao,
    ),

    onTap: () async {

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              DetalhePage(
            restaurante:
                restaurante,
          ),
        ),
      );

      carregarDados();
    },

    trailing: PopupMenuButton(

      itemBuilder:
          (context) => [

    const PopupMenuItem(
      value: 'editar',
      child: Text(
        'Editar',
      ),
    ),

    const PopupMenuItem(
      value: 'excluir',
      child: Text(
        'Excluir',
      ),
    ),
  ],

  onSelected:
      (valor) {

    if (valor ==
        'editar') {

      abrirFormulario(
        restaurante:
            restaurante,
      );
    }

    if (valor ==
        'excluir') {

 excluirRestaurante(
  restaurante,
   );
       }
       },
       ),
           ),
               );
            },
             ),
           ),
          ),
        ],
      ),
    );
  }

  Widget filtroBotao(String tipo) {

    return Padding(
      padding: const EdgeInsets.all(8),

      child: ElevatedButton(

        onPressed: () {

          setState(() {
            filtro = tipo;
          });

        },

        child: Text(
          tipo.toUpperCase(),
        ),
      ),
    );
  }
}