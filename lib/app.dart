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
        home: BlocProvider(
          create: (context) => EvaluationBloc(),
          child: Frame(evaluationRepository: evaluationRepository),
        ));
  }
}

class Frame extends StatefulWidget {
  const Frame({
    Key key,
    @required this.evaluationRepository,
  }) : super(key: key);

  final EvaluationRepository evaluationRepository;

  @override
  _FrameState createState() => _FrameState();
}

class _FrameState extends State<Frame> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: EvaluationPage(
          evaluationRepository: widget.evaluationRepository,
          pageController: _pageController,
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.linear,
                  );
                },
                child: Icon(Icons.navigate_before),
              ),
              FloatingActionButton(
                onPressed: () {
                  BlocProvider.of<EvaluationBloc>(context).add(SubmitEval());
                  _nextpage();
                },
                child: Icon(Icons.check),
              ),
              FloatingActionButton(
                onPressed: () {
                  _nextpage();
                },
                child: Icon(Icons.navigate_next),
              )
            ],
          ),
        ));
  }

  Future<void> _nextpage() {
    return _pageController.nextPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }
}
