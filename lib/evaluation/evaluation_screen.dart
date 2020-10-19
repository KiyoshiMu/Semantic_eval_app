import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eval_app/evaluation/index.dart';

class EvaluationScreen extends StatelessWidget {
  static const header = ["Tag", 'Prob', "Check"];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EvaluationBloc, EvaluationState>(
      builder: (context, state) {
        if (state is TagState) {
          final columns =
              header.map((e) => DataColumn(label: Text(e))).toList();
          final rows = state.evaluationModel
              .iter()
              .map((e) => DataRow(cells: [
                    DataCell(Text(e.tag)),
                    DataCell(Text(e.prob)),
                    DataCell(Checkbox(
                      onChanged: (bool value) {
                        BlocProvider.of<EvaluationBloc>(context)
                            .add(UpdateEval(e.idx));
                      },
                      value: e.check,
                    ))
                  ]))
              .toList();
          return DataTable(
            columns: columns,
            rows: rows,
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
