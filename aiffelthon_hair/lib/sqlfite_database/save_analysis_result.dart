import 'dart:io';
import 'package:aiffelthon_hair/sqlfite_database/analysis_result_model.dart';
import 'package:aiffelthon_hair/sqlfite_database/database_helper.dart';

Future<void> saveAnalysisResult(AnalysisResult analysisResult) async {
  final db = await DatabaseHelper.instance.database;
  await db.insert('analysis_results', analysisResult.toMap());
  print('analysis_result.db에 데이터가 저장되었습니다.');
}
