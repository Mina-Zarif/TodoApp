import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import '../cubit/cubit.dart';


// ignore: non_constant_identifier_names
Widget MobData(Map model, context) {
  var cubit = AppCubit.get(context);
  return Dismissible(
    key: Key(model['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 35,
                child: Text(model['time']),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model['title'],
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    Text(
                      model['date'],
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 15,
              ),
              IconButton(
                  onPressed: () {
                    AppCubit.get(context)
                        .UpdateData(status: 'done', id: model['id']);
                  },
                  icon: Icon(Icons.check_box_sharp),
                  color: Colors.green),
              IconButton(
                  onPressed: () {
                    AppCubit.get(context)
                        .UpdateData(status: 'archived', id: model['id']);
                  },
                  icon: Icon(Icons.archive),
                  color: Colors.black38),
            ],
          ),
        ],
      ),
    ),
    onDismissed: (direction) {
      AppCubit.get(context).DeleteElementFromDatabase(
        id: model['id'],
      );
    },
  );
}

// ignore: non_constant_identifier_names
Widget DefultDataCondition(tasks) => ConditionalBuilder(
  condition: tasks.length > 0,
  builder: (context) => ListView.separated(
      itemBuilder: (context, index) => MobData(tasks[index], context),
      separatorBuilder: (context, index) => SizedBox( height: 15),
      itemCount: tasks.length),
  fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            size: 62,
            color: Colors.grey,
          ),
          Text(
            'No Tasks yet',
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey,fontSize: 25),
          )
        ],
      ),
  )
);
