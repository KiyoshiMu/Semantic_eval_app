import 'dart:async';
import 'dart:convert';

import 'package:eval_app/evaluation/index.dart';
import 'package:http/http.dart' as http;

class EvaluationRepository {
  final EvaluationProvider _evaluationProvider = EvaluationProvider();
  static const evalUrl = "https://gosheet-bqjlnzid4q-uc.a.run.app/add";

  EvaluationRepository();

  Future<EvaluationModel> fetchEvaluation(int index) {
    return _evaluationProvider.fetchEvaluation(index);
  }

  Future<Set<int>> getDone() {
    return _evaluationProvider.getDone();
  }

  Future<void> writeEval(EvaluationModel evaluationModel) async {
    final content = evaluationModel.toJudge();
    apiRequest(evalUrl, content);
  }
}

Future<void> apiRequest(String url, Map jsonMap) async {
  await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(jsonMap));
}
