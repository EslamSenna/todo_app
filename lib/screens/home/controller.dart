import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/screens/home/pages/archive_tasks/view.dart';
import 'package:todo_app/screens/home/pages/done_tasks/view.dart';
import 'package:todo_app/screens/home/pages/new_tasks/view.dart';
import 'package:todo_app/screens/home/states.dart';

class AppController extends Cubit<AppStates> {
  AppController() : super(InitialState());

  static AppController get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  bool isBottomSheetShow = false;
  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  var pages = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  var titles = [
    'Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeBottomNavBar(index) {
    currentIndex = index;
    emit(ChangeBottomNavBarState());
  }

  // 1. create database
  // 2. create tables
  // 3. open database
  // 4. insert database
  // 5. get from database
  // 6. update in database
  // 7. delete from database

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      print('database created');
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) {
        print('table created');
      }).catchError((error) {
        print('Error When Creating Table ${error.toString()}');
      });
    }, onOpen: (database) {
      getDataFromDatabase(database);
      print('database opened');
    }).then((value) {
      database = value;
      emit(CreateDatabaseState());
    });
  }

  void insertToDatabase({String? title, String? time, String? date}) async {
    await database!.transaction((txn) async {
      txn
          .rawInsert(
        'INSERT INTO tasks(title, date, time, status) VALUES("$title","$date","$time","new")',
      )
          .then((value) {
        print('$value inserted successfully');
        emit(InsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('Error When Creating New Record ${error.toString()}');
      });
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(GetDatabaseLoadingState());
    database!.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(GetDatabaseState());
    });
  }

  void changeBottomSheetState({bool? isShow}) {
    isBottomSheetShow = isShow!;
    emit(ChangeBottomSheetState());
  }

  void updateData({
    String? status,
    int? id,
  }) async {
    database!.rawUpdate(
      'UPDATE Tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(UpdateDatabaseState());
    });
  }

  void deleteData({required int? id}) async {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(DeleteDatabaseState());
    });
  }
}
