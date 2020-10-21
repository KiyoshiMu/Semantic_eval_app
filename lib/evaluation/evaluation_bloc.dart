import 'dart:async';
import 'dart:developer' as developer;
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:eval_app/evaluation/index.dart';
import 'package:http/http.dart' as http;

class EvaluationBloc extends Bloc<EvaluationEvent, EvaluationState> {
  static const url =
      "https://cors-anywhere.herokuapp.com/gosheet-bqjlnzid4q-uc.a.run.app/add";
  final httpClient = http.Client();
  EvaluationBloc() : super(InitEvaluation());
  @override
  Stream<EvaluationState> mapEventToState(
    EvaluationEvent event,
  ) async* {
    try {
      yield* event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'EvaluationBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }

  Future<void> writeEval(EvaluationModel evaluationModel) async {
    final content = evaluationModel.toJudge();
    print(content);
    apiRequest(httpClient, url, content);
  }
}

Future<String> apiRequest(
    http.Client httpClient, String url, Map jsonMap) async {
  httpClient.post(url, body: jsonMap);
}
