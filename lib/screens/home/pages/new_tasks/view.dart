import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller.dart';
import '../../states.dart';
import '../../widgets/items.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppController, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final tasks = AppController.get(context).newTasks;
        return taskBuilder(tasks: tasks );
      },
    );
  }
}
