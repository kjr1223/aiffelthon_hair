import 'package:intl/intl.dart';

class AnalysisResult {
  final String imagePath;
  final DateTime analysisDate;
  final String scalpType;
  final String result1;
  final String result2;
  final String result3;
  final String result4;
  final String result5;
  final String result6;

  AnalysisResult({
    required this.imagePath,
    required this.analysisDate,
    required this.scalpType,
    required this.result1,
    required this.result2,
    required this.result3,
    required this.result4,
    required this.result5,
    required this.result6,
  });

  // Convert a AnalysisResult into a Map. Useful for inserting in the database
  Map<String, dynamic> toMap() {
    return {
      'image_path': imagePath,
      'analysis_date': DateFormat('yyyy-MM-dd').format(analysisDate),
      'scalp_type': scalpType, // Convert to string for storage
      'result_1': result1,
      'result_2': result2,
      'result_3': result3,
      'result_4': result4,
      'result_5': result5,
      'result_6': result6,
    };
  }

  // // Convert a Map into a AnalysisResult
  // static AnalysisResult fromMap(Map<String, dynamic> map) {
  //   return AnalysisResult(
  //     imagePath: map['image_path'],
  //     analysisDate: DateTime.parse(map['analysis_date']),
  //     result1: map['result_1'],
  //     result2: map['result_2'],
  //     result3: map['result_3'],
  //     result4: map['result_4'],
  //     result5: map['result_5'],
  //     result6: map['result_6'],
  //   );
  // }
}
