import 'dart:async';
import 'dart:convert';

import 'package:eval_app/evaluation/index.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class EvaluationProvider {
  static const resultPath = 'assets/eval.json';
  static const doneUrl = "https://gosheet-bqjlnzid4q-uc.a.run.app/done";
  static const evalUrl = "https://gosheet-bqjlnzid4q-uc.a.run.app/add";

  List<EvaluationModel> results;
  EvaluationProvider();
  Set<String> doneIndices;

  Future<EvaluationModel> fetchEvaluation(int index, String judge) async {
    if (results == null) {
      final resultString = await _getFileData(resultPath);
      results = _parseResults(resultString);
    }
    final done = await getDone();
    final isDone = done.contains(index.toString() + judge);
    return results[index].markDone(isDone);
  }

  Future<String> _getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  List<EvaluationModel> _parseResults(String resultString) {
    final data = json.decode(resultString) as List;
    final output = data.map((json) => EvaluationModel.fromJson(json)).toList();
    return output;
  }

  Future<Set<String>> getDone() async {
    if (this.doneIndices != null) {
      return this.doneIndices;
    }
    final response = await http.get(doneUrl);
    final data = json.decode(response.body) as List;
    final output =
        data.skip(1).map((e) => e[0].toString() + e[1].toString()).toSet();
    this.doneIndices = output;
    return output;
  }

  Future<void> writeEval(EvaluationModel evaluationModel, String judge) async {
    final content = evaluationModel.toJudge();
    content['judge'] = judge;
    _apiRequest(evalUrl, content);
    this.doneIndices.add(evaluationModel.id.toString() + judge);
  }

  Future<void> _apiRequest(String url, Map jsonMap) async {
    await http.post(url,
        headers: const <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(jsonMap));
  }
}
