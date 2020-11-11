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

  TextEditingController _tController;
  String judge;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tController = TextEditingController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: EvaluationPage(
            evaluationRepository: widget.evaluationRepository,
            pageController: _pageController,
            judge: judge),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
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
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      _setjudge();
                    },
                    child: Icon(Icons.people_alt_sharp),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      _topage();
                    },
                    child: Icon(Icons.search),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      _nextpage();
                    },
                    child: Icon(Icons.navigate_next),
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

  Future<void> _setjudge() async {
    final judge = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      onSubmitted: (s) {
                        Navigator.pop(context, s);
                      },
                      textInputAction: TextInputAction.go,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3,
                      decoration: InputDecoration(
                        labelText: "Enter Your Name",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      controller: _tController,
                    ),
                    FlatButton.icon(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        Navigator.pop(context, _tController.text);
                      },
                      label: Text("OK"),
                    )
                  ]),
            ),
          ),
        );
      },
    );
    BlocProvider.of<EvaluationBloc>(context).add(Updatejudge(judge));
    setState(() {
      this.judge = judge;
    });
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
            textInputAction: TextInputAction.go,
            decoration: InputDecoration(labelText: "Enter your number"),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            onChanged: (value) {
              setState(() {
                page = int.parse(value);
              });
            },
            onSubmitted: (s) {
              Navigator.pop(context, int.parse(s));
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
