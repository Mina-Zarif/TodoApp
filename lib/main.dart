import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mimoo/layout/todo_Home_Screen.dart';
import 'package:mimoo/shared/cubit/BlocObserver.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home_Screen(),
    );
  }
}
