import 'package:eval_app/evaluation/evaluation_page.dart';
import 'package:eval_app/evaluation/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          create: (context) => EvaluationBloc(evaluationRepository),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      _nextpage();
                    },
                    child: Icon(Icons.navigate_next),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      _topage();
                    },
                    child: Icon(Icons.search),
                  ),
                ],
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

  Future<void> _topage() async {
    final page = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return NumberPicker(currentPage: _pageController.page.toInt());
        });
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }
}

class NumberPicker extends StatefulWidget {
  final int currentPage;
  const NumberPicker({
    Key key,
    this.currentPage,
  }) : super(key: key);

  @override
  _NumberPickerState createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  int page;
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Go to page ${page ?? ''}"),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: new InputDecoration(labelText: "Enter your number"),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            onChanged: (value) {
              setState(() {
                page = int.parse(value);
              });
            },
          ),
        ),
        ButtonBar(
          children: [
            FlatButton.icon(
              icon: Icon(Icons.check),
              onPressed: () {
                Navigator.pop(context, page);
              },
              label: Text("Go"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.cancel_outlined),
              onPressed: () {
                Navigator.pop(context, widget.currentPage);
              },
              label: Text("Cancel"),
            )
          ],
        ),
      ],
    );
  }
}
