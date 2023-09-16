import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath();
    print("Database Path: $path");
    final db = await openDatabase(
      'hair_analysis.db',
      version: 1,
      onCreate: _onCreate,
    );
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE analysis_results (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      image_path TEXT,
      scalp_type REAL,
      result_1 REAL,
      result_2 REAL,
      result_3 REAL,
      result_4 REAL,
      result_5 REAL,
      result_6 REAL,
      analysis_date DATETIME
    )
  ''');
  }
}
