import 'package:eval_app/evaluation/evaluation_page.dart';
import 'package:eval_app/evaluation/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'evaluation/evaluation_repository.dart';

class EvalApp extends StatelessWidget {
  const EvalApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final evaluationRepository = EvaluationRepository();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: BlocProvider(
          create: (context) => EvaluationBloc(),
          child: EvaluationPage(
            evaluationRepository: evaluationRepository,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.check),
        ),
      ),
    );
  }
}
