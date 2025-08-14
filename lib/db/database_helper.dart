// lib/db/database_helper.dart

import 'package:path/path.dart';
import 'package:patrimonios/models/categoria.dart';
import 'package:patrimonios/models/pessoa.dart';
import 'package:sqflite/sqflite.dart';
import '../models/localizacao.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pessoas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        email TEXT,
        telefone TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE localizacoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        endereco TEXT,
        observacoes TEXT
      )
    ''');

      await db.execute('''
    CREATE TABLE categorias (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      tipo TEXT NOT NULL,
      observacoes TEXT
    )
  ''');
  }

  Future<int> inserirLocalizacao(Localizacao localizacao) async {
    final db = await database;
    return await db.insert('localizacoes', localizacao.toMap());
  }

  Future<List<Localizacao>> listarLocalizacoes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('localizacoes');
    return List.generate(maps.length, (i) => Localizacao.fromMap(maps[i]));
  }

  Future<int> atualizarLocalizacao(Localizacao localizacao) async {
    final db = await database;
    return await db.update(
      'localizacoes',
      localizacao.toMap(),
      where: 'id = ?',
      whereArgs: [localizacao.id],
    );
  }
  
  Future<int> deletarLocalizacao(int id) async {
    final db = await database;
    return await db.delete('localizacoes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> inserirPessoa(Pessoa pessoa) async {
    final db = await database;
    return await db.insert('pessoas', pessoa.toMap());
  }

  Future<List<Pessoa>> listarPessoas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('pessoas');
    return List.generate(maps.length, (i) => Pessoa.fromMap(maps[i]));
  }

  Future<int> atualizarPessoa(Pessoa pessoa) async {
    final db = await database;
    return await db.update(
      'pessoas',
      pessoa.toMap(),
      where: 'id = ?',
      whereArgs: [pessoa.id],
    );
  }

  Future<int> deletarPessoa(int id) async {
    final db = await database;
    return await db.delete('pessoas', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> inserirCategoria(Categoria categoria) async {
    final db = await database;
    return await db.insert('categorias', categoria.toMap());
  }

  Future<List<Categoria>> listarCategorias() async {
    final db = await database;
    final maps = await db.query('categorias');
    return maps.map((map) => Categoria.fromMap(map)).toList();
  }

  Future<int> atualizarCategoria(Categoria categoria) async {
    final db = await database;
    return await db.update(
      'categorias',
      categoria.toMap(),
      where: 'id = ?',
      whereArgs: [categoria.id],
    );
  }

  Future<int> deletarCategoria(int id) async {
    final db = await database;
    return await db.delete('categorias', where: 'id = ?', whereArgs: [id]);
  }
}