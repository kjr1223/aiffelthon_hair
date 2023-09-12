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
    final db = await openDatabase(
      'hair_analysis.db',
      version: 1,
      onCreate: _onCreate,
    );
    return db;
  }
  // 나머지 데이터베이스 관련 메서드를 추가할 수 있습니다.

  void _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE analysis_results (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      image_path TEXT,
      result_1 REAL,
      result_2 REAL,
      result_3 REAL,
      result_4 REAL,
      analysis_date DATETIME
    )
  ''');
  }
}
