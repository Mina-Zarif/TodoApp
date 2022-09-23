import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:mimoo/shared/cubit/cubit.dart';
import 'package:mimoo/shared/cubit/states.dart';


class Home_Screen extends StatefulWidget {
  Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

// ignore: camel_case_types
class _Home_ScreenState extends State<Home_Screen> {
  // ignore: non_constant_identifier_names
  var Scaffold_Key = GlobalKey<ScaffoldState>();

  // ignore: non_constant_identifier_names
  var form_key = GlobalKey<FormState>();

  var titleController = TextEditingController();

  var timeController = TextEditingController();

  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..CreateDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: Scaffold_Key,
            appBar: AppBar(
              title: Text(
                cubit.Titles[cubit.indNavigationBar],
              ),
            ),
            body: cubit.screens[cubit.indNavigationBar],
            floatingActionButton: Visibility(
              visible: cubit.visibility[cubit.indNavigationBar],
              child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      cubit.visibility[cubit.indNavigationBar] = false;
                    });
                    if (cubit.isShowen == false) {
                      Scaffold_Key.currentState!
                          .showBottomSheet(
                            (context) => Form(
                              key: form_key,
                              child: Container(
                                padding: EdgeInsetsDirectional.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: titleController,
                                      validator: (value) {
                                        if (value.toString().isEmpty) {
                                          return 'Title Must not be empty...!!';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          hintText: 'New Task',
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.title)),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: timeController,
                                      onTap: () {
                                        showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((value) {
                                          timeController.text =
                                              value!.format(context).toString();
                                        });
                                      },
                                      keyboardType: TextInputType.none,
                                      validator: (value) {
                                        if (value.toString().isEmpty) {
                                          return 'Time Must not be empty...!!';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          hintText: 'Time of Task',
                                          border: OutlineInputBorder(),
                                          prefixIcon:
                                              Icon(Icons.watch_later_rounded)),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: dateController,
                                      validator: (value) {
                                        if (value.toString().isEmpty) {
                                          return 'Date Must not be empty...!!';
                                        }
                                        return null;
                                      },
                                      onTap: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(2032))
                                            .then((value) {
                                          dateController.text =
                                              DateFormat.yMMMMd().format(value!);
                                        });
                                      },
                                      keyboardType: TextInputType.none,
                                      decoration: InputDecoration(
                                          hintText: 'Date of Task',
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.calendar_month)),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (form_key.currentState!
                                              .validate()) {
                                            cubit.insertDatabase(
                                                title: titleController.text,
                                                time: timeController.text,
                                                date: dateController.text)
                                                .then((value) {

                                              Navigator.pop(context);
                                              titleController.text = '';
                                              timeController.text = '';
                                              dateController.text = '';
                                              setState(() {
                                                cubit.visibility[cubit.indNavigationBar] = true;
                                              });
                                            });
                                          }
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                            MaterialStateProperty.all<
                                                Color>(Colors.blueAccent)),
                                        child: Text(
                                          'Save Task',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            elevation: 50.0,
                          )
                          .closed
                          .then((value) {
                        setState(() {
                          cubit.visibility[cubit.indNavigationBar] = true;
                        });
                      });
                    }
                  },
                  child: Icon(cubit.bicon)),
            ),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.indNavigationBar,
                onTap: (value) {
                  cubit.ChangIndex(value);
                  // cubit.ChangVisibility(value);
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: 'Tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline), label: 'Done'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive), label: 'Archived'),
                ]),
          );
        },
      ),
    );
  }
}
