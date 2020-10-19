import 'package:equatable/equatable.dart';
import 'package:eval_app/evaluation/index.dart';

abstract class EvaluationState extends Equatable {
  final List propss;
  EvaluationState([this.propss]);

  @override
  List<Object> get props => (propss ?? []);
}

class InitEvaluation extends EvaluationState {}

class TagState extends EvaluationState {
  final EvaluationModel evaluationModel;

  TagState(this.evaluationModel);

  TagState update(int evalIdx) {
    return TagState(this.evaluationModel.update(evalIdx));
  }

  @override
  List<Object> get props => [evaluationModel];
}
