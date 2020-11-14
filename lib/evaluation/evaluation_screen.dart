import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eval_app/evaluation/index.dart';

class EvaluationScreen extends StatelessWidget {
  // static const header = ["Tag", 'Prob', "Check"];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EvaluationBloc, EvaluationState>(
      builder: (context, state) {
        if (state is TagState) {
          final results = state.evaluationModel.iter().toList();
          results.sort((a, b) => b.prob.compareTo(a.prob));
          return PredTable(results: results);
        }
        return Container();
      },
    );
  }
}

class PredTable extends StatefulWidget {
  const PredTable({
    Key key,
    @required this.results,
  }) : super(key: key);

  final List<Result> results;

  @override
  _PredTableState createState() => _PredTableState();
}

class _PredTableState extends State<PredTable> {
  bool sortAscending = false;
  int sortColumnIndex = 1;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final results = widget.results;

    return DataTable(
      sortColumnIndex: sortColumnIndex,
      sortAscending: sortAscending,
      columns: [
        DataColumn(
          label: Text("Tag"),
          onSort: (columnIndex, ascending) {
            setState(() {
              sortAscending = !sortAscending;
              sortColumnIndex = 0;
            });
            if (columnIndex == 0) {
              if (ascending) {
                results.sort((a, b) => a.tag.compareTo(b.tag));
              } else {
                results.sort((a, b) => b.tag.compareTo(a.tag));
              }
            }
          },
        ),
        DataColumn(
          label: Text("Prob"),
          numeric: true,
          onSort: (columnIndex, ascending) {
            setState(() {
              sortAscending = !sortAscending;
              sortColumnIndex = 1;
            });
            if (columnIndex == 1) {
              if (ascending) {
                results.sort((a, b) => a.prob.compareTo(b.prob));
              } else {
                results.sort((a, b) => b.prob.compareTo(a.prob));
              }
            }
          },
        ),
        const DataColumn(label: Text("Check"))
      ],
      rows: results
          .map((e) => DataRow(cells: [
                DataCell(Text(e.tag)),
                DataCell(Text(e.prob.toStringAsFixed(3))),
                DataCell(Checkbox(
                  onChanged: (bool value) {
                    BlocProvider.of<EvaluationBloc>(context)
                        .add(UpdateEval(e.idx));
                  },
                  value: e.check,
                ))
              ]))
          .toList(),
    );
  }
}
