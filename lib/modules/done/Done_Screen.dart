import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mimoo/shared/cubit/cubit.dart';
import 'package:mimoo/shared/cubit/states.dart';
import '../../shared/components/components.dart';

// ignore: camel_case_types
class DoneTasks_Screen extends StatelessWidget {
  const DoneTasks_Screen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context)=> BlocConsumer<AppCubit, AppStates>(
    listener: (context, state) {},
    builder: (context, state) {
      var tasks = AppCubit.get(context).doneTasks;
      return DefultDataCondition(tasks);
    },

  );
}
