import 'dart:async';

import 'package:eval_app/evaluation/index.dart';

class EvaluationRepository {
  final EvaluationProvider _evaluationProvider = EvaluationProvider();

  EvaluationRepository();

  Future<EvaluationModel> fetchEvaluation(int index, String judge) {
    return _evaluationProvider.fetchEvaluation(index, judge);
  }

  Future<Set<String>> getDone() {
    return _evaluationProvider.getDone();
  }

  Future<void> writeEval(EvaluationModel evaluationModel,
      {String judge: "Someone"}) async {
    return _evaluationProvider.writeEval(evaluationModel, judge);
  }
}
