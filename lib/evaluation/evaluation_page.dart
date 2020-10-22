import 'package:flutter/material.dart';
import 'package:eval_app/evaluation/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EvaluationPage extends StatelessWidget {
  final EvaluationRepository evaluationRepository;
  final PageController pageController;
  const EvaluationPage(
      {Key key, this.evaluationRepository, this.pageController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemBuilder: (BuildContext context, int index) {
        return FutureBuilder(
          future: evaluationRepository.fetchEvaluation(index),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              final evaluationModel = snapshot.data as EvaluationModel;
              BlocProvider.of<EvaluationBloc>(context)
                  .add(ShowEval(evaluationModel));
              return ListView(
                children: [
                  Text(
                    "Synopsis ${evaluationModel.id} ${evaluationModel.isDone ? 'Done' : ''}",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Content(text: evaluationModel.text),
                  Text("Prediction",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3),
                  EvaluationScreen(),
                ],
              );
            }
            return Container();
          },
        );
      },
    );
  }
}

class Content extends StatelessWidget {
  const Content({Key key, this.text}) : super(key: key);
  final Map text;
  static const header = ["Field", "Description"];
  @override
  Widget build(BuildContext context) {
    final columns = header.map((e) => DataColumn(label: Text(e))).toList();
    final List<DataRow> rows = [];
    text.forEach((key, value) =>
        rows.add(DataRow(cells: [DataCell(Text(key)), DataCell(Text(value))])));
    return DataTable(
      columns: columns,
      rows: rows,
    );
  }
}
