import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/restaurante.dart';

class FormRestaurantePage extends StatefulWidget {

  final Restaurante? restaurante;

  const FormRestaurantePage({
    super.key,
    this.restaurante,
  });

  @override
  State<FormRestaurantePage> createState() =>
      _FormRestaurantePageState();
}

class _FormRestaurantePageState
    extends State<FormRestaurantePage> {

  final nomeController = TextEditingController();

  final descricaoController =
      TextEditingController();

  String tipo = 'salgado';

  bool get editando =>
      widget.restaurante != null;

  @override
  void initState() {

    super.initState();

    if (editando) {

      nomeController.text =
          widget.restaurante!.nome;

      descricaoController.text =
          widget.restaurante!.descricao;

      tipo = widget.restaurante!.tipo;
    }
  }

  @override
  void dispose() {

    nomeController.dispose();

    descricaoController.dispose();

    super.dispose();
  }

  Future<void> salvar() async {

    if (nomeController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Digite o nome do restaurante.',
          ),
        ),
      );

      return;
    }

    if (editando) {

      final restaurante =
          Restaurante(
        id: widget.restaurante!.id,

        nome: nomeController.text.trim(),

        tipo: tipo,

        descricao:
            descricaoController.text.trim(),
      );

      await DatabaseHelper.instance
          .atualizarRestaurante(
        restaurante,
      );

    } else {

      final restaurante =
          Restaurante(
        nome: nomeController.text.trim(),

        tipo: tipo,

        descricao:
            descricaoController.text.trim(),
      );

      await DatabaseHelper.instance
          .inserirRestaurante(
        restaurante,
      );
    }

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(
          editando
              ? 'Editar Restaurante'
              : 'Criar Restaurante',
        ),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(

              controller: nomeController,

              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(

              controller:
                  descricaoController,

              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(

              value: tipo,

              decoration: const InputDecoration(
                labelText: 'Tipo',
                border: OutlineInputBorder(),
              ),

              items: const [

                DropdownMenuItem(
                  value: 'salgado',
                  child: Text('Salgado'),
                ),

                DropdownMenuItem(
                  value: 'doce',
                  child: Text('Doce'),
                ),
              ],

              onChanged: (value) {

                if (value != null) {

                  setState(() {
                    tipo = value;
                  });
                }
              },
            ),

            const SizedBox(height: 25),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton.icon(

                onPressed: salvar,

                icon: const Icon(
                  Icons.save,
                ),

                label: Text(
                  editando
                      ? 'Salvar alterações'
                      : 'Criar restaurante',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}