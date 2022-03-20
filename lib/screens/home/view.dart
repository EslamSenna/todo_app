import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/screens/home/states.dart';
import 'package:todo_app/screens/home/widgets/items.dart';

import 'controller.dart';

class HomeScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppController()..createDatabase(),
      child: BlocConsumer<AppController, AppStates>(
        listener: (context, state) {
          if (state is InsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final controller = AppController.get(context);
          return Scaffold(
            key: scaffoldKey,
            body: ConditionalBuilder(
                builder: (context) => controller.pages[controller.currentIndex],
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()),
                condition: state is! GetDatabaseLoadingState),
            appBar: AppBar(
              title: Text(controller.titles[controller.currentIndex]),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (controller.isBottomSheetShow) {
                    if (formKey.currentState!.validate()) {
                      controller.insertToDatabase(
                          time: timeController.text,
                          date: dateController.text,
                          title: titleController.text);
                    }
                  } else {
                    scaffoldKey.currentState!
                        .showBottomSheet(
                          (context) => Container(
                            padding: EdgeInsets.all(20),
                            color: Colors.white,
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DefaultFormField(
                                    controller: titleController,
                                    type: TextInputType.text,
                                    validator: 'title must not be empty',
                                    labelText: 'Task Title',
                                    prefixIcon: Icons.title,
                                    onTap: () {},
                                  ),
                                  DefaultFormField(
                                    controller: timeController,
                                    type: TextInputType.datetime,
                                    validator: 'title must not be empty',
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                    labelText: 'Task Time',
                                    prefixIcon: Icons.watch_later_outlined,
                                  ),
                                  DefaultFormField(
                                    controller: dateController,
                                    type: TextInputType.datetime,
                                    validator: 'Date must not be empty',
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse('2022-05-04'))
                                          .then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    labelText: 'Task Date',
                                    prefixIcon: Icons.calendar_today,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          elevation: 20,
                        )
                        .closed
                        .then((value) {
                      controller.changeBottomSheetState(isShow: false);
                    });
                    controller.changeBottomSheetState(isShow: true);
                  }
                },
                child: Icon(controller.isBottomSheetShow == false
                    ? Icons.edit
                    : Icons.add)),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: controller.currentIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                controller.changeBottomNavBar(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline_outlined),
                    label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.unarchive), label: 'Archived'),
              ],
            ),
          );
        },
      ),
    );
  }
}
