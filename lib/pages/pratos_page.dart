import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../services/meal_service.dart';
import 'prato_detalhe.dart';

class PratosPage extends StatefulWidget {
  const PratosPage({super.key});

  @override
  State<PratosPage> createState() =>
      _PratosPageState();
}

class _PratosPageState
    extends State<PratosPage> {
  final MealService mealService =
      MealService();

  List<Meal> pratos = [];

  bool carregando = true;

  @override
  void initState() {
    super.initState();

    carregarPratos();
  }

  Future<void> carregarPratos() async {
    try {
      setState(() {
        carregando = true;
      });

      final dados =
          await mealService.buscarPratos();

      if (!mounted) return;

      setState(() {
        pratos = dados;
        carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        carregando = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao carregar pratos: $e',
          ),
        ),
      );
    }
  }

  Future<void> pesquisar(
    String valor,
  ) async {
    if (valor.isEmpty) {
      carregarPratos();
      return;
    }

    try {
      final dados =
          await mealService.pesquisarPratos(
        valor,
      );

      if (!mounted) return;

      setState(() {
        pratos = dados;
      });
    } catch (e) {
      if (!mounted) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pratos do Mundo',
        ),
      ),

      body: Column(
        children: [

          Padding(
            padding:
                const EdgeInsets.all(12),

            child: TextField(
              decoration: InputDecoration(
                hintText:
                    'Pesquisar prato...',

                prefixIcon:
                    const Icon(Icons.search),

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),

              onChanged: pesquisar,
            ),
          ),

          Expanded(
            child: carregando

                ? const Center(
                    child:
                        CircularProgressIndicator(),
                  )

                : pratos.isEmpty

                    ? const Center(
                        child: Text(
                          'Nenhum prato encontrado.',
                        ),
                      )

                    : RefreshIndicator(
                        onRefresh:
                            carregarPratos,

                        child:
                            ListView.builder(
                          itemCount:
                              pratos.length,

                          itemBuilder:
                              (
                            context,
                            index,
                          ) {
                            final prato =
                                pratos[index];

                            return Card(
                              margin:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),

                              child: ListTile(
                                leading:
                                    ClipRRect(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    8,
                                  ),

                                  child:
                                      Image.network(
                                    prato.imagem,

                                    width: 60,
                                    height: 60,

                                    fit:
                                        BoxFit.cover,

                                    errorBuilder:
                                        (
                                      context,
                                      error,
                                      stackTrace,
                                    ) {
                                      return const Icon(
                                        Icons
                                            .restaurant,
                                      );
                                    },
                                  ),
                                ),

                                title: Text(
                                  prato.nome,
                                ),

                                subtitle: Text(
                                  '${prato.categoria} • ${prato.origem}',
                                ),

                                trailing:
                                    const Icon(
                                  Icons
                                      .arrow_forward_ios,
                                  size: 16,
                                ),

                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          PratoDetalhePage(
                                        prato:
                                            prato,
                                      ),
                                    ),
                                  );
                                },
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
}