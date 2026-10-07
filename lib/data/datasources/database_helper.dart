import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/snack_model.dart';
import '../models/user_model.dart';
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

  /// Login authentication method
  Future<UserModel?> login(String username, String password) async {
    if (kIsWeb) {
      // Fallback for Web platform where SQLite isn't available
      if (username == 'admin' && password == '123') {
        return const UserModel(
          id: 1,
          username: 'admin',
          role: 'admin',
        );
      }
      return null;
    }

    try {
      final db = await database;
      final List<Map<String, dynamic>> results = await db.query(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [username.trim(), password],
        limit: 1,
      );

      if (results.isNotEmpty) {
        return UserModel.fromMap(results.first);
      }

      // Fallback if seeded data was somehow not matched
      if (username.trim() == 'admin' && password == '123') {
        return const UserModel(
          id: 1,
          username: 'admin',
          role: 'admin',
        );
      }

      return null;
    } catch (e) {
      // If any db error, check fallback
      if (username.trim() == 'admin' && password == '123') {
        return const UserModel(
          id: 1,
          username: 'admin',
          role: 'admin',
        );
      }
      return null;
    }
  }

  /// Fetch all snacks from database (with fallback to dummy data)
  Future<List<SnackModel>> getSnacks() async {
    if (kIsWeb) {
      return dummySnacks;
    }

    try {
      final db = await database;
      final List<Map<String, dynamic>> results = await db.query('snacks');
      if (results.isNotEmpty) {
        return results.map((map) => SnackModel.fromMap(map)).toList();
      }
      return dummySnacks;
    } catch (e) {
      return dummySnacks;
    }
  }

  /// Add new snack to database
  Future<int> insertSnack(SnackModel snack) async {
    if (kIsWeb) return 1;
    final db = await database;
    return await db.insert(
      'snacks',
      snack.toDatabaseMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Update existing snack in database
  Future<int> updateSnack(SnackModel snack) async {
    if (kIsWeb) return 1;
    final db = await database;
    return await db.update(
      'snacks',
      snack.toDatabaseMap(),
      where: 'id = ?',
      whereArgs: [snack.id],
    );
  }

  /// Delete snack from database
  Future<int> deleteSnack(String snackId) async {
    if (kIsWeb) return 1;
    final db = await database;
    return await db.delete(
      'snacks',
      where: 'id = ?',
      whereArgs: [snackId],
    );
  }
}
