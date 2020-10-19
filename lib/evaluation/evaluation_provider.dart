import 'dart:async';
import 'dart:convert';

import 'package:eval_app/evaluation/index.dart';
import 'package:flutter/services.dart';

class EvaluationProvider {
  static const resultPath = 'assets/results.json';
  List<EvaluationModel> results;
  EvaluationProvider();

  Future<EvaluationModel> fetchEvaluation(int index) async {
    if (results == null) {
      final resultString = await getFileData(resultPath);
      results = parseResults(resultString);
    }
    return results[index];
  }

  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  List<EvaluationModel> parseResults(String resultString) {
    final data = json.decode(resultString) as List;

    return data.map((json) => EvaluationModel.fromJson(json)).toList();
  }
}
