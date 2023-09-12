import 'dart:io';
import 'package:aiffelthon_hair/database/database_helper.dart';

Future<void> saveAnalysisResult(File image, List<double> predictResult) async {
  final db = await DatabaseHelper.instance.database;
  await db.insert('analysis_results', {
    'image_path': image.path,
    'result_1': predictResult[0],
    'result_2': predictResult[1],
    'result_3': predictResult[2],
    'result_4': predictResult[3],
    'analysis_date': DateTime.now().toString()
  });
  print('analysis_result.db에 데이터가 저장되었습니다.');
}
