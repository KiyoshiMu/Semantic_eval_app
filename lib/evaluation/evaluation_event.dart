import 'dart:async';

import 'package:eval_app/evaluation/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class EvaluationEvent {
  Stream<EvaluationState> applyAsync(
      {EvaluationState currentState, EvaluationBloc bloc});
}

class UpdateEval extends EvaluationEvent {
  final int evalIdx;

  UpdateEval(this.evalIdx);

  @override
  Stream<EvaluationState> applyAsync(
      {EvaluationState currentState, EvaluationBloc bloc}) async* {
    if (currentState is TagState) {
      yield InitEvaluation();
      yield currentState.update(evalIdx);
    }
  }
}

class Updatejudge extends EvaluationEvent {
  final String judge;

  Updatejudge(this.judge);

  @override
  Stream<EvaluationState> applyAsync(
      {EvaluationState currentState, EvaluationBloc bloc}) async* {
    bloc.judge = this.judge;
    yield currentState;
  }
}

class ShowEval extends EvaluationEvent {
  final EvaluationModel evaluationModel;

  ShowEval(this.evaluationModel);

  @override
  Stream<EvaluationState> applyAsync(
      {EvaluationState currentState, EvaluationBloc bloc}) async* {
    yield TagState(evaluationModel);
  }
}

class SubmitEval extends EvaluationEvent {
  SubmitEval();

  @override
  Stream<EvaluationState> applyAsync(
      {EvaluationState currentState, EvaluationBloc bloc}) async* {
    if (currentState is TagState) {
      bloc.evaluationRepository
          .writeEval(currentState.evaluationModel, judge: bloc.judge);
      yield InitEvaluation();
    }
  }
}
