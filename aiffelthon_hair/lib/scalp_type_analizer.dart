import 'dart:math';

// 코사인 유사도 or 유클리드 거리
List<String> scalpType = ["양호", "건성", "지성", "민감성", "지루성", "염증성", "비듬성", "탈모성"];

// 기준 유형 라벨
List<List<int>> expectedResults = [
  [0, 0, 0, 0, 0, 0], // 양호
  [3, 0, 0, 0, 1, 0], // 건성
  [0, 3, 0, 0, 1, 0], // 지성
  [0, 1, 3, 0, 0, 0], // 민감성
  [3, 0, 2, 0, 2, 2], // 지루성
  [0, 1, 2, 3, 0, 0], // 염증성
  [0, 2, 0, 0, 3, 0], // 비듬성
  [0, 1, 2, 0, 1, 3], // 탈모성
];

// 코사인 유사도 측정
double cosineSimilarity(List<int> A, List<int> B) {
  double dotProduct = 0.0;
  double normA = 0.0;
  double normB = 0.0;
  for (int i = 0; i < A.length; i++) {
    dotProduct += A[i] * B[i];
    normA += A[i] * A[i];
    normB += B[i] * B[i];
  }
  return dotProduct / (sqrt(normA) * sqrt(normB));
}

String getMostSimilarScalpType(List<List<double>> predictResult) {
  List<int> predictedLabels = predictResult
      .map((row) =>
          row.indexOf(row.reduce((curr, next) => curr > next ? curr : next)))
      .toList();
  double maxSimilarity = -1.0;
  int mostSimilarIndex = -1;

  for (int i = 0; i < expectedResults.length; i++) {
    double similarity = cosineSimilarity(predictedLabels, expectedResults[i]);
    if (similarity > maxSimilarity) {
      maxSimilarity = similarity;
      mostSimilarIndex = i;
    }
  }
  print("predictedLabels : $predictedLabels");
  print("mostSimilarIndex : ${expectedResults[mostSimilarIndex]}");
  return scalpType[mostSimilarIndex];
}
