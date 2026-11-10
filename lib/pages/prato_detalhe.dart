import 'package:flutter/material.dart';

import '../models/meal.dart';

class PratoDetalhePage
    extends StatelessWidget {
  final Meal prato;

  const PratoDetalhePage({
    super.key,
    required this.prato,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          prato.nome,
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Image.network(
              prato.imagem,

              width: double.infinity,
              height: 250,

              fit: BoxFit.cover,

              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return Container(
                  height: 250,

                  alignment:
                      Alignment.center,

                  child: const Icon(
                    Icons.restaurant,
                    size: 80,
                  ),
                );
              },
            ),

            Padding(
              padding:
                  const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    prato.nome,

                    style:
                        const TextStyle(
                      fontSize: 26,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Row(
                    children: [

                      const Icon(
                        Icons.category,
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                      Text(
                        prato.categoria,
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Row(
                    children: [

                      const Icon(
                        Icons.public,
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                      Text(
                        prato.origem,
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  const Text(
                    'Modo de preparo',

                    style:
                        TextStyle(
                      fontSize: 20,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    prato.instrucoes,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}