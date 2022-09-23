import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mimoo/shared/cubit/cubit.dart';
import 'package:mimoo/shared/cubit/states.dart';
import '../../shared/components/components.dart';

// ignore: camel_case_types
class Tasks_Screen extends StatelessWidget {
  const Tasks_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)=> BlocConsumer<AppCubit, AppStates>(
    listener: (context, state) {},
    builder: (context, state) {
      var tasks = AppCubit.get(context).newTasks ;
      return DefultDataCondition(tasks);
    },

  );
}
//
//