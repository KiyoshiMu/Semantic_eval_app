import 'package:eval_app/app.dart';
import 'package:eval_app/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();

  runApp(EvalApp());
}
