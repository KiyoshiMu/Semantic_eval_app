import 'dart:async';

import 'package:eval_app/evaluation/index.dart';

class EvaluationRepository {
  final EvaluationProvider _evaluationProvider = EvaluationProvider();

  EvaluationRepository();

  Future<EvaluationModel> fetchEvaluation(int index) {
    return _evaluationProvider.fetchEvaluation(index);
  }
}
