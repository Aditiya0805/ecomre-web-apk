import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dummy_snack.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError(
        'SQLite database is not available on web platform. Run on Android/iOS/Desktop for database features.',
      );
    }
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'snackdistro.db');

    return openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY,
          username TEXT,
          password TEXT,
          role TEXT
        )
        ''');

        await db.execute('''
        CREATE TABLE snacks (
          id TEXT PRIMARY KEY,
          name TEXT,
          price REAL,
          description TEXT,
          image_url TEXT,
          stock INTEGER
        )
        ''');

        await db.execute('''
        CREATE TABLE orders (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          customer_name TEXT,
          total_amount REAL,
          order_date TEXT
        )
        ''');

        await db.execute('''
        CREATE TABLE order_items (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          order_id INTEGER,
          snack_id TEXT,
          quantity INTEGER,
          subtotal REAL
        )
        ''');

        await _seedInitialData(db);
      },
    );
  }

  Future<void> _seedInitialData(Database db) async {
    await db.insert(
      'users',
      {
        'id': 1,
        'username': 'admin',
        'password': '123',
        'role': 'admin',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    for (final snack in dummySnacks) {
      await db.insert(
        'snacks',
        snack.toDatabaseMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
