import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:eval_app/evaluation/index.dart';

class EvaluationBloc extends Bloc<EvaluationEvent, EvaluationState> {
  EvaluationBloc(this.evaluationRepository) : super(InitEvaluation());
  final EvaluationRepository evaluationRepository;
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
}
