import 'package:equatable/equatable.dart';

/// use https://marketplace.visualstudio.com/items?itemName=BendixMa.dart-data-class-generator
class EvaluationModel extends Equatable {
  static const tags = [
    "acute leukemia",
    "acute lymphoblastic leukemia",
    "acute myeloid leukemia",
    "acute promyelocytic leukemia",
    "basophilia",
    "chronic myeloid leukemia",
    "eosinophilia",
    "erythroid hyperplasia",
    "granulocytic hyperplasia",
    "hemophagocytosis",
    "hypercellular",
    "hypocellular",
    "inadequate",
    "iron deficiency",
    "lymphoproliferative disorder",
    "mastocytosis",
    "metastatic",
    'monocytosis',
    "myelodysplastic syndrome",
    "myeloproliferative neoplasm",
    "normal",
    "plasma cell neoplasm",
    "reactive plasma cells",
    "red cell aplasia"
  ];

  final int id;
  final Map text;
  final List prob;
  final List predTag;
  final List evalTag;
  final bool isDone;
  EvaluationModel(this.id, this.text, this.prob, this.predTag, this.evalTag,
      {this.isDone = false});

  EvaluationModel markDone(bool isDone) {
    if (isDone) {
      return EvaluationModel(
          this.id, this.text, this.prob, this.predTag, this.evalTag,
          isDone: true);
    }
    return this;
  }

  EvaluationModel update(int evalIdx) {
    evalTag[evalIdx] = !evalTag[evalIdx];
    return EvaluationModel(
        this.id, this.text, this.prob, this.predTag, evalTag);
  }

  Iterable<Result> iter() {
    return tags.map((e) {
      final idx = tags.indexOf(e);
      return Result(idx, e, prob[idx].toString(), evalTag[idx]);
    });
  }

  @override
  List<Object> get props => [id, text, predTag, evalTag];

  factory EvaluationModel.fromJson(json) {
    final probTmp = json['prob'] as List;
    final probs = probTmp.map((e) => e[1]).toList();
    final output = EvaluationModel(json['id'], json['text'], probs,
        json['pred'], []..addAll(json['pred']));
    return output;
  }

  Map<String, dynamic> toJudge() {
    List<String> rets = [];
    predTag.asMap().forEach((key, value) {
      if (value) rets.add(tags[key]);
    });
    List<String> evals = [];
    evalTag.asMap().forEach((key, value) {
      if (value == true) evals.add(tags[key]);
    });

    return {
      'text': this.id.toString(),
      'pred': rets.join(", "),
      'eval': evals.join(", "),
    };
  }
}

class Result {
  final int idx;
  final String tag;
  final String prob;
  final bool check;

  Result(this.idx, this.tag, this.prob, this.check);
}
