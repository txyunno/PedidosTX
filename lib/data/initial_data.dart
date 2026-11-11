import 'package:shared_preferences/shared_preferences.dart';
import '../models/restaurante.dart';
import '../models/produto.dart';
import 'database_helper.dart';

Future<void> inicializarBanco() async {

  final prefs = await SharedPreferences.getInstance();

  final bancoInicializado =
      prefs.getBool('banco_inicializado') ?? false;

  if (bancoInicializado) {
    return;
  }

  final db = DatabaseHelper.instance;

  // =========================
  // RESTAURANTE 1
  // =========================

  final doceriaId = await db.inserirRestaurante(
    Restaurante(
      nome: 'Doceria da Ana',
      tipo: 'doce',
      descricao: 'Bolos e doces',
    ),
  );

  await db.inserirProduto(
    Produto(
      restauranteId: doceriaId,
      nome: 'Bolo de Chocolate',
      descricao: 'Bolo de chocolate com cobertura',
      preco: 15.00,
    ),
  );

  await db.inserirProduto(
    Produto(
      restauranteId: doceriaId,
      nome: 'Cupcake',
      descricao: 'Cupcake de chocolate',
      preco: 8.00,
    ),
  );

  await db.inserirProduto(
    Produto(
      restauranteId: doceriaId,
      nome: 'Brigadeiro',
      descricao: 'Brigadeiro tradicional',
      preco: 3.50,
    ),
  );

  // =========================
  // RESTAURANTE 2
  // =========================

  final hamburgueriaId = await db.inserirRestaurante(
    Restaurante(
      nome: 'Hamburgueria Top',
      tipo: 'salgado',
      descricao: 'Lanches artesanais',
    ),
  );

  await db.inserirProduto(
    Produto(
      restauranteId: hamburgueriaId,
      nome: 'X-Burguer',
      descricao: 'Hambúrguer com queijo',
      preco: 22.00,
    ),
  );

  await db.inserirProduto(
    Produto(
      restauranteId: hamburgueriaId,
      nome: 'Batata Frita',
      descricao: 'Porção de batata frita',
      preco: 12.00,
    ),
  );

  await db.inserirProduto(
    Produto(
      restauranteId: hamburgueriaId,
      nome: 'Refrigerante',
      descricao: 'Lata 350ml',
      preco: 6.00,
    ),
  );

  // =========================
  // RESTAURANTE 3
  // =========================

  final pizzariaId = await db.inserirRestaurante(
    Restaurante(
      nome: 'Pizzaria Bella',
      tipo: 'salgado',
      descricao: 'Pizzas artesanais',
    ),
  );

  await db.inserirProduto(
    Produto(
      restauranteId: pizzariaId,
      nome: 'Pizza Calabresa',
      descricao: 'Pizza de calabresa',
      preco: 45.00,
    ),
  );

  await db.inserirProduto(
    Produto(
      restauranteId: pizzariaId,
      nome: 'Pizza Frango',
      descricao: 'Pizza de frango com catupiry',
      preco: 48.00,
    ),
  );

  // Marca que já foi inicializado
  await prefs.setBool(
    'banco_inicializado',
    true,
  );
}