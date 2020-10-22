import 'dart:async';
import 'dart:convert';

import 'package:eval_app/evaluation/index.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class EvaluationProvider {
  static const resultPath = 'assets/eval.json';
  static const url = "https://gosheet-bqjlnzid4q-uc.a.run.app/done";

  List<EvaluationModel> results;
  EvaluationProvider();

  Future<EvaluationModel> fetchEvaluation(int index) async {
    if (results == null) {
      final resultString = await getFileData(resultPath);
      results = parseResults(resultString);
    }
    final done = await getDone();
    final isDone = done.contains(index);
    return results[index].markDone(isDone);
  }

  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  List<EvaluationModel> parseResults(String resultString) {
    final data = json.decode(resultString) as List;
    final output = data.map((json) => EvaluationModel.fromJson(json)).toList();
    return output;
  }

  Future<Set<int>> getDone() async {
    final response = await http.get(url);
    final data = json.decode(response.body) as List;
    final output = data.skip(1).map((e) => int.parse(e[0])).toSet();
    return output;
  }
}
