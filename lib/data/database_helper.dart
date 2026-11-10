import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import '../models/restaurante.dart';
import '../models/produto.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }

    _database = await _initDB('pedidos_tx.db');

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    if (kIsWeb) {
      return await openDatabase(
        filePath,
        version: 2,
        onCreate: _createDB,
        onUpgrade: _onUpgrade,
      );
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE restaurantes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        tipo TEXT NOT NULL,
        descricao TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE produtos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        restaurante_id INTEGER NOT NULL,
        nome TEXT NOT NULL,
        descricao TEXT,
        preco REAL NOT NULL,
        calorias REAL DEFAULT 0,
        carboidratos REAL DEFAULT 0,
        proteinas REAL DEFAULT 0,
        gorduras REAL DEFAULT 0,
        sodio REAL DEFAULT 0,
        FOREIGN KEY (restaurante_id)
          REFERENCES restaurantes(id)
          ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE produtos ADD COLUMN calorias REAL DEFAULT 0',
      );

      await db.execute(
        'ALTER TABLE produtos ADD COLUMN carboidratos REAL DEFAULT 0',
      );

      await db.execute(
        'ALTER TABLE produtos ADD COLUMN proteinas REAL DEFAULT 0',
      );

      await db.execute(
        'ALTER TABLE produtos ADD COLUMN gorduras REAL DEFAULT 0',
      );

      await db.execute(
        'ALTER TABLE produtos ADD COLUMN sodio REAL DEFAULT 0',
      );
    }
  }

  // RESTAURANTES

  Future<int> inserirRestaurante(Restaurante restaurante) async {
    final db = await database;

    return await db.insert(
      'restaurantes',
      restaurante.toMap(),
    );
  }

  Future<List<Restaurante>> listarRestaurantes() async {
    final db = await database;

    final resultado = await db.query(
      'restaurantes',
      orderBy: 'nome ASC',
    );

    return resultado
        .map((map) => Restaurante.fromMap(map))
        .toList();
  }

  Future<int> atualizarRestaurante(Restaurante restaurante) async {
    final db = await database;

    return await db.update(
      'restaurantes',
      restaurante.toMap(),
      where: 'id = ?',
      whereArgs: [restaurante.id],
    );
  }

  Future<int> excluirRestaurante(int id) async {
    final db = await database;

    await db.delete(
      'produtos',
      where: 'restaurante_id = ?',
      whereArgs: [id],
    );

    return await db.delete(
      'restaurantes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // PRODUTOS

  Future<int> inserirProduto(Produto produto) async {
    final db = await database;

    return await db.insert(
      'produtos',
      produto.toMap(),
    );
  }

  Future<List<Produto>> listarProdutos(int restauranteId) async {
    final db = await database;

    final resultado = await db.query(
      'produtos',
      where: 'restaurante_id = ?',
      whereArgs: [restauranteId],
      orderBy: 'nome ASC',
    );

    return resultado
        .map((map) => Produto.fromMap(map))
        .toList();
  }

  Future<int> atualizarProduto(Produto produto) async {
    final db = await database;

    return await db.update(
      'produtos',
      produto.toMap(),
      where: 'id = ?',
      whereArgs: [produto.id],
    );
  }

  Future<int> excluirProduto(int id) async {
    final db = await database;

    return await db.delete(
      'produtos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}