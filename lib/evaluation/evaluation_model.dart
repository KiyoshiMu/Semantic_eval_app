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
    "myelodysplastic syndrome",
    "myeloproliferative neoplasm",
    "normal",
    "plasma cell neoplasm",
    "reactive plasma cells",
    "red cell aplasia"
  ];

  final int id;
  final Map text;
  final List<double> prob;
  final List<bool> predTag;
  final List<bool> evalTag;
  EvaluationModel(this.id, this.text, this.prob, this.predTag, this.evalTag);

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
    return EvaluationModel(
        json['id'] ?? 1,
        json['text'],
        json['prob'] ?? List.filled(24, 0.5),
        json['predTag'] ?? List.filled(24, true),
        json['evalTag'] ?? List.filled(24, true));
  }
}

class Result {
  final int idx;
  final String tag;
  final String prob;
  final bool check;

  Result(this.idx, this.tag, this.prob, this.check);
}
