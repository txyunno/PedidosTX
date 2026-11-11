import 'package:flutter/material.dart';

import '../services/viacep_service.dart';

class FinalizarPage extends StatefulWidget {
  final double total;

  const FinalizarPage({super.key, required this.total});

  @override
  State<FinalizarPage> createState() => _FinalizarPageState();
}

class _FinalizarPageState extends State<FinalizarPage> {
  final cupomController = TextEditingController();
  final cepController = TextEditingController();
  final numeroController = TextEditingController();
  final complementoController = TextEditingController();
  final ruaController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();

  final ViaCepService viaCepService = ViaCepService();

  late double totalFinal;
  bool desconto = false;
  bool buscandoCep = false;

  @override
  void initState() {
    super.initState();
    totalFinal = widget.total;
  }

  @override
  void dispose() {
    cupomController.dispose();
    cepController.dispose();
    numeroController.dispose();
    complementoController.dispose();
    ruaController.dispose();
    bairroController.dispose();
    cidadeController.dispose();
    estadoController.dispose();
    super.dispose();
  }

  void aplicarCupom() {
    if (cupomController.text.trim().toUpperCase() == 'DESCONTO10' &&
        !desconto) {
      setState(() {
        totalFinal *= 0.9;
        desconto = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cupom de 10% aplicado!')),
      );
    } else if (desconto) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O cupom já foi aplicado.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cupom inválido.')),
      );
    }
  }

  Future<void> buscarCep() async {
    FocusScope.of(context).unfocus();
    setState(() => buscandoCep = true);

    try {
      final endereco = await viaCepService.consultarCep(cepController.text);
      if (!mounted) return;

      setState(() {
        ruaController.text = endereco['logradouro'] ?? '';
        bairroController.text = endereco['bairro'] ?? '';
        cidadeController.text = endereco['localidade'] ?? '';
        estadoController.text = endereco['uf'] ?? '';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Endereço encontrado pelo ViaCEP!')),
      );
    } catch (e) {
      if (!mounted) return;
      final mensagem = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem)),
      );
    } finally {
      if (mounted) setState(() => buscandoCep = false);
    }
  }

  Widget campoEndereco({
    required TextEditingController controller,
    required String label,
    bool somenteLeitura = false,
    TextInputType tipo = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        readOnly: somenteLeitura,
        keyboardType: tipo,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finalizar pedido')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Endereço de entrega',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: cepController,
                    keyboardType: TextInputType.number,
                    maxLength: 9,
                    decoration: const InputDecoration(
                      labelText: 'CEP',
                      hintText: '00000-000',
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: buscandoCep ? null : buscarCep,
                    child: buscandoCep
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Buscar CEP'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            campoEndereco(controller: ruaController, label: 'Rua', somenteLeitura: true),
            Row(
              children: [
                Expanded(child: campoEndereco(controller: numeroController, label: 'Número', tipo: TextInputType.number)),
                const SizedBox(width: 10),
                Expanded(child: campoEndereco(controller: complementoController, label: 'Complemento')),
              ],
            ),
            campoEndereco(controller: bairroController, label: 'Bairro', somenteLeitura: true),
            campoEndereco(controller: cidadeController, label: 'Cidade', somenteLeitura: true),
            campoEndereco(controller: estadoController, label: 'Estado', somenteLeitura: true),
            const Divider(height: 30),
            const Text(
              'Cupom de desconto',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: cupomController,
              decoration: const InputDecoration(
                labelText: 'Cupom',
                hintText: 'Ex.: DESCONTO10',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: aplicarCupom,
              child: const Text('Aplicar cupom'),
            ),
            const SizedBox(height: 24),
            const Text('Valor final', style: TextStyle(fontSize: 20)),
            Text(
              'R\$ ${totalFinal.toStringAsFixed(2).replaceAll('.', ',')}',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (cepController.text.trim().isEmpty ||
                    ruaController.text.trim().isEmpty ||
                    numeroController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Informe o CEP, busque o endereço e preencha o número.'),
                    ),
                  );
                  return;
                }

                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Pedido realizado'),
                    content: const Text('Obrigado pela compra! Seu pedido foi registrado.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Comprar'),
            ),
          ],
        ),
      ),
    );
  }
}
