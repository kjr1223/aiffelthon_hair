import 'package:aiffelthon_hair/sqlfite_database/database_helper.dart';

Future<List<Map<String, dynamic>>> getAnalysisResults() async {
  final db = await DatabaseHelper.instance.database;
  return await db.query('analysis_results', orderBy: 'id DESC');
}
