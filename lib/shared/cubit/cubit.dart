import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mimoo/shared/cubit/states.dart';
import '../../modules/archived/Archived_Screen.dart';
import '../../modules/done/Done_Screen.dart';
import '../../modules/tasks/Tasks_Screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialStates());

  static AppCubit get(context) => BlocProvider.of(context);
  int indNavigationBar = 0;
  bool isShowen = false;
  bool vis = true;
  IconData bicon = (Icons.add);
  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  // ignore: non_constant_identifier_names
  List<String> Titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  List<Widget> screens = [
    Tasks_Screen(),
    DoneTasks_Screen(),
    ArchivedTasks_Screen(),
  ];

  List<bool> visibility = [
    true,
    false,
    false,
  ];

  // ignore: non_constant_identifier_names
  void ChangIndex(value) {
    indNavigationBar = value;
    emit(AppChangesNavigationBar());
  }

  // ignore: non_constant_identifier_names
  void ChangVisibility(int value) {
    if (value == 0) {
      vis = true;
    } else {
      vis = false;
    }
    emit(AppVisibility());
  }

  void CreateDatabase() async {
    database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) async {
        print('database created');
        await database.execute(
            'CREATE TABLE Tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)');
        print('table created');
      },
      onOpen: (database) async {
        GetFromDataBase(database);
        print('Opened Data Base');
        // print('database opened');
      },
    );
  }

  Future insertDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    return database.transaction((txn) async {
      await txn
          .rawInsert(
        'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
      )
          .then((value) {
        print('$value inserted successfully');
        GetFromDataBase(database);
        emit(AppInsertDataBase());
      }).catchError((error) {
        print('Error When Inserting New Record ${error.toString()}');
      });
    });
  }

  // ignore: non_constant_identifier_names
  void GetFromDataBase(dp) async {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    // emit(AppChanges());
    await dp.rawQuery('SELECT * FROM tasks').then((value) {
      dp = value;
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      // print(value);
      emit(AppGetDataBase());
    });
  }

  // ignore: non_constant_identifier_names
  void UpdateData({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      GetFromDataBase(database);
      emit(AppUpdateDataBase());
      // print('$id Updated to $status');
    });
  }

  // ignore: non_constant_identifier_names
  void DeleteElementFromDatabase({
    required int id,
  }) async {
    await database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]);
    // assert(count == 1);
    GetFromDataBase(database);
    emit(AppDeleteElementFromDatabase());
    print('$id Had deleted');
  }

  // ignore: non_constant_identifier_names
  void ChangeBottomSheet({required bool IsShown, required IconData icon}) {
    isShowen = IsShown;
    bicon = icon;
    emit(AppChangeBottomSheet());
  }
}
